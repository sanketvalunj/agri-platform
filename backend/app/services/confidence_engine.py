from typing import Dict, Any
from app.models.activity import Activity
from app.models.farmer import Farmer

class ConfidenceEngine:
    def __init__(self):
        pass

    def calculate_confidence_score(self, activities: list[Activity], farmer: Farmer) -> float:
        """
        Calculate confidence score based on data completeness, image verification, and satellite consistency.

        Formula:
        confidence = 0.4 * data_completeness + 0.3 * image_verification + 0.3 * satellite_consistency

        Returns confidence as percentage (0-100).
        """
        # Data completeness: based on number of verified activities
        total_activities = len(activities)
        verified_activities = len([a for a in activities if a.verified])
        data_completeness = (verified_activities / max(total_activities, 1)) * 100

        # Image verification: average confidence from verified activities with images
        image_confidences = [a.value for a in activities if a.verified and a.image_url]
        image_verification = sum(image_confidences) / max(len(image_confidences), 1) if image_confidences else 0

        # Satellite consistency: based on NDVI scores
        ndvi_scores = [a.ndvi_score for a in activities if a.ndvi_score is not None]
        satellite_consistency = sum(ndvi_scores) / max(len(ndvi_scores), 1) if ndvi_scores else 0

        confidence = (
            0.4 * data_completeness +
            0.3 * image_verification +
            0.3 * satellite_consistency
        )

        return min(round(confidence, 2), 100.0)  # Cap at 100%
