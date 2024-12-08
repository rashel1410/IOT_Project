#include <U8glib.h>
#include <Wire.h>

// Define the I2C pins
#define I2C_SCL 9  // SCL connected to GPIO9
#define I2C_SDA 8  // SDA connected to GPIO8

// Initialize the U8glib library with the custom I2C pins
U8GLIB_SH1106_128X64 u8g(U8G_I2C_OPT_NONE); // SH1106 initialization

void setup() {
  // Initialize the I2C pins
  Wire.begin(I2C_SDA, I2C_SCL); // Configure SDA and SCL
}

void loop() {
  // Start the drawing process
  u8g.firstPage();
  do {
    draw();
  } while (u8g.nextPage());
  
  delay(1000); // Pause between updates
}

void draw() {
  // Set font and display text
  u8g.setFont(u8g_font_unifont);
  u8g.drawStr(0, 22, "Hello ESP32-S3!");
}
