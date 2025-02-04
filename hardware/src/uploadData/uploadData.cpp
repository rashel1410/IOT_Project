// cSpell: disable
#include <Arduino.h>
#include <esp_camera.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "HX711.h"
/****************************************************************/
/* Includes from .h files
/****************************************************************/
#include "uploadData.h"
#include "displayUsers/displayUsers.h"
/**************************** Globals ***************************/
#define BUTTON_PIN 3

#define PWDN_GPIO_NUM -1
#define RESET_GPIO_NUM -1
#define XCLK_GPIO_NUM 15
#define SIOD_GPIO_NUM 4
#define SIOC_GPIO_NUM 5

#define Y2_GPIO_NUM 11
#define Y3_GPIO_NUM 9
#define Y4_GPIO_NUM 8
#define Y5_GPIO_NUM 10
#define Y6_GPIO_NUM 12
#define Y7_GPIO_NUM 18
#define Y8_GPIO_NUM 17
#define Y9_GPIO_NUM 16

#define VSYNC_GPIO_NUM 6
#define HREF_GPIO_NUM 7
#define PCLK_GPIO_NUM 13

// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 47;
const int LOADCELL_SCK_PIN = 21;

bool isButtonPressed = false;
HX711 scale;

/****************************************************************/
void setupCameraConfig()
{
    // Initialize camera
    camera_config_t camera_config;
    camera_config.ledc_channel = LEDC_CHANNEL_0;
    camera_config.ledc_timer = LEDC_TIMER_0;
    camera_config.pin_d0 = Y2_GPIO_NUM;
    camera_config.pin_d1 = Y3_GPIO_NUM;
    camera_config.pin_d2 = Y4_GPIO_NUM;
    camera_config.pin_d3 = Y5_GPIO_NUM;
    camera_config.pin_d4 = Y6_GPIO_NUM;
    camera_config.pin_d5 = Y7_GPIO_NUM;
    camera_config.pin_d6 = Y8_GPIO_NUM;
    camera_config.pin_d7 = Y9_GPIO_NUM;
    camera_config.pin_xclk = XCLK_GPIO_NUM;
    camera_config.pin_pclk = PCLK_GPIO_NUM;
    camera_config.pin_vsync = VSYNC_GPIO_NUM;
    camera_config.pin_href = HREF_GPIO_NUM;
    camera_config.pin_sccb_sda = SIOD_GPIO_NUM;
    camera_config.pin_sccb_scl = SIOC_GPIO_NUM;
    camera_config.pin_pwdn = PWDN_GPIO_NUM;
    camera_config.pin_reset = RESET_GPIO_NUM;
    camera_config.xclk_freq_hz = 20000000;
    camera_config.frame_size = FRAMESIZE_VGA;
    camera_config.pixel_format = PIXFORMAT_JPEG; // for streaming
    camera_config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
    camera_config.fb_location = CAMERA_FB_IN_PSRAM;
    camera_config.jpeg_quality = 12;
    camera_config.fb_count = 1;

    // if PSRAM IC present, init with UXGA resolution and higher JPEG quality
    // for larger pre-allocated frame buffer.
    if (psramFound())
    {
        camera_config.jpeg_quality = 10;
        camera_config.fb_count = 2;
        camera_config.grab_mode = CAMERA_GRAB_LATEST;
    }
    else
    {
        // Limit the frame size when PSRAM is not available
        camera_config.frame_size = FRAMESIZE_SVGA;
        camera_config.fb_location = CAMERA_FB_IN_DRAM;
    }

    if (esp_camera_init(&camera_config) != ESP_OK)
    {
        Serial.println("Camera init failed");
        return;
    }
}
/****************************************************************/
void initCameraAndScale()
{
    Serial.begin(115200);

    // Initialize camera
    setupCameraConfig();

    // Initialize scale
    scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

    // Initialize buttons pins as in your original code
    pinMode(BUTTON_PIN, INPUT_PULLUP);
}
/****************************************************************/
void uploadData(String user_id)
{
    if (digitalRead(BUTTON_PIN) == LOW && !isButtonPressed)
    {
        isButtonPressed = true;
        captureAndSendData(user_id);
    }

    if (digitalRead(BUTTON_PIN) == HIGH)
    {
        isButtonPressed = false;
    }
}
/****************************************************************/
void captureAndSendData(String user_id)
{
    // Read weight
    scale.set_scale(467.775);
    displayText("Remove items");
    Serial.println("Remove items from the scale");
    delay(1000);
    scale.tare();
    Serial.println("Tare done");
    // displayText("Tare done");
    delay(1000);
    Serial.print("Place your item ");
    displayText("Place your item");
    delay(3000);
    long weightReading = scale.get_units(10);
    delay(1000);
    Serial.printf("Weight reading: %ld\n", weightReading);
    displayText("Done!");
    delay(1000);
    handleButtonClick(1); // Display user selection screen

    // Release previous frame, if any
    camera_fb_t *previousPhoto = esp_camera_fb_get();
    if (previousPhoto)
    {
        esp_camera_fb_return(previousPhoto);
    }

    // Allow camera to refresh
    delay(200); // Adjust delay if necessary
    camera_fb_t *capturedPhoto = esp_camera_fb_get();
    if (!capturedPhoto)
    {
        Serial.println("Failed to capture photo.");
        return;
    }
    Serial.println("Photo captured.");

    // Prepare HTTP multipart body
    HTTPClient http;
    String boundary = "----ESP32Boundary";
    String startBoundary =
        "--" + boundary + "\r\n"
                          "Content-Disposition: form-data; name=\"weight\"\r\n\r\n" +
        String(weightReading) + "\r\n" +
        "--" + boundary + "\r\n"
                          "Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n"
                          "Content-Type: image/jpeg\r\n\r\n";
    String endBoundary = "\r\n--" + boundary + "--\r\n";

    // Calculate content length
    size_t contentLength = startBoundary.length() + capturedPhoto->len + endBoundary.length();
    Serial.printf("Content length: %u\n", contentLength);

    // Allocate buffer for the multipart body
    uint8_t *body = (uint8_t *)malloc(contentLength);
    if (!body)
    {
        Serial.println("Failed to allocate memory for HTTP body");
        return;
    }

    // Construct multipart body
    memcpy(body, startBoundary.c_str(), startBoundary.length());
    memcpy(body + startBoundary.length(), capturedPhoto->buf, capturedPhoto->len);
    memcpy(body + startBoundary.length() + capturedPhoto->len, endBoundary.c_str(), endBoundary.length());

    // Send HTTP POST request
    const String upload_data_url = "http://172.20.10.4:8045/upload_data/" + user_id;
    http.begin(upload_data_url);
    http.setTimeout(20000);
    http.addHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
    int httpResponseCode = http.POST(body, contentLength);

    if (httpResponseCode > 0)
    {
        String response = http.getString();
        Serial.printf("Data sent successfully. Server response: %d\n", httpResponseCode);
        Serial.println("Response: " + response);
    }
    else
    {
        Serial.printf("Failed to send data. Error: %s\n", http.errorToString(httpResponseCode).c_str());
    }

    // Free allocated memory
    free(body);
    http.end();
    esp_camera_fb_return(capturedPhoto); // Free the frame buffer
}