# variables
DIR :=  "./"
#ENV_FILE := "./.env"
#ENVS := $(shell cat ${ENV_FILE} | grep -v '\#' | xargs )

.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan -var-file shared.tfvars

.PHONY: apply
apply:
	terraform apply -var-file shared.tfvars

.PHONY: destroy
destory:
	terraform destory -var-file shared.tfvars

.PHONY: fmt
fmt:
	terraform fmt