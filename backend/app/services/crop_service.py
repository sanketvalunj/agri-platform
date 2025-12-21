import joblib
import numpy as np
import os

MODEL_PATH = os.path.join(
    os.path.dirname(__file__),
    "../ml/crop/crop_recommendation_model.pkl"
)

model = joblib.load(MODEL_PATH)

def recommend_crop(soil_data: dict):
    features = [
        soil_data["nitrogen"],
        soil_data["phosphorus"],
        soil_data["potassium"],
        soil_data["temperature"],
        soil_data["humidity"],
        soil_data["ph"],
        soil_data["rainfall"]
    ]

    X = np.array(features).reshape(1, -1)
    crop = model.predict(X)[0]

    return {
        "crop": crop
    }
