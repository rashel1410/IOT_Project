import os
import shutil
import uvicorn
from fastapi import FastAPI, HTTPException, Request, File, Form, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from models import MsgPayload
from db_routes import router as db_router
import db_routes
from vision_api_routes import router as vision_router
from gemini_service import analyze_food_with_gemini
from pydantic import BaseModel
from PIL import Image
import google.generativeai as genai
from dotenv import load_dotenv
from db_routes import FoodItem, FoodNutrients, add_food, add_user_mock_data
from dateutil.parser import parse
import json




app = FastAPI()
app.include_router(db_router)
app.include_router(vision_router)

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:5000",
    "http://192.168.68.110:8045",
    #"http://172.20.10.2:8045",  # Add your local IP address here
    #"http://172.20.10.1:8045",  # Add your local IP address here
    # Add other origins as needed
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

messages_list: dict[int, MsgPayload] = {}


@app.get("/")
def root() -> dict[str, str]:
    pass
    return {"message": "Hello"}


# About page route
@app.get("/about")
def about() -> dict[str, str]:
    return {"message": "This is the about page."}


# Route to add a message
@app.post("/messages/{msg_name}/")
def add_msg(msg_name: str) -> dict[str, MsgPayload]:
    # Generate an ID for the item based on the highest ID in the messages_list
    msg_id = max(messages_list.keys()) + 1 if messages_list else 0
    messages_list[msg_id] = MsgPayload(msg_id=msg_id, msg_name=msg_name)

    return {"message": messages_list[msg_id]}


# Route to list all messages
@app.get("/messages")
def message_items() -> dict[str, dict[int, MsgPayload]]:
    return {"messages:": messages_list}


# Define the model for the request body
class WeightData(BaseModel):
    weight: float

# Endpoint to save weight
@app.post("/save_weight")
async def save_weight(data: WeightData):
    try:
        with open("weights.json", "a") as file:
            json.dump(data.dict(), file)
            file.write("\n")
        return "Weight saved successfully!"
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/upload_image")
async def upload_image(request: Request):
    try:
        image_data = await request.body()
        
        # image_path = os.path.join(UPLOAD_DIR, "uploaded_image.jpg")
        image_path = "uploaded/captured_image.jpg"
        with open(image_path, "wb") as file:
            file.write(image_data)
        
        return JSONResponse(content={"message": "Image received successfully", "size": len(image_data)}, status_code=200)
    
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)


@app.post("/upload_data")
async def upload_data(weight: str = Form(...), image: UploadFile = File(...)):
    #image_path = "Banana.jpg"
    # Save weight to JSON file
    weights_data = {"weight": weight}
    with open("uploaded/weights.json", "w") as f:
        json.dump(weights_data, f)
    
    image_path = "uploaded/captured_image.jpg"
    with open(image_path, "wb") as file:
        file.write(await image.read())


    food_item_json = analyze_food_with_gemini(image_path)
    nutrients_list = [
    FoodNutrients(
        nutrientName=nutrient["nutrientName"],
        nutrientNumber=str(nutrient["nutrientNumber"]),
        unitName=nutrient["unitName"],
        value=float(nutrient["value"])
    )
    for nutrient in food_item_json["nutrients"]
]

    # Create the FoodItem object
    parsed_timestamp = parse(food_item_json["timestamp"])
    food_item = FoodItem(
        name=food_item_json["name"],
        nutrients=nutrients_list,
        timestamp=parsed_timestamp
    )


    # Access specific attributes
    print("Food name:", food_item.name)
    print("First nutrient name:", food_item.nutrients[0].nutrientName)

    default_user_id = "user2"
    add_food(user_id=default_user_id, food=food_item)
        
    return {"message": "Data uploaded successfully"}


if __name__ == "__main__":
    print("Starting server...")
    uvicorn.run(app, host="0.0.0.0", port=8045)
