build-common:
	cd $(PROJECT_DIR)/src/common && \
	mkdir -p python/common/repo && \
	cp -r $(shell ls $(PROJECT_DIR)/src/common/*.py | grep -v __init__) python/common && \
	cp -r $(shell ls $(PROJECT_DIR)/src/common/repo/*.py | grep -v __init__) python/common/repo && \
	zip -r $(PROJECT_DIR)/terraform/lambda_payloads/common_layer_payload.zip python && \
	rm -rf python