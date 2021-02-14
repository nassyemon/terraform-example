SHELL := ENV=${ENV} ./entrypoint.sh
MAIN_TFVAR := env/${ENV}/main.tfvars

# For commands that require additional arguments."
ifneq (,$(filter output output-json,$(firstword $(MAKECMDGOALS))))
  # use the rest as arguments.
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: init
init:
	terraform init -reconfigure --backend-config="bucket=$${BE_BUCKET}" --backend-config="key=$${BE_KEY}" --backend-config="region=$${BE_REGION}"

.PHONY: plan
plan:
	terraform plan -var-file ${MAIN_TFVAR}

.PHONY: apply
apply:
	terraform apply -var-file ${MAIN_TFVAR}

.PHONY: destroy
destroy:
	terraform destroy -var-file ${MAIN_TFVAR}

.PHONY: fmt
fmt:
	terraform fmt

.PHONY: output
output:
	terraform output $(RUN_ARGS)

.PHONY: output-json
output-json:
	terraform output -json $(RUN_ARGS)

.PHONY: test
test:
	echo $${GLOBAL_BE_BUCKET}