pipeline {
    agent any
    stages {
        stage('Testing django') { 
            agent { 
                docker { 
                    image 'python:3'
                    args '-u root:root'
                }
            }
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/pepepfoter15/ic-imagen-python.git'q
                    sh 'pip install -r requirements.txt'
                    sh 'python manage.py test'
                }
            }
        }
        stage('Copiar settings') {
            steps {
                script {
                    sh 'cp django_tutorial/settings.bak django_tutorial/settings.py'
                }
            }
        }
        stage('Subir imagen') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                        def dockerImage = docker.build("pepepfoter15/django:${env.BUILD_ID}")
                        dockerImage.push()
                    }
                    sh "docker rmi pepepfoter15/django:${env.BUILD_ID}"
                }
            }
        }
        stage('SSH') {
            steps {
                script {
                    sshagent(credentials: ['pepe']) {
                        sh "ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es wget https://raw.githubusercontent.com/pepepfoter15/ic-imagen-python-vps/main/docker-compose.yaml -O docker-compose.yaml"
                        sh "ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es docker-compose up -d --force-recreate"
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'pepepfoter15@gmail.com',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
