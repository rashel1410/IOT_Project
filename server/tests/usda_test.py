import requests

url = "http://132.68.34.61:8045/upload_data"
file_path = "/Users/rashelstrigevsky/development/IOT/IOT_Project/server/tests/ananas.jpeg"
print("somethinggg")


with open(file_path, "rb") as f:
    files = {"image": (file_path, f, "image/jpeg")}
    data = {"weight": "100"}
    response = requests.post(url, files=files, data=data)
    print("something")

print(response.json())  # or response.text if JSON response is not expected