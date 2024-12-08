// Esp32 S3 and two I2C buses with Adafruit SSD1306 library (Two OLED 128x64 displays)
// Forum: https://forum.arduino.cc/t/esp32-s3-and-two-i2c-buses-with-adafruit-ssd1306-library-two-oled-128x64-displays/1290094
// Sketch by user: marko-2347
// This Wokwi project: https://wokwi.com/projects/405730495697247233


// OLED
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_SH110X.h>

//Define pins
#define I2C_A_SDA 8 // GPIO8
#define I2C_A_SCL 9 // GPIO9

// OLED parameters
#define SCREEN_WIDTH 128     // OLED display width, in pixels
#define SCREEN_HEIGHT 64     // OLED display height, in pixels
#define OLED_RESET -1        // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C  // Change if required
#define ROTATION 0           // Rotates text on OLED 1=90 degrees, 2=180 degrees

// Define display object
//Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);


void setup() {
  Serial.begin(115200);
  delay(250); // Allow time for the OLED to power up
  while (!Serial)
    ;
   Wire.begin(I2C_A_SDA, I2C_A_SCL);

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if (!display.begin(SCREEN_ADDRESS, true)) {
    Serial.println(F("Display1 SSD1306 allocation failed"));
    for (;;)
      ;  // Don't proceed, loop forever
  }

// Show splash screen
  display.display();
  delay(2000); // Pause for 2 seconds

  // Display settings
  display.clearDisplay();
  display.setTextSize(1);             // Normal 1:1 pixel scale
  display.setTextColor(SH110X_WHITE); // Draw white text
  display.setCursor(0,0);             // Start at top-left corner
  display.setRotation(ROTATION);      // Set screen rotation

  display.print("Working!!");

  display.display();

}


void loop() {
}
