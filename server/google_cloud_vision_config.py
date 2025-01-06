from google.cloud import vision

# Specify the credentials JSON file
from google.oauth2 import service_account
credentials = service_account.Credentials.from_service_account_file('vision_api_creds.json')

# Initialize the Vision API client with credentials
vision_client = vision.ImageAnnotatorClient(credentials=credentials)
