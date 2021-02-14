ENV_FILE=../env/global/backend.env
ENVS=$(shell cat ${ENV_FILE} | grep -v '\#' | xargs )
BE_BUCKET := $(shell env ${ENVS} sh -c 'echo $$BE_BUCKET')
BE_KEY := $(shell env ${ENVS} sh -c 'echo $$BE_KEY')
BE_REGION := $(shell env ${ENVS} sh -c 'echo $$BE_REGION')

# For commands that require additional arguments."
ifneq (,$(filter output output-json,$(firstword $(MAKECMDGOALS))))
  # use the rest as arguments.
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: init
init:
	${ENVS} terraform init -reconfigure --backend-config="bucket=${BE_BUCKET}" --backend-config="key=${BE_KEY}" --backend-config="region=${BE_REGION}"

.PHONY: plan
plan:
	terraform plan -var-file ../env/global/main.tfvars

.PHONY: apply
apply:
	terraform apply -var-file ../env/global/main.tfvars

.PHONY: plan-disable
plan-disable:
	TF_VAR_disabled=true make plan

.PHONY: apply-disable
apply-disable:
	TF_VAR_disabled=true make apply

.PHONY: destroy
destroy:
	terraform destroy -var-file ../env/global/main.tfvars

.PHONY: fmt
fmt:
	terraform fmt

.PHONY: output
output:
	terraform output $(RUN_ARGS)

.PHONY: output-json
output-json:
	terraform output -json $(RUN_ARGS)