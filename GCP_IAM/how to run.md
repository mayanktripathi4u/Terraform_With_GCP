1. Initiate the Terraform
```
terraform init
```
2. Format the Terraform Code.
```
terraform fmt

terraform validate
```
3. Run the Plan with default Project and default yaml file.
```
terraform plan
```
4. Run the Plan: Pass the `project_id` via the Command Line
```
terraform plan -var="project_id=gcp-010-dev"

terraform plan -var="project_id=gcp-010-qa" -var="iam_config_file=iam_group_bindings_qa.yaml"

terraform plan -var="project_id=gcp-010-prod" -var="iam_config_file=iam_group_bindings_qa.yaml"
```
5. Apply the changes.
```
terraform apply -var="project_id=gcp-010-dev"

terraform apply -var="project_id=gcp-010-qa" -var="iam_config_file=iam_group_bindings_qa.yaml"

terraform apply -var="project_id=gcp-010-prod" -var="iam_config_file=iam_group_bindings_qa.yaml"
```
