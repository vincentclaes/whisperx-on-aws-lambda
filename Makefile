# Variables
ECR_REGISTRY = public.ecr.aws/p8v2r4g3
IMAGE_NAME = whisperx-on-aws-lambda
REGION = eu-west-1
AWS_PROFILE ?= $(or $(AWS_PROFILE),default)
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
PRIVATE_ECR = $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com
PRIVATE_REPO = whisperx-on-lambda

.PHONY: login build tag push deploy create-private-repo private-ecr-login pull-public tag-private push-private setup-private

login:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/p8v2r4g3

build:
	docker build --platform=linux/amd64 --progress=plain -t $(IMAGE_NAME) .

tag:
	docker tag $(IMAGE_NAME):latest $(ECR_REGISTRY)/$(IMAGE_NAME):latest

push:
	docker push $(ECR_REGISTRY)/$(IMAGE_NAME):latest

deploy: build tag push

# Private ECR operations
create-private-repo:
	aws ecr create-repository \
		--repository-name $(PRIVATE_REPO) \
		--region $(REGION) \
		--profile $(AWS_PROFILE) || true

private-ecr-login:
	aws ecr get-login-password \
		--region $(REGION) \
		--profile $(AWS_PROFILE) | docker login --username AWS --password-stdin $(PRIVATE_ECR)

pull-public:
	docker pull $(ECR_REGISTRY)/$(IMAGE_NAME):latest

tag-private:
	docker tag $(ECR_REGISTRY)/$(IMAGE_NAME):latest $(PRIVATE_ECR)/$(PRIVATE_REPO):latest

push-private:
	docker push $(PRIVATE_ECR)/$(PRIVATE_REPO):latest

setup-private: create-private-repo private-ecr-login pull-public tag-private push-private
