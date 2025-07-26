Crop Yield Prediction
Description of Mission and Problem
This project predicts crop yield based on environmental and farming parameters such as temperature, rainfall, soil type, and crop type. It helps farmers and agricultural planners make data-driven decisions to improve productivity and resource allocation.

Public API Endpoint
Swagger UI: https://linear-regression-model-1-y26q.onrender.com/docs

Prediction Endpoint (POST): /predict

Quick Test Using Curl
curl -X POST "https://linear-regression-model-1-y26q.onrender.com/predict" \
-H "Content-Type: application/json" \
-d '{
  "Elevation": 1500,
  "Latitude": 0.34,
  "Longitude": 32.58,
  "Slope": 2.5,
  "Rainfall": 1200,
  "Min_temperature_C": 15,
  "Max_temperature_C": 28,
  "Ave_temps": 21.5,
  "Soil_fertility": 3,
  "pH": 6.5,
  "Pollution_level": 1,
  "Plot_size": 2,
  "Annual_yield": 1000,
  "Location_Rural_Amanzi": 0,
  "Location_Rural_Hawassa": 1,
  "Location_Rural_Kilimani": 0,
  "Location_Rural_Sokoto": 0,
  "Soil_type_Peaty": 0,
  "Soil_type_Rocky": 0,
  "Soil_type_Sandy": 1,
  "Soil_type_Silt": 0,
  "Soil_type_Volcanic": 0,
  "Crop_type_cassava": 0,
  "Crop_type_cassava_": 0,
  "Crop_type_coffee": 1,
  "Crop_type_maize": 0,
  "Crop_type_potato": 0,
  "Crop_type_rice": 0,
  "Crop_type_tea": 0,
  "Crop_type_tea_": 0,
  "Crop_type_wheat": 0,
  "Crop_type_wheat_": 0
}'
Video Demo
YouTube Demo (5 min): https://youtu.be/example

Running the Mobile App
Install Flutter.

Clone this repository and navigate to the FlutterApp folder.

Install dependencies:

flutter pub get
Run the app on an emulator or physical device:

flutter run
Enter required input values, tap Predict, and view the predicted yield displayed on the app.
