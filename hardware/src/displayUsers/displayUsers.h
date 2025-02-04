#ifndef SHOW_USERS_ON_DISPLAY_H
#define SHOW_USERS_ON_DISPLAY_H

#include <Arduino.h>
using namespace std;

void initializeDisplay();
void setCursorAux(int textWidth, int xOffset, int yOffset);
String getUsers();
void processJson(String json);
void displayUsers();
void displayText(String text);
void handleButtonClick(int state);
void handleButtonClickAfterSelectingUser();
tuple<String, String> handleNavigationButtonClick();

#endif // SHOW_USERS_ON_DISPLAY_H