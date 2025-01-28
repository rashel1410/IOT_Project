#include <Arduino.h>
#include <WiFi.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_SH110X.h>
#include <HTTPClient.h>

// WiFi credentials
const char *ssid = "Rahaf";
const char *password = "122334455";

/****************************************************************/
/* Includes
/****************************************************************/
#include "show_users_on_display/show_users_on_display.h"

/****************************************************************/
/* Helper Functions
/****************************************************************/

/****************************************************************/
void setup()
{
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  // Connect to Wi-Fi
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi");

  show_users_on_display();
}

void loop()
{
  // put your main code here, to run repeatedly:
}