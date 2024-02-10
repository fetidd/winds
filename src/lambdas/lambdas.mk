lambda_dir = $(PROJECT_DIR)/src/lambdas

lambda_%:
	cd $(lambda_dir)/$@ && \
	zip -r $(PROJECT_DIR)/terraform/lambda_payloads/$@_payload.zip *

build-lambdas: $(shell ls $(lambda_dir) | grep lambda_)