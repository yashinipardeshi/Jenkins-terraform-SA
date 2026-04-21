pipeline {
    agent any

    environment {
        // Define all Azure credentials here once for the entire pipeline
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    }
    
    stages {
        stage('Install Tools') {
            steps {
                sh '''
                    sudo apt-get update
                    sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
                    
                    # Install Azure CLI
                    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

                    # Install Terraform (Fixed GPG command)
                    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                    sudo apt-get update && sudo apt-get install -y terraform
                '''
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/yashinipardeshi/Jenkins-terraform-SA'
            }
        }

        stage('Terraform Init') {
            steps {
                // No withCredentials block needed; ARM_* env vars are already active
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Consider adding a manual approval gate here
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
