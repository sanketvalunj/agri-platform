class CarbonEngine:
    def __init__(self):
        # Carbon credit rates per activity (in tons CO2 equivalent per unit)
        self.carbon_rates = {
            "tree_plantation": 0.5,  # tons CO2 per tree per year
            "drip_irrigation": 0.3,  # tons CO2 per hectare per year
            "no_till": 0.2,  # tons CO2 per hectare per year
            "organic_farming": 0.4,  # tons CO2 per hectare per year
            "cover_cropping": 0.25,  # tons CO2 per hectare per year
        }

    def calculate_carbon_credits(self, activities):
        """
        Calculate carbon credits based on farmer activities.

        Args:
            activities: List of Activity objects with activity_type and quantity/area

        Returns:
            dict: Breakdown of carbon credits by activity type
        """
        breakdown = {}

        for activity in activities:
            activity_type = activity.activity_type
            if activity_type in self.carbon_rates:
                # Assuming activity has a quantity or area field
                quantity = getattr(activity, 'quantity', getattr(activity, 'area', 1))
                credits = self.carbon_rates[activity_type] * quantity
                if activity_type in breakdown:
                    breakdown[activity_type] += credits
                else:
                    breakdown[activity_type] = credits

        return breakdown
