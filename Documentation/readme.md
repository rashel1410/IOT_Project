# Server Instructions
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
# Application Instructions

## Running the Application

To run the application, follow these steps:

### 1. Update Base URL
1. Open the file located at `eat_smart/lib/constants.dart`.
2. Change the `baseUrl` variable to the URL you found earlier.

### 2. Run the Server
Ensure the server is running before proceeding to the next steps.

### 3. Set Up Android Emulator
1. Open **Android Studio**.
2. Set up your favorite emulator. We recommend using **Nexus API 30** as it has proven to be the most stable.
3. Under "Device Manager", press the play button to start the emulator.

### 4. Run the Application
1. Open **Visual Studio Code**.
2. Navigate to `lib/main.dart`.
3. Press the play button (or use `F5`) to run the application.

### Additional Notes
- Make sure all dependencies are installed and configured properly.
- If you encounter any issues, consult the application's documentation or seek support from the development team.
