import os
from dotenv import load_dotenv
import google.generativeai as genai
from PIL import Image
import PIL.Image
import base64
import json
from db_routes import router as db_router
from db_routes import FoodItem, FoodNutrients, add_food, add_user_mock_data
import datetime
from dateutil.parser import parse

load_dotenv()

# Configure API key
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def prepare_image_data(image_path="Banana.jpg"):
    """Read image and prepare for API request"""
    with open(image_path, "rb") as file:
        encoded_string = base64.b64encode(file.read()).decode("utf-8")
    
        print(type(file))
        print(type(encoded_string))
        
    image_data = [
        {
            "mime_type": "image/jpeg",  # Adjust mime type depending on your image format
            "data": encoded_string
        }
    ]
    return image_data


def analyze_food_with_gemini(image_path):
    """Analyze the food in the image using Gemini API"""
    try:
        #image_path_1 = "uploaded/captured_image.jpg"  # Replace with the actual path to your first image
        sample_file_1 = PIL.Image.open(image_path)

        model = genai.GenerativeModel(model_name="gemini-1.5-pro")
        prompt = """
            Provide the name of this food item and its nutrition values for a weight of 100 grams
            (Ensure the response is a valid JSON object string without extra characters, headers, or wrapping, so it can be directly passed to `json.loads` in Python.):
            The JSON should be in the following JSON format:
            {
                "name": "<food item name>",
                "nutrients": [
                    {
                        "nutrientName": "<name of the nutrient>",
                        "nutrientNumber": "<nutrient number>",
                        "unitName": "<unit>",
                        "value": <value in float>
                    }
                ],
                "timestamp": "<ISO 8601 timestamp>"
            }
            """
        
        raw_response = model.generate_content([prompt, sample_file_1])
        response = raw_response.text.replace("```json", "").replace("```", "").strip()
        print(response)
        try:
            food_details = json.loads(response)  # This will convert the string into a dictionary
            print("Parsed JSON Response: ", food_details)
        except json.JSONDecodeError:
            print("Response is not valid JSON. Raw response: ", response)
        return food_details
    except Exception as e:
        return {"error"}



# food_json = analyze_food_with_gemini("uploaded/captured_image.jpg")

# nutrients_list = [
#     FoodNutrients(
#         nutrientName=nutrient["nutrientName"],
#         nutrientNumber=str(nutrient["nutrientNumber"]),
#         unitName=nutrient["unitName"],
#         value=float(nutrient["value"])
#     )
#     for nutrient in food_json["nutrients"]
# ]

# # Create the FoodItem object
# parsed_timestamp = parse(food_json["timestamp"])
# food_item = FoodItem(
#     name=food_json["name"],
#     nutrients=nutrients_list,
#     timestamp=parsed_timestamp
# )


# # Access specific attributes
# print("Food name:", food_item.name)
# print("First nutrient name:", food_item.nutrients[0].nutrientName)

# default_user_id = "user2"
# add_food(user_id=default_user_id, food=food_item)
