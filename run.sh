terraform -chdir=./terraform init
terraform -chdir=./terraform apply -auto-approve
sleep 60
cd ansible ; ansible-playbook -i inventory playbook.yml
