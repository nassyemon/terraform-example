ENV_FILE=../env/global/backend.env
ENVS=$(shell cat ${ENV_FILE} | grep -v '\#' | xargs )
BE_BUCKET := $(shell env ${ENVS} sh -c 'echo $$BE_BUCKET')
BE_KEY := $(shell env ${ENVS} sh -c 'echo $$BE_KEY')
BE_REGION := $(shell env ${ENVS} sh -c 'echo $$BE_REGION')

VAR_FILE_ARGS := -var-file ../env/global/main.tfvars

# For commands that require additional arguments."
ifneq (,$(filter output output-json,$(firstword $(MAKECMDGOALS))))
  # use the rest as arguments.
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: init
init:
	mkdir -p .temp
	${ENVS} terraform init -reconfigure --backend-config="bucket=${BE_BUCKET}" --backend-config="key=${BE_KEY}" --backend-config="region=${BE_REGION}"

.PHONY: plan
plan:
	terraform plan ${VAR_FILE_ARGS}

.PHONY: apply
apply:
	terraform apply ${VAR_FILE_ARGS}

.PHONY: plan-disable
plan-disable:
	TF_VAR_disabled=true make plan

.PHONY: apply-disable
apply-disable:
	TF_VAR_disabled=true make apply

.PHONY: destroy
destroy:
	terraform destroy ${VAR_FILE_ARGS}

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: output
output:
	@terraform output $(RUN_ARGS)

.PHONY: output-json
output-json:
	@terraform output -json $(RUN_ARGS)

.PHONY: connect-prd-opsrv
connect-prd-opsrv:
	$(eval USERNAME = $(shell sh -c "terraform output -raw operation_server_username"))
	$(eval SERVER_ID = $(shell sh -c "terraform output -json production_operation_server | jq '.instance_id'"))
	mssh $(USERNAME)@$(SERVER_ID)

.PHONY: test
test:
	echo $(TFVAR_ENVS)