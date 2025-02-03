## In order to run the server:
```bash
# Pull git repo
git pull

# Change directory into the server folder
cd server

# Install required Python packages
pip install -r requirements.txt

# Run the main script
python main.py
```
## in order to reach the server 
on windows run 
```bash
ipconfig
```
look for the IPv4 of the network (probably the WiFi)
In order to reach the server you must be on the same network as what was shown by the last command.
This will be the ip you will use as the endpoint.
Port 8045, you can edit it in main.py in the server directory.
example URL:
```bash
http://192.168.167.251:8045/
```
