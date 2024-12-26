import firebase_admin
from firebase_admin import credentials, firestore

SERVICE_ACCOUNT_KEY = "accountKey.json"

# Initialize Firebase
cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
firebase_admin.initialize_app(cred)


db = firestore.client()