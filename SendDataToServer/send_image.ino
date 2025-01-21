#include <esp_camera.h>
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>

#define BUTTON_PIN 14 // Adjust to your button's GPIO pin

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

camera_fb_t *capturedPhoto = nullptr;

// WiFi credentials
const char *ssid = "Rahaf";
const char *password = "122334455";

// Server URL for uploading the photo
const char *serverURL = "http://172.20.10.4:8045/upload_image";

void setup()
{
    Serial.begin(115200);

    // Initialize WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected");
    Serial.println(WiFi.localIP()); // Print the ESP32 IP address

    // Initialize camera
    camera_config_t config;
    config.ledc_channel = LEDC_CHANNEL_0;
    config.ledc_timer = LEDC_TIMER_0;
    config.pin_d0 = Y2_GPIO_NUM;
    config.pin_d1 = Y3_GPIO_NUM;
    config.pin_d2 = Y4_GPIO_NUM;
    config.pin_d3 = Y5_GPIO_NUM;
    config.pin_d4 = Y6_GPIO_NUM;
    config.pin_d5 = Y7_GPIO_NUM;
    config.pin_d6 = Y8_GPIO_NUM;
    config.pin_d7 = Y9_GPIO_NUM;
    config.pin_xclk = XCLK_GPIO_NUM;
    config.pin_pclk = PCLK_GPIO_NUM;
    config.pin_vsync = VSYNC_GPIO_NUM;
    config.pin_href = HREF_GPIO_NUM;
    config.pin_sccb_sda = SIOD_GPIO_NUM;
    config.pin_sccb_scl = SIOC_GPIO_NUM;
    config.pin_pwdn = PWDN_GPIO_NUM;
    config.pin_reset = RESET_GPIO_NUM;
    config.xclk_freq_hz = 20000000;
    config.frame_size = FRAMESIZE_UXGA;
    config.pixel_format = PIXFORMAT_JPEG; // for streaming
    config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
    config.fb_location = CAMERA_FB_IN_PSRAM;
    config.jpeg_quality = 12;
    config.fb_count = 1;

    // if PSRAM IC present, init with UXGA resolution and higher JPEG quality
    // for larger pre-allocated frame buffer.
    if (psramFound())
    {
        config.jpeg_quality = 10;
        config.fb_count = 2;
        config.grab_mode = CAMERA_GRAB_LATEST;
    }
    else
    {
        // Limit the frame size when PSRAM is not available
        config.frame_size = FRAMESIZE_SVGA;
        config.fb_location = CAMERA_FB_IN_DRAM;
    }

    if (esp_camera_init(&config) != ESP_OK)
    {
        Serial.println("Camera init failed");
        return;
    }

    // Initialize button
    pinMode(BUTTON_PIN, INPUT_PULLUP);
}

void loop()
{
    // Check button state
    if (digitalRead(BUTTON_PIN) == LOW)
    {
        delay(100); // Debounce delay
        if (digitalRead(BUTTON_PIN) == LOW)
        {
            capturePhoto();
            sendPhotoToServer();
        }
    }
}

void capturePhoto()
{
    if (capturedPhoto)
    {
        esp_camera_fb_return(capturedPhoto); // Free previous buffer
    }
    capturedPhoto = esp_camera_fb_get();
    if (!capturedPhoto)
    {
        Serial.println("Photo capture failed");
        return;
    }

    Serial.println("Photo captured");
}

void sendPhotoToServer()
{
    if (!capturedPhoto)
    {
        Serial.println("No photo to send");
        return;
    }

    HTTPClient http;
    http.begin(serverURL);
    http.addHeader("Content-Type", "image/jpeg");
    http.setTimeout(5000); // Set timeout to 5 seconds

    // Serial.printf("Sending photo of size %d bytes\n", capturedPhoto->len);
    // Serial.printf("Free heap memory: %u bytes\n", ESP.getFreeHeap());
    int httpResponseCode = http.POST(capturedPhoto->buf, capturedPhoto->len);

    if (httpResponseCode > 0)
    {
        Serial.printf("Photo sent successfully. Server response: %d\n", httpResponseCode);
    }
    else
    {
        Serial.printf("Failed to send photo. Error: %s\n", http.errorToString(httpResponseCode).c_str());
    }

    http.end();
}

// void sendPhotoToServer() {
//   if (!capturedPhoto || !capturedPhoto->buf) {
//     Serial.println("No photo to send");
//     return;
//   }

//   HTTPClient http;
//   String boundary = "----ESP32Boundary";
//   String startBoundary = "--" + boundary + "\r\n"
//                          "Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n"
//                          "Content-Type: image/jpeg\r\n\r\n";
//   String endBoundary = "\r\n--" + boundary + "--\r\n";

//   // Calculate content length
//   size_t contentLength = startBoundary.length() + capturedPhoto->len + endBoundary.length();
//   Serial.printf("Content length: %u\n", contentLength);

//   // Allocate buffer for the multipart body
//   uint8_t *body = (uint8_t *)malloc(contentLength);
//   if (!body) {
//     Serial.println("Failed to allocate memory for HTTP body");
//     return;
//   }

//   // Construct multipart body
//   memcpy(body, startBoundary.c_str(), startBoundary.length());
//   memcpy(body + startBoundary.length(), capturedPhoto->buf, capturedPhoto->len);
//   memcpy(body + startBoundary.length() + capturedPhoto->len, endBoundary.c_str(), endBoundary.length());

//   // Send HTTP POST request
//   http.begin(serverURL);
//   http.addHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
//   int httpResponseCode = http.POST(body, contentLength);

//   if (httpResponseCode > 0) {
//     String response = http.getString();
//     Serial.printf("Photo sent successfully. Server response: %d\n", httpResponseCode);
//     Serial.println("Response: " + response);
//   } else {
//     Serial.printf("Failed to send photo. Error: %s\n", http.errorToString(httpResponseCode).c_str());
//   }

//   // Free allocated memory
//   free(body);
//   http.end();
// }
