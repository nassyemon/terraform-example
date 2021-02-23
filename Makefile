SHELL := ENV=${ENV} ./entrypoint.sh
MAIN_TFVARS := env/${ENV}/main.tfvars
DATABASE_TFVARS := env/${ENV}/database.tfvars
SHARED_TFVARS := env/shared.tfvars

VAR_FILE_ARGS := -var-file ${SHARED_TFVARS} -var-file ${MAIN_TFVARS}  -var-file ${DATABASE_TFVARS} 

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
	terraform init -reconfigure --backend-config="bucket=$${BE_BUCKET}" --backend-config="key=$${BE_KEY}" --backend-config="region=$${BE_REGION}"

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
	terraform fmt

.PHONY: output
output:
	@terraform output $(RUN_ARGS)

.PHONY: output-json
output-json:
	@terraform output -json $(RUN_ARGS)

.PHONY: connect-opsrv
 connect-opsrv:
	$(eval USERNAME = $(shell sh -c "terraform output -raw operation_server_username"))
	$(eval SERVER_ID = $(shell sh -c "terraform output operation_server_id"))
	mssh $(USERNAME)@$(SERVER_ID)

.PHONY: test
test:
	echo $${GLOBAL_BE_BUCKET}