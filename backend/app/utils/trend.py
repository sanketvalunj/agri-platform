def calculate_trend(today_avg: int, yesterday_avg: int):
    if yesterday_avg == 0:
        return 0.0, "stable"

    change = ((today_avg - yesterday_avg) / yesterday_avg) * 100

    if change > 1:
        return round(change, 2), "up"
    elif change < -1:
        return round(change, 2), "down"
    else:
        return round(change, 2), "stable"


def suggest_action(trend: str):
    if trend == "up":
        return "Sell"
    if trend == "down":
        return "Hold"
    return "Wait"
