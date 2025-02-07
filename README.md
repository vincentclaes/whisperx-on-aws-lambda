# whisperx-on-aws-lambda

## Deploy

```bash
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name whisperx-on-lambda \
  --capabilities CAPABILITY_IAM
```

## Invoke

```bash
curl -X POST "https://<your-lambda-url>" -H "Content-Type: audio/mpeg" --data-binary "@sample.mp3"
```