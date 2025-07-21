from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np

# Load model
model = joblib.load("best_model.pkl")

# Define input data model
class CropFeatures(BaseModel):
    Ave_temps: float = Field(..., gt=0, lt=60, description="Average temperature in Celsius")
    Rainfall: float = Field(..., gt=0, lt=3000, description="Rainfall in mm")
    Soil_pH: float = Field(..., gt=0, lt=14, description="Soil pH value")
    NDVI: float = Field(..., gt=-1, lt=1, description="Normalized Difference Vegetation Index")
    Fertilizer_Use: float = Field(..., gt=0, lt=1000, description="Amount of fertilizer used (kg/ha)")
    Farm_Size: float = Field(..., gt=0, lt=1000, description="Size of the farm in hectares")

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/predict")
def predict_yield(features: CropFeatures):
    input_data = np.array([[features.Ave_temps, features.Rainfall, features.Soil_pH,
                            features.NDVI, features.Fertilizer_Use, features.Farm_Size]])
    prediction = model.predict(input_data)
    return {"predicted_yield": prediction[0]}