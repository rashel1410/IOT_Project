import uvicorn
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from models import MsgPayload
from db_routes import router as db_router
from vision_api_routes import router as vision_router
from pydantic import BaseModel
import json


app = FastAPI()
app.include_router(db_router)
app.include_router(vision_router)

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:5000",
    "http://10.100.102.10:8045",
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
        image_path = "uploaded_photos/captured_image.jpg"
        with open(image_path, "wb") as file:
            file.write(image_data)
        
        return JSONResponse(content={"message": "Image received successfully", "size": len(image_data)}, status_code=200)
    
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)


if __name__ == "__main__":
    print("Starting server...")
    uvicorn.run(app, host="0.0.0.0", port=8045)