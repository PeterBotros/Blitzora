"""
Test script to diagnose registration endpoint
"""
import requests
import json

BASE_URL = "http://localhost:8001"

# Test payload
payload = {
    "email": "testuser@example.com",
    "username": "testuser123",
    "password": "password123",  # 11 characters
    "full_name": "Test User",
    "phone": "1234567890"
}

print("Sending registration request...")
print(f"Payload: {json.dumps(payload, indent=2)}")

response = requests.post(
    f"{BASE_URL}/api/v1/auth/register",
    json=payload,
    headers={"Content-Type": "application/json"}
)

print(f"\nStatus Code: {response.status_code}")
print(f"Response Headers: {dict(response.headers)}")
print(f"Response Body: {json.dumps(response.json(), indent=2)}")
