import requests

# Test Market Price API
print("Testing Market Price API...")
try:
    response = requests.get("http://127.0.0.1:8000/api/v1/market/prices?commodity=Tomato&state=Maharashtra")
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Response: {data}")
        print("✅ Market Price API working!")
    else:
        print(f"❌ Market Price API failed: {response.text}")
except Exception as e:
    print(f"❌ Market Price API error: {e}")

print("\n" + "="*50 + "\n")

# Test Weather API
print("Testing Weather API...")
try:
    response = requests.get("http://127.0.0.1:8000/api/v1/weather?city=Pune")
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Response: {data}")
        print("✅ Weather API working!")
    else:
        print(f"❌ Weather API failed: {response.text}")
except Exception as e:
    print(f"❌ Weather API error: {e}")
