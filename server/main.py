import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from models import MsgPayload
from db_routes import router as db_router


app = FastAPI()

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:5000",
    "http://172.20.10.2:8045",  # Add your local IP address here
    "http://172.20.10.1:8045",  # Add your local IP address here
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


app.include_router(db_router)


if __name__ == "__main__":
    print("Starting server...")
    uvicorn.run(app, host="0.0.0.0", port=8045)