from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import numpy as np
import pickle

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this for production (e.g., specific domains)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the input schema with field constraints
class CropFeatures(BaseModel):
    Elevation: float = Field(..., ge=0, le=10000)
    Latitude: float = Field(..., ge=-90, le=90)
    Longitude: float = Field(..., ge=-180, le=180)
    Slope: float = Field(..., ge=0, le=90)
    Rainfall: float = Field(..., ge=0)
    Min_temperature_C: float
    Max_temperature_C: float
    Ave_temps: float
    Soil_fertility: float = Field(..., ge=0, le=10)
    pH: float = Field(..., ge=0, le=14)
    Pollution_level: float = Field(..., ge=0)
    Plot_size: float = Field(..., ge=0)
    Annual_yield: float = Field(..., ge=0)

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
    Crop_type_cassava_: int
    Crop_type_coffee: int
    Crop_type_maize: int
    Crop_type_potato: int
    Crop_type_rice: int
    Crop_type_tea: int
    Crop_type_tea_: int
    Crop_type_wheat: int
    Crop_type_wheat_: int

# Load model with try-except and print
try:
    with open("best_model.pkl", "rb") as f:
        model = pickle.load(f)
    print("Model loaded successfully.")
except Exception as e:
    print("Error loading the model:", e)
    model = None

@app.post("/predict")
def predict_yield(features: CropFeatures):
    try:
        if model is None:
            raise ValueError("Model not loaded properly.")

        input_data = np.array([[  # Ensure input matches training feature order
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
            features.Crop_type_wheat_,
        ]])

        print("Received input:", input_data)
        prediction = model.predict(input_data)
        print("Prediction result:", prediction)

        return {"predicted_yield": prediction[0]}
    except Exception as e:
        print("Prediction error:", e)
        raise HTTPException(status_code=500, detail=f"Prediction error: {e}")
