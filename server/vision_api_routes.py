from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from google.cloud import vision
from google_cloud_vision_config import vision_client
import os


router = APIRouter()

DEFAULT_IMAGE_PATH = "Banana.jpg" 

@router.post("/analyze-image", tags=["Vision API"])
def analyze_image():
    try:
        with open(DEFAULT_IMAGE_PATH, "rb") as image_file:
            content = image_file.read()

        image = vision.Image(content=content)

        response = vision_client.label_detection(image=image)

        if response.error.message:
            raise HTTPException(status_code=500, detail=f"Vision API error: {response.error.message}")

        labels = [{"description": label.description, "score": label.score} for label in response.label_annotations]

        return JSONResponse(content={"labels": labels})

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing the image: {str(e)}")
