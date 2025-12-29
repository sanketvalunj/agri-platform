import requests

# Test the market prices API
url = "http://localhost:8000/api/v1/market/prices"
params = {"state": "Maharashtra", "commodity": "Tomato"}

try:
    response = requests.get(url, params=params)
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print("Response:")
        print(data)
    else:
        print(f"Error: {response.text}")
except Exception as e:
    print(f"Error connecting to API: {e}")
