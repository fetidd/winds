PROJECT_NAME = winds
LIVE ?= false
RELEASE ?= false
LOG_LEVEL ?= INFO

include ./src/lambdas/lambdas.mk
include ./src/common/common.mk

.PHONY: all clean 

build: build-lambdas build-common

clean:
	cd terraform/lambda_payloads && rm *

apply:
	cd terraform && terraform apply

destroy:
	cd terraform && terraform destroy

apply-force:
	cd terraform && terraform apply -auto-approve

plan:
	cd terraform && terraform plan

output:
	cd terraform && terraform output

deploy: build apply-force

apply-local:
	cd tests/terraform_local && \
	terraform plan -target aws_lambda_function.winds_connect_function -out tflocal.out && \
	terraform apply -out tflocal.out

create-connections-table:
	aws dynamodb create-table --table-name WebsocketConnections --attribute-definitions AttributeName=connection_id,AttributeType=S --key-schema AttributeName=connection_id,KeyType=HASH --billing-mode PAY_PER_REQUEST --endpoint-url http://localhost:8000

check-connections:
	aws dynamodb scan --table-name Connections --endpoint-url http://localhost:8000

check-dispatches:
	aws dynamodb scan --table-name Dispatches --endpoint-url http://localhost:8000

run-server:
	cd $(PROJECT_DIR)/src/server && python3 -m main

run-client:
	cd $(PROJECT_DIR)/src/debug-client && python3 -m main
	
