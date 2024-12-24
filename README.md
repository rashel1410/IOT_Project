## XXXXX Project by :  
  
## Details about the project
 
## Folder description :
* ESP32: source code for the esp side (firmware).
* Documentation: wiring diagram + basic operating instructions
* Unit Tests: tests for individual hardware components (input / output devices)
* flutter_app : dart code for our Flutter app.
* Parameters: contains description of configurable parameters 
* Assets: 3D printed parts, Audio files used in this project, 

## Arduino/ESP32 libraries used in this project:
## Arduino/ESP libraries installed for the project:
* XXXX - version XXXXX
* XXXX - version XXXXX
* XXXX - version XXXXX

## Project Poster:
 
This project is part of ICST - The Interdisciplinary Center for Smart Technologies, Taub Faculty of Computer Science, Technion
https://icst.cs.technion.ac.il/


# In order to run the server:
pull git repo
cd into server 
pip install -r requirements.txt
python main.py

## in order to reach the server 
on windows run ipconfig and look for the IPv4 of the network (probably the WiFi)
MUST BE ON THE SAME WIFI NETWORK (FOR NOW)
this will be the ip you will use as the endpoint.
port 8045.
e.g. http://192.168.167.251:8045/
