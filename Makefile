SHELL := ENV=${ENV} ./entrypoint.sh

.PHONY: init
init:
	terraform init -reconfigure --backend-config="bucket=$${BE_BUCKET}" --backend-config="key=$${BE_KEY}" --backend-config="region=$${BE_REGION}"

.PHONY: plan
plan:
	terraform plan -var-file shared.tfvars

.PHONY: apply
apply:
	terraform apply -var-file shared.tfvars

.PHONY: destroy
destroy:
	terraform destroy -var-file shared.tfvars

.PHONY: fmt
fmt:
	terraform fmt