from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np
import os

app = FastAPI()

# Log current files in the working directory
print("Files in the directory:", os.listdir('.'))

# Load model with try-except block
try:
    model = joblib.load("best_model.pkl")
    print("Model loaded successfully.")
except Exception as e:
    print(f"Error loading the model: {e}")
    model = None

# Define all features
class CropPredictionFeatures(BaseModel):
    Elevation: float
    Latitude: float
    Longitude: float
    Slope: float
    Rainfall: float
    Min_temperature_C: float
    Max_temperature_C: float
    Ave_temps: float
    Soil_fertility: float
    pH: float
    Pollution_level: float
    Plot_size: float
    Annual_yield: float
    Location_Rural_Amanzi: int
    Location_Rural_Hawassa: int
    Location_Rural_Kilimani: int
    Location_Rural_Sokoto: int
    Soil_type_Peaty: int
    Soil_type_Rocky: int
    Soil_type_Sandy: int
    Soil_type_Silt: int
    Soil_type_Volcanic: int
    Crop_type_cassava: int
    Crop_type_cassava_: int  # Note the underscore to fix the duplicate name
    Crop_type_coffee: int
    Crop_type_maize: int
    Crop_type_potato: int
    Crop_type_rice: int
    Crop_type_tea: int
    Crop_type_tea_: int
    Crop_type_wheat: int
    Crop_type_wheat_: int

@app.get("/")
def home():
    return {"message": "Crop Income Prediction API is running."}

@app.post("/predict")
def predict_yield(features: CropPredictionFeatures):
    if model is None:
        return {"error": "Model not loaded properly."}
    try:
        # Convert input data to numpy array
        input_data = np.array([[
            features.Elevation,
            features.Latitude,
            features.Longitude,
            features.Slope,
            features.Rainfall,
            features.Min_temperature_C,
            features.Max_temperature_C,
            features.Ave_temps,
            features.Soil_fertility,
            features.pH,
            features.Pollution_level,
            features.Plot_size,
            features.Annual_yield,
            features.Location_Rural_Amanzi,
            features.Location_Rural_Hawassa,
            features.Location_Rural_Kilimani,
            features.Location_Rural_Sokoto,
            features.Soil_type_Peaty,
            features.Soil_type_Rocky,
            features.Soil_type_Sandy,
            features.Soil_type_Silt,
            features.Soil_type_Volcanic,
            features.Crop_type_cassava,
            features.Crop_type_cassava_,
            features.Crop_type_coffee,
            features.Crop_type_maize,
            features.Crop_type_potato,
            features.Crop_type_rice,
            features.Crop_type_tea,
            features.Crop_type_tea_,
            features.Crop_type_wheat,
            features.Crop_type_wheat_
        ]])

        prediction = model.predict(input_data)
        return {"Predicted_yield": float(prediction[0])}
    except Exception as e:
        print(f"Prediction error: {e}")
        return {"error": "An error occurred during prediction."}