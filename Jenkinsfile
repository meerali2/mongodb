pipeline {
    agent any

        environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        ANSIBLE_SSH_KEY       = credentials('ANSIBLE_SSH_PRIVKEY')
    }

    stages {
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                    sh 'terraform output -json > tf_output.json'
                }
                script {
                    def tfOutput = readJSON file: 'terraform/tf_output.json'
                    env.SERVER_IP = tfOutput.instance_ip.value
                }
            }
        }

        stage('Configure MongoDB') {
            steps {
                dir('ansible') {
                    sh """
                    echo "[mongodb_servers]" > inventory.ini
                    echo "${env.SERVER_IP} ansible_user=ubuntu" >> inventory.ini
                    ansible-playbook -i inventory.ini playbook.yml --private-key=${env.ANSIBLE_SSH_KEY}
                    """
                }
            }
        }
    }

    post {
        always {
            dir('terraform') {
                sh """
		echo "mongodb installed successfully"
		"""
            }
        }
    }
}
