#include <Arduino.h>
#include <WiFi.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_SH110X.h>
#include <HTTPClient.h>
#include <tuple>

using namespace std;

// WiFi credentials
const char *ssid = "Rahaf";
const char *password = "122334455";

/****************************************************************/
/* Includes from .h files
/****************************************************************/
#include "displayUsers/displayUsers.h"
#include "uploadData/uploadData.h"
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

  initializeDisplay();
  initCameraAndScale();
}

void loop()
{
  tuple<String, String> curr = handleNavigationButtonClick();
  // String curr_user_name = get<0>(curr);
  handleButtonClickAfterSelectingUser();
  if (get<0>(curr) != "")
  {
    // String curr_user_id = get<1>(curr);
    uploadData(get<1>(curr));
  }
}