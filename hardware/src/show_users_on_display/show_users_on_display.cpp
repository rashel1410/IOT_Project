// cSpell: disable
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_SH110X.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

#include "show_users_on_display.h"

// Define pins
#define I2C_A_SDA 8
#define I2C_A_SCL 9

// OLED parameters
#define SCREEN_WIDTH 128    // OLED display width, in pixels
#define SCREEN_HEIGHT 64    // OLED display height, in pixels
#define OLED_RESET -1       // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C // Change if required
#define ROTATION 0          // Rotates text on OLED 1=90 degrees, 2=180 degrees

// display object
Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

String getUsers()
{
    if (WiFi.status() == WL_CONNECTED)
    {
        HTTPClient http;
        const char *get_users_url = "http://172.20.10.4:8045/get_users";
        http.begin(get_users_url);
        // http.addHeader("Content-Type", "application/json");

        int httpResponseCode = http.GET();
        if (httpResponseCode > 0)
        {
            String response = http.getString();
            return response;
            // Serial.print("Response: ");
            // Serial.println(response);
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

void init_display()
{
    Wire.begin(I2C_A_SDA, I2C_A_SCL);

    if (!display.begin(SCREEN_ADDRESS, true))
    {
        Serial.println(F("Display1 SSD1306 allocation failed"));
        for (;;)
            ; // Don't proceed, loop forever
    }

    display.clearDisplay();
    display.setTextSize(1);             // Normal 1:1 pixel scale
    display.setTextColor(SH110X_WHITE); // Draw white text
    display.setCursor(0, 0);            // Start at top-left corner
    display.setRotation(ROTATION);      // Set screen rotation
}

void show_users_on_display()
{
    String jsonString = getUsers();
    Serial.println(jsonString);
    init_display();
    // display.print("Working!!"); // write on internal buffer
    // display.display();

    // Create a JSON document to parse the received JSON string
    DynamicJsonDocument doc(512);

    // Deserialize the JSON string
    DeserializationError error = deserializeJson(doc, jsonString.c_str());
    if (error)
    {
        Serial.println("Failed to parse JSON!");
        return;
    }

    // Clear the display
    display.clearDisplay();

    // Extract two user names
    const char *userId1 = "1737846361625";
    const char *userId2 = "1737846389474";

    String userName1 = doc[userId1].as<String>();
    String userName2 = doc[userId2].as<String>();

    // Display both names on different lines
    display.clearDisplay();
    display.setCursor(0, 0);
    display.print(userName1); // Line 1
    display.setCursor(0, 10); // Move to the next line
    display.print(userName2); // Line 2
    display.display();
}