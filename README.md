## Nutrition Information Project by Rahaf Egbaria, Yaniv Valdman & Rashel Strigevsy:  
  
## Details about the project
 
## Folder description :
* hardware: source code for the esp side (firmware).
* Documentation: wiring diagram + basic operating instructions
* Unit Tests: tests for individual hardware components (input / output devices)
* eat_smart : dart code for our Flutter app.
* server: a FastAPI server for http requests from hardware and app.
 
## ESP32-S3-WROOM libraries installed for the project:
* adafruit/Adafruit SH110X - version 2.1.11
* adafruit/Adafruit SSD1306 - version 2.5.13
* bblanchon/ArduinoJson - version 7.3.0
* bogde/HX711 - version 0.7.5

## Project Poster:
 
This project is part of ICST - The Interdisciplinary Center for Smart Technologies, Taub Faculty of Computer Science, Technion
https://icst.cs.technion.ac.il/


# In order to run the server:
```bash
# Pull git repo
git pull

# Change directory into the server folder
cd server

# Install required Python packages
pip install -r requirements.txt

# Run the main script
python main.py

## in order to reach the server 
on windows run ipconfig and look for the IPv4 of the network (probably the WiFi)
MUST BE ON THE SAME WIFI NETWORK
this will be the ip you will use as the endpoint.
port 8045.
e.g. http://192.168.167.251:8045/
