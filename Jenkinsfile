pipeline {
    agent none
    stages {
        stage ('Test de django') { 
            agent {
                docker {
                    image 'python:3'
                    args '-u root:root'
                }
            }
            steps {
                script {
                    git branch:'main', url:'https://github.com/pepepfoter15/ic-imagen-python.git'
                }
                script {
                    sh 'pip install --user -r requirements.txt'
                }
                script {
                    sh 'python3 manage.py test'
                }
            }
        }
        stage('Subir imagen') {
            agent any
            steps {
                script {
                    withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                        def dockerImage = docker.build("pepepfoter15/django:${env.BUILD_ID}")
                        dockerImage.push()
                    }
                }
                script {
                    sh "docker rmi pepepfoter15/django:${env.BUILD_ID}"
                }
            }
        }
        stage ('SSH') {
            agent any 
            steps {
                script {
                    sshagent(credentials : ['pepe']) {
                        sh 'ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es wget https://raw.githubusercontent.com/pepepfoter15/ic-imagen-python-vps/main/docker-compose.yaml -O docker-compose.yaml'
                        sh 'ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es docker compose up -d --force-recreate'
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
