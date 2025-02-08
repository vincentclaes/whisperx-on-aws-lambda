import whisperx
import tempfile
import base64


model = whisperx.load_model("small", device="cpu", compute_type="int8", download_root="/tmp")

def lambda_handler(event: object, context: object):
    try:
        body = event["body"]
        # If the body is base64 encoded, decode it
        if event.get("isBase64Encoded", False):
            print("audio as base64 encoded data")
            audio_data = base64.b64decode(body)
        else:
            # If it's a string, encode to bytes. Otherwise assume bytes.
            print("audio as string data")
            audio_data = body.encode('utf-8') if isinstance(body, str) else body

        # Create a temporary file for the audio data using a context manager
        with tempfile.NamedTemporaryFile(suffix=".audio", delete=True) as tmp:
            tmp.write(audio_data)
            print(f"tmp path: {tmp}")
            temp_path = tmp.name
            transcription = model.transcribe(temp_path)
            text = transcription['segments'][0]['text']
            print(f"Transcription: {text}")

        return {
            "statusCode": 200,
            "body": transcription,
            "headers": {"Content-Type": "text/plain"}
        }
    except Exception as e:
        return {"statusCode": 500, "body": str(e)}