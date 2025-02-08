# whisperx-on-aws-lambda

## Build

```
make build
```

## Deploy

```bash
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name whisperx-on-lambda \
  --capabilities CAPABILITY_IAM
```

## Invoke

```bash
docker run -p 9000:8080 whisperx-on-aws-lambda:latest

base64 -i sample.mp3 > sample.base64
echo "{\"isBase64Encoded\": true, \"body\": \"$(cat sample.base64 | tr -d '\n')\"}" > request.json && curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations -H "Content-Type: application/json" --data-binary @request.json

aws lambda invoke --function-name whisperx-transcription --payload "{\"isBase64Encoded\": true, \"body\": \"$(cat sample.base64 | tr -d '\n')\"}" --cli-binary-format raw-in-base64-out response.json
```