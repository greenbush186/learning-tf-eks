ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
TF_BUCKET_NAME := terraform-state-$(ACCOUNT_ID)
TF_DYNODB_TABLE_NAME := terraform-state-$(ACCOUNT_ID)

init:
	echo "... Installing requirements.txt"
	pip install -r requirements.txt
	echo "... Terraform backend init ..."
	cd python && \
		python terraform_backend_init.py $(TF_BUCKET_NAME) $(TF_DYNODB_TABLE_NAME)

clean:
	echo "... Cleaning up Terraform backend ..."
	cd python && \
		python terraform_backend_clean.py $(TF_BUCKET_NAME) $(TF_DYNODB_TABLE_NAME)

vpc_init:
	cd terraform/vpc && \
		terraform init \
			-backend-config="bucket=$(TF_BUCKET_NAME)" \
			-backend-config="key=vpc/terraform.tfstate" \
			-backend-config="region=ap-southeast-2" \
			-backend-config="dynamodb_table=$(TF_DYNODB_TABLE_NAME)" \
			-backend-config="encrypt=true"

vpc_plan:
	cd terraform/vpc && \
		terraform plan

vpc_destroy:
	cd terraform/vpc && \
		terraform plan -destory