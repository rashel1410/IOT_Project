// #include <WiFi.h>
// #include <HTTPClient.h>

// // Wi-Fi credentials
// // const char *ssid = "House";
// // const char *password = "0585585568";
// const char *ssid = "Rahaf";
// const char *password = "122334455";

// // Server URL
// // const char *serverURL = "http://10.0.0.9:8045";
// const char *serverURL = "http://172.20.10.4:8045";

// void hello_server_setup()
// {
//     Serial.begin(115200);
//     WiFi.begin(ssid, password);

//     // Connect to Wi-Fi
//     Serial.print("Connecting to Wi-Fi");
//     while (WiFi.status() != WL_CONNECTED)
//     {
//         delay(1000);
//         Serial.print(".");
//     }
//     Serial.println("\nConnected to Wi-Fi");
// }

// void hello_server_loop()
// {
//     if (WiFi.status() == WL_CONNECTED)
//     {
//         HTTPClient http;

//         // Specify the URL
//         http.begin(serverURL);

//         // Set HTTP header
//         http.addHeader("Content-Type", "application/json");

//         // Prepare the message
//         String message = "{\"key\": \"value\"}";

//         // Send HTTP POST request
//         int httpResponseCode = http.POST(message);

//         if (httpResponseCode > 0)
//         {
//             String response = http.getString();
//             Serial.print("Response: ");
//             Serial.println(response);
//         }
//         else
//         {
//             Serial.print("Error code: ");
//             Serial.println(httpResponseCode);
//         }

//         http.end();
//     }
//     else
//     {
//         Serial.println("Wi-Fi Disconnected");
//     }

//     delay(10000); // Wait 10 seconds before the next request
// }
