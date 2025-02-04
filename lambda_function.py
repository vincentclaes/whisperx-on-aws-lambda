import whisperx
import tempfile
import os
import base64


model = whisperx.load_model("small", device="cpu", compute_type="int8", download_root="/tmp")

def lambda_handler(event: object, context: object):
    try:
        # Retrieve the request body
        body = event.get("body", "")
        # If the body is base64 encoded, decode it
        if event.get("isBase64Encoded", False):
            audio_data = base64.b64decode(body)
        else:
            # If it's a string, encode to bytes. Otherwise assume bytes.
            audio_data = body.encode('utf-8') if isinstance(body, str) else body

        # Create a temporary file for the audio data using a context manager
        with tempfile.NamedTemporaryFile(suffix=".audio", delete=False) as tmp:
            tmp.write(audio_data)
            temp_path = tmp.name
        try:
            result = model.transcribe(temp_path)
            transcription = result.get("text", "")
        finally:
            os.remove(temp_path)

        return {
            "statusCode": 200,
            "body": transcription,
            "headers": {"Content-Type": "text/plain"}
        }
    except Exception as e:
        return {"statusCode": 500, "body": str(e)}