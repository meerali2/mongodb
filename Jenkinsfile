pipeline {
    agent any

    environment {
        // Exact credential IDs match karein
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SSH_PRIVATE_KEY       = credentials('SSH_PRIVATE_KEY') 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Configure MongoDB') {
            steps {
                dir('ansible') {
                    // Temporary file mein SSH key save karein
                    sh """
                    mkdir -p ~/.ssh
                    cat ${env.SSH_PRIVATE_KEY} > ~/.ssh/mongodb.key
                    chmod 600 ~/.ssh/mongodb.key
                    echo "[mongodb_servers]" > inventory.ini
                    echo "$(terraform -chdir=../terraform output -raw instance_ip) ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/mongodb.key" >> inventory.ini
                    ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }
    }
}
