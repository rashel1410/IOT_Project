from fastapi.testclient import TestClient
from io import BytesIO
from pathlib import Path
from main import app  # assuming your FastAPI app is in app.py

# Test the upload_data logic
def test_upload_data():
    # Simulate an image file (path to your static image file)
    image_path = "Banana.jpg"  # Path to a static image file on disk
    weight = "140"  # Sample weight for the test

    # Open the image file to simulate it being uploaded
    with open(image_path, "rb") as img_file:
        # Create a test client
        client = TestClient(app)

        # Prepare the form data with the weight and image
        files = {
            "image": ("Banana.jpg", img_file, "image/jpeg")
        }
        data = {"weight": weight}

        # Send the POST request to /upload_data endpoint
        response = client.post("/upload_data", data=data, files=files)

        # Assert the response status
        assert response.status_code == 200
        assert response.json() == {"message": "Data uploaded successfully"}

        # Optionally check that the file was saved correctly
        saved_image_path = Path("uploaded/captured_image.jpg")
        assert saved_image_path.exists()  # Ensure the image file was saved

        # Check that the weight JSON file was saved
        saved_weights_path = Path("uploaded/weights.json")
        assert saved_weights_path.exists()  # Ensure the weights JSON file was saved

test_upload_data()