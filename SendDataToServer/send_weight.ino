#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "soc/rtc.h"
#include "HX711.h"

// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 16;
const int LOADCELL_SCK_PIN = 4;

#define BUTTON_PIN 14
bool buttonPressed = false;

HX711 scale;

// WiFi credentials
const char *ssid = "Rahaf";
const char *password = "122334455";

// Server URL
const char *serverURL = "http://172.20.10.4:8045/save_weight";

void setup()
{
    Serial.begin(115200);
    rtc_cpu_freq_config_t config;
    rtc_clk_cpu_freq_get_config(&config);
    rtc_clk_cpu_freq_to_config(RTC_CPU_FREQ_80M, &config);
    rtc_clk_cpu_freq_set_config_fast(&config);

    pinMode(BUTTON_PIN, INPUT_PULLUP);

    scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

    // Connect to WiFi
    WiFi.begin(ssid, password);
    Serial.println("Connecting to WiFi...");
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        // Serial.print(WiFi.status());
        // Serial.print(".");
    }
    Serial.println("\nConnected to WiFi.");
}

void sendWeightToServer(long weight)
{
    if (WiFi.status() == WL_CONNECTED)
    {
        HTTPClient http;
        http.begin(serverURL);
        http.addHeader("Content-Type", "application/json");

        // Create JSON payload
        String payload = "{\"weight\": " + String(weight) + "}";

        // Serial.print("Payload: ");
        // Serial.println(payload);

        // Send POST request
        int httpResponseCode = http.POST(payload);

        if (httpResponseCode > 0)
        {
            Serial.println("Data sent successfully.");
            // Serial.print("HTTP Response Code: ");
            // Serial.println(httpResponseCode);
            Serial.print("Server Response: ");
            Serial.println(http.getString());
        }
        else
        {
            Serial.println("Failed to send data.");
            // Serial.print("HTTP Response Code: ");
            // Serial.println(httpResponseCode);
            Serial.print("Error Details: ");
            Serial.println(http.errorToString(httpResponseCode).c_str());
        }

        http.end();
    }
    else
    {
        Serial.println("WiFi not connected.");
    }
}

void loop()
{

    if (digitalRead(BUTTON_PIN) == LOW && !buttonPressed)
    {
        buttonPressed = true; // Mark button as pressed
        if (scale.is_ready())
        {
            scale.set_scale(459.691667);
            Serial.println("Tare... remove any items from the scale");
            delay(2000);
            scale.tare();
            Serial.println("Tare done...");
            Serial.print("Place an item on the scale...");
            delay(3000);
            long reading = scale.get_units(10);
            Serial.print("Result: ");
            Serial.println(reading);
            sendWeightToServer(reading);
        }
        else
        {
            Serial.println("HX711 not found.");
        }
        delay(1000);
    }

    // Reset buttonPressed when button is released
    if (digitalRead(BUTTON_PIN) == HIGH)
    {
        buttonPressed = false;
    }
}
