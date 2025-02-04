# Variables
ECR_REGISTRY = public.ecr.aws/p8v2r4g3
IMAGE_NAME = whisperx-on-aws-lambda
REGION = us-east-1
AWS_PROFILE = nonprod

.PHONY: login build tag push deploy 

login:
	aws ecr-public get-login-password --region $(REGION) --profile $(AWS_PROFILE) | docker login --username AWS --password-stdin $(ECR_REGISTRY)

build:
	docker build --platform=linux/amd64 -t $(IMAGE_NAME) .

tag:
	docker tag $(IMAGE_NAME):latest $(ECR_REGISTRY)/$(IMAGE_NAME):latest

push:
	docker push $(ECR_REGISTRY)/$(IMAGE_NAME):latest

deploy: login build tag push
