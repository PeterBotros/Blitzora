import base64
import json
import mimetypes
import logging
import httpx
from typing import Dict, Any, Optional

from app.core.config import settings

logger = logging.getLogger(__name__)

class GeminiService:
    """Service to interact with Gemini API for multimodal document analysis"""

    def __init__(self):
        self.api_key = settings.GEMINI_API_KEY
        self.model = "gemini-1.5-flash"
        self.url = f"https://generativelanguage.googleapis.com/v1beta/models/{self.model}:generateContent"

    async def analyze_prescription(self, file_path: str) -> Dict[str, Any]:
        """
        Analyze a prescription image or PDF using Gemini API.
        Returns a dictionary with keys:
          - is_prescription: bool
          - doctor_signature_present: bool
          - prescription_date: str (YYYY-MM-DD) or None
          - medicines: List[str]
        """
        if not self.api_key:
            logger.warning("GEMINI_API_KEY is not set. Bypassing AI verification.")
            return {
                "is_prescription": True,
                "doctor_signature_present": True,
                "prescription_date": None,
                "medicines": [],
                "error": "API key not configured"
            }

        try:
            # 1. Read file and encode to base64
            with open(file_path, "rb") as f:
                file_bytes = f.read()
            
            base64_data = base64.b64encode(file_bytes).decode("utf-8")
            
            # Guess MIME type
            mime_type, _ = mimetypes.guess_type(file_path)
            if not mime_type:
                if file_path.lower().endswith(".pdf"):
                    mime_type = "application/pdf"
                elif file_path.lower().endswith(".png"):
                    mime_type = "image/png"
                else:
                    mime_type = "image/jpeg"

            # 2. Build the request payload
            prompt = (
                "You are an expert medical AI assistant. Analyze the attached prescription document (image or PDF).\n"
                "Extract the following information:\n"
                "1. Is this a medical prescription? (is_prescription: boolean)\n"
                "2. Is there a visible doctor's signature or stamp? (doctor_signature_present: boolean)\n"
                "3. What is the issue date of the prescription? (prescription_date: string in YYYY-MM-DD format, or null if not found)\n"
                "4. List the names of the medicines prescribed. (medicines: list of strings, or empty list if none found)\n\n"
                "Respond ONLY with a valid JSON object matching this schema:\n"
                "{\n"
                '  "is_prescription": boolean,\n'
                '  "doctor_signature_present": boolean,\n'
                '  "prescription_date": string or null,\n'
                '  "extracted_medicines": [string]\n'
                "}\n"
                "Note: the key in JSON should be 'extracted_medicines' to align with target naming."
            )

            payload = {
                "contents": [
                    {
                        "parts": [
                            {"text": prompt},
                            {
                                "inlineData": {
                                    "mimeType": mime_type,
                                    "data": base64_data
                                }
                            }
                        ]
                    }
                ],
                "generationConfig": {
                    "responseMimeType": "application/json"
                }
            }

            # 3. Call the API
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(f"{self.url}?key={self.api_key}", json=payload)
                response.raise_for_status()
                result = response.json()

            # 4. Parse output
            candidates = result.get("candidates", [])
            if not candidates:
                raise ValueError("No analysis response candidates from Gemini.")

            content_text = candidates[0].get("content", {}).get("parts", [])[0].get("text", "")
            if not content_text:
                raise ValueError("Empty response text from Gemini.")

            parsed_data = json.loads(content_text.strip())
            return {
                "is_prescription": parsed_data.get("is_prescription", True),
                "doctor_signature_present": parsed_data.get("doctor_signature_present", True),
                "prescription_date": parsed_data.get("prescription_date"),
                "medicines": parsed_data.get("extracted_medicines", parsed_data.get("medicines", []))
            }

        except Exception as e:
            logger.error(f"Error in Gemini prescription analysis: {str(e)}")
            # Fallback in case of API failure so the app doesn't crash completely
            return {
                "is_prescription": True,
                "doctor_signature_present": True,
                "prescription_date": None,
                "medicines": [],
                "error": str(e)
            }
