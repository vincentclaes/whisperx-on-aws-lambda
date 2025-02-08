# whisperx-on-aws-lambda

## Build

```
make deploy
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

base64 sample.mp3 > sample.base64
echo "{\"isBase64Encoded\": true, \"body\": \"$(cat sample.base64 | tr -d '\n')\"}" > request.json && curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations -H "Content-Type: application/json" --data-binary @request.json
```