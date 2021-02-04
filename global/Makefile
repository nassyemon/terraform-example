ENV_FILE=./global.env
ENVS=$(shell cat ${ENV_FILE} | grep -v '\#' | xargs )
BE_BUCKET := $(shell env ${ENVS} sh -c 'echo $$BE_BUCKET')
BE_KEY := $(shell env ${ENVS} sh -c 'echo $$BE_KEY')
BE_REGION := $(shell env ${ENVS} sh -c 'echo $$BE_REGION')

.PHONY: init
init:
	${ENVS} terraform init -reconfigure --backend-config="bucket=${BE_BUCKET}" --backend-config="key=${BE_KEY}" --backend-config="region=${BE_REGION}"

.PHONY: plan
plan:
	terraform plan -var-file ../shared.tfvars

.PHONY: apply
apply:
	terraform apply -var-file ../shared.tfvars

.PHONY: destroy
destroy:
	terraform destroy -var-file ../shared.tfvars

.PHONY: fmt
fmt:
	terraform fmt