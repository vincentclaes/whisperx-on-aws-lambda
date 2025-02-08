# Variables
ECR_REGISTRY = public.ecr.aws/p8v2r4g3
IMAGE_NAME = whisperx-on-aws-lambda
REGION = eu-west-1
AWS_PROFILE = default
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
PRIVATE_ECR = $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
PRIVATE_REPO = whisperx-on-lambda

.PHONY: login build tag push deploy create-private-repo private-ecr-login pull-public tag-private push-private setup-private

image:
	docker build --no-cache --platform=linux/amd64 --progress=plain -t $(IMAGE_NAME) .

login:
	aws ecr get-login-password \
		--region $(REGION) \
		--profile $(AWS_PROFILE) | docker login --username AWS --password-stdin $(PRIVATE_ECR)

tag:
	docker tag $(ECR_REGISTRY)/$(IMAGE_NAME):latest $(PRIVATE_ECR)/$(PRIVATE_REPO):latest

push:
	docker push $(PRIVATE_ECR)/$(PRIVATE_REPO):latest

build: image tag login push
