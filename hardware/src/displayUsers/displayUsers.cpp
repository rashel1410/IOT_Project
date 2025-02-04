// cSpell: disable
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_SH110X.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <vector>
#include <tuple>

using namespace std;
/****************************************************************/
/* Includes from .h files
/****************************************************************/
#include "displayUsers.h"
/**************************** Globals ***************************/
const int numOfInputs = 3;
const int maxDisplayLines = 7; // Maximum number of lines that fit on the screen
int scrollIndex = 0;           // Index for scrolling
int selectedIndex = 0;         // Index for the selected user
vector<std::tuple<String, String>> users;
String current_user_name;
String current_user_id;

// Define pins
const int inputPins[numOfInputs] = {37, 38, 39}; // up, ok, down
// bool lastButtonState[numOfInputs] = {HIGH, HIGH, HIGH};
// unsigned long lastDebounceTime[numOfInputs] = {0, 0, 0};

bool buttonPressed[numOfInputs] = {false, false, false};
bool user_selected = false;

// OLED parameters
#define I2C_A_SDA 35
#define I2C_A_SCL 36
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C
#define ROTATION 2

Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
/****************************************************************/
void initializeDisplay()
{
    // init display
    Wire.begin(I2C_A_SDA, I2C_A_SCL);

    if (!display.begin(SCREEN_ADDRESS, true))
    {
        Serial.println(F("Display1 SSD1306 allocation failed"));
        for (;;)
            ; // Don't proceed, loop forever
    }

    display.clearDisplay();
    display.setTextColor(SH110X_WHITE); // Draw white text
    display.setRotation(ROTATION);      // Set screen rotation

    // init buttons
    for (int i = 0; i < numOfInputs; i++)
    {
        pinMode(inputPins[i], INPUT_PULLUP);
    }

    String jsonString = getUsers();
    Serial.println(jsonString);
    processJson(jsonString);

    displayUsers(); // Initial display
}
/****************************************************************/
void setCursorAux(int textWidth, int xOffset, int yOffset)
{
    int x = (SCREEN_WIDTH - textWidth) / 2 + xOffset;
    int y = yOffset;
    display.setCursor(x, y);
}
/****************************************************************/
String getUsers()
{
    if (WiFi.status() == WL_CONNECTED)
    {
        HTTPClient http;
        const char *get_users_url = "http://172.20.10.4:8045/get_users";
        http.begin(get_users_url);

        int httpResponseCode = http.GET();
        if (httpResponseCode > 0)
        {
            String response = http.getString();
            return response;
        }
        else
        {
            Serial.print("Error code: ");
            Serial.println(httpResponseCode);
        }
        http.end();
    }
    else
    {
        Serial.println("Wi-Fi Disconnected");
    }
    return "";
}
/****************************************************************/
void processJson(String jsonString)
{
    DynamicJsonDocument doc(512);
    DeserializationError error = deserializeJson(doc, jsonString.c_str());
    if (error)
    {
        Serial.println("Failed to parse JSON!");
        return;
    }

    for (JsonPair kv : doc.as<JsonObject>())
    {
        String userName = kv.value().as<String>();
        String user_id = String(kv.key().c_str());
        users.push_back(make_tuple(userName, user_id));
    }
}
/****************************************************************/
void displayUsers()
{
    display.clearDisplay();

    int textSize = 1;   // Keep text size small
    int lineHeight = 9; // Default font height when text size is 1

    display.setTextSize(textSize);

    int linesToShow = min(maxDisplayLines, (SCREEN_HEIGHT / lineHeight));
    int endIndex = min(scrollIndex + linesToShow, (int)users.size());

    // display.print("Select a User");
    for (int i = scrollIndex; i < endIndex; i++)
    {
        if (i == selectedIndex)
        {
            display.setTextColor(SH110X_BLACK, SH110X_WHITE); // Highlight selected user
        }
        else
        {
            display.setTextColor(SH110X_WHITE);
        }

        setCursorAux(get<0>(users[i]).length() * 6, 0, (i - scrollIndex) * lineHeight); // Center text horizontally
        display.print(get<0>(users[i]));
    }

    display.display();
}
/****************************************************************/
void displayText(String text)
{
    display.clearDisplay();
    int textWidth = text.length() * 6;     // Width per character is 6 pixels at text size 1
    int xOffset = 0;                       // No additional horizontal offset
    int yOffset = (SCREEN_HEIGHT - 9) / 2; // Center vertically for default text size (1)

    setCursorAux(textWidth, xOffset, yOffset);
    display.print(text);
    display.display();
}
/****************************************************************/
void handleButtonClick(int state)
{
    if (state == 0) // up
    {
        if (selectedIndex > 0)
        {
            selectedIndex--;
            if (selectedIndex < scrollIndex)
            {
                scrollIndex--;
            }
            displayUsers();
        }
    }
    else if (state == 1) // select
    {
        Serial.printf("Button pressed: 1\n");
        Serial.printf("handleButtonClick\n");

        display.clearDisplay();
        String labelText = "Welcome";
        String userName = get<0>(users[selectedIndex]);
        current_user_name = userName;
        current_user_id = get<1>(users[selectedIndex]);

        setCursorAux(labelText.length() * 6, 0, 22); // Center "Welcome" text
        display.print(labelText);

        setCursorAux(userName.length() * 6, 0, 38); // Center username text
        display.print(userName);

        // Display "< Back" vertically centered on the left side
        display.setTextColor(SH110X_WHITE);
        display.setCursor(0, (SCREEN_HEIGHT - 8) / 2); // Center vertically
        display.print("< Back");

        display.display();
        user_selected = true;
    }
    else if (state == 2) // down
    {
        if (selectedIndex < (int)users.size() - 1)
        {
            selectedIndex++;
            if (selectedIndex >= scrollIndex + maxDisplayLines)
            {
                scrollIndex++;
            }
            displayUsers();
        }
    }
}
/****************************************************************/
void handleButtonClickAfterSelectingUser()
{
    if (digitalRead(inputPins[1]) == LOW && !buttonPressed[1])
    {
        buttonPressed[1] = true;
        displayUsers();
        user_selected = false;
        delay(500);
    }
    if (digitalRead(inputPins[1]) == HIGH)
    {
        buttonPressed[1] = false;
    }
}
/****************************************************************/
tuple<String, String> handleNavigationButtonClick()
{
    if (!user_selected)
    {
        for (int i = 0; i < numOfInputs; i++)
        {
            if (digitalRead(inputPins[i]) == LOW && !buttonPressed[i])
            {
                handleButtonClick(i);
                delay(500);
            }
            if (digitalRead(inputPins[i]) == HIGH)
            {
                buttonPressed[i] = false;
            }
        }
        return make_tuple("", "");
    }
    return make_tuple(current_user_name, current_user_id);
}
