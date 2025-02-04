import json
import hashlib
import hmac
import os
import base64
from loguru import logger
import whisperx
import requests
import tempfile


model = whisperx.load_model("small", device="cpu", compute_type="int8", download_root="/tmp")

def lambda_handler(event: object, context: object):
    pass