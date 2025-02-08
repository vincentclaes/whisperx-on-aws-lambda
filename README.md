# WhisperX on AWS Lambda

WhisperX stands out as the most versatile and feature-rich Whisper variation. [[1](https://modal.com/blog/open-source-stt)]
It outperforms the original Whisper in word segmentation, word error rate (WER), and transcription speed. [[2](https://www.isca-archive.org/interspeech_2023/bain23_interspeech.pdf?utm_source=chatgpt.com)]

And you can run it serverless on AWS Lambda. 🚀

## Deploy To AWS Lambda

[![launch-stack.png](launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=whisperx-on-lambda&templateURL=https://public-assets-vincent-claes.s3.eu-west-1.amazonaws.com/whisperx-on-lambda/whisperx-on-lambda.yaml)

```bash
aws cloudformation deploy \
  --template-file whisperx-on-lambda.yaml \
  --stack-name whisperx-on-lambda \
  --capabilities CAPABILITY_IAM
```

## Price 

A sample of 20 seconds takes 6.5 seconds.
If you have 1000 samples it will cost you around $1 to process them all.

__Note:__ there are no optimizations done regarding memory and speed of processing!

## Invoke Whisper on Lambda

```bash
base64 -i sample.mp3 > /tmp/sample.base64
aws lambda invoke --function-name whisperx-on-lambda --payload "{\"isBase64Encoded\": true, \"body\": \"$(cat /tmp/sample.base64 | tr -d '\n')\"}" --cli-binary-format raw-in-base64-out /tmp/output.json --log-type Tail --query 'LogResult' --output text | base64 -d
```

## Build

```
make build
```

## Run and Invoke Locally

```bash
docker run -p 9000:8080 whisperx-on-aws-lambda:latest

base64 -i sample.mp3 > sample.base64
echo "{\"isBase64Encoded\": true, \"body\": \"$(cat sample.base64 | tr -d '\n')\"}" > request.json && curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations -H "Content-Type: application/json" --data-binary @request.json
```