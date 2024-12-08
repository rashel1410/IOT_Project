#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>

#define i2c_Address 0x3C // Default for most SH1106 OLEDs

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels
#define OLED_RESET -1   // Reset pin not used (set to -1)

Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void setup() {
  Serial.begin(115200);
  delay(250); // Allow time for the OLED to power up

  // Initialize I2C with custom pins (GPIO9 -> SCL, GPIO8 -> SDA)
  Wire.begin(8, 9);

  // Initialize the OLED display
  if (!display.begin(i2c_Address, true)) {
    Serial.println(F("SH1106 initialization failed! Check connections."));
    while (1); // Stop execution if the display fails to initialize
  }

  display.display();
  delay(2000);
  display.clearDisplay();

  // Example Drawing
  display.setTextSize(1);
  display.setTextColor(SH110X_WHITE);
  display.setCursor(0, 0);
  display.println("ESP32-S3 OLED Test");
  display.display();
  delay(2000);
}

void loop() {
  // Main loop code
}
