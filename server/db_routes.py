from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from firebase_config import db
from datetime import datetime
from fastapi import HTTPException
import logging

router = APIRouter()

class FoodNutrients(BaseModel): 
    nutrientName: str
    nutrientNumber: str
    unitName: str
    value: float

class FoodItem(BaseModel):
    name: str
    nutrients: list[FoodNutrients]
    timestamp: datetime
    id: str = None
    weight: float

class User(BaseModel):
    id: str
    name: str
    food_items: list[FoodItem] = []
    goals: dict = {}

@router.post("/add_user")
def add_user(user: User):
    user_ref = db.collection("users").document(user.id)
    user.goals = {"calories": 2000.0, "protein": 200.0, "fats": 50.0, "carbs": 500.0}
    user_ref.set(user.dict(exclude={"food_items"}))
    print("User added successfully.")
    return {"status": "User added successfully"}

@router.post("/add_food/{user_id}")
def add_food(user_id: str, food: FoodItem):
    food_ref = db.collection("users").document(user_id).collection("food_items").document(food.id)
    food_ref.set(food.dict())
    return {"status": "Food added successfully"}


@router.get("/get_last_food_item/{user_id}")
def get_last_item_food_item(user_id: str):
    foods_ref = db.collection("users").document(user_id).collection("food_items").order_by("timestamp", direction="DESCENDING").limit(1).stream()
    
    last_food_item = next(foods_ref, None)
    if last_food_item:
        food_item = last_food_item.to_dict()
        food_item["id"] = last_food_item.id
        print(food_item)
        return food_item
    else:
        raise HTTPException(status_code=404, detail="No food items found for the user")
    
@router.post("/remove_food_item/{user_id}/{item_id}")
def remove_food_item(user_id: str, item_id: str):
    user_ref = db.collection("users").document(user_id)
    food_item_ref = user_ref.collection("food_items").document(item_id)
    
    if not food_item_ref.get().exists:
        raise HTTPException(status_code=404, detail="Food item not found")

    food_item_ref.delete()
    
    return {"status": "Food item removed successfully"}


@router.get("/get_user_foods/{user_id}")
def get_user_foods(user_id: str):
    user_foods = {}
    foods_ref = db.collection("users").document(user_id).collection("food_items").stream()
    user_foods = {food.id : food.to_dict() for food in foods_ref}
    #print(user_foods)
    return user_foods



@router.get("/get_users")
def get_users():
    users_ref = db.collection("users").stream()
    users = {user.id: user.to_dict().get("name", "Unnamed User") for user in users_ref}
    return users



# Mock data routes

@router.post("/add_user_mock_data")
def add_user_mock_data():
    user_profile = User(
        id="user3",
        name="John Doe",
        food_items=[]
    )

    user_ref = db.collection("users").document(user_profile.id)
    user_ref.set(user_profile.dict(exclude={"food_items"}))
    print("User added successfully.")
    return {"status": "User added successfully"}

@router.post("/add_food_mock_data/{user_id}")
def add_food_mock_data(user_id: str):
    # Mock data
    user_food_items = [
        {
            "name": "Apple",
            "nutrients": [
                {"nutrientName": "Vitamin C", "nutrientNumber": "C", "unitName": "mg", "value": 5.0},
                {"nutrientName": "Fiber", "nutrientNumber": "F", "unitName": "g", "value": 2.0},
            ],
            "timestamp": datetime.now()
        },
        {
            "name": "Banana",
            "nutrients": [
                {"nutrientName": "Potassium", "nutrientNumber": "K", "unitName": "mg", "value": 10.0},
                {"nutrientName": "Vitamin B6", "nutrientNumber": "B6", "unitName": "mg", "value": 1.0},
            ],
            "timestamp": datetime.now()
        },
        {
            "name": "Carrot",
            "nutrients": [
                {"nutrientName": "Vitamin A", "nutrientNumber": "A", "unitName": "IU", "value": 100.0},
                {"nutrientName": "Fiber", "nutrientNumber": "F", "unitName": "g", "value": 3.0},
            ],
            "timestamp": datetime.now()
        },
    ]


    user_ref = db.collection("users").document(user_id)
    for food in user_food_items:
        food_ref = user_ref.collection("food_items").document()
        food_ref.set(food)

    print("Mock food items added to Firestore successfully.")