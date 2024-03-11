pipeline {
    agent any
    agent {
        docker {
            image 'python:3'
            args '-u root:root'
        }
    }
    stages {
        stage ('Clonacion del repo') {
            steps {
                git branch:'main', url:'https://github.com/pepepfoter15/ic-imagen-python.git'
            }
        }
        stage ('Instalacion de los paquetes requeridos') {
            steps {
                sh 'pip install --user -r requirements.txt'
            }
        }
        stage ('Test del mismo') {
            steps {
                sh 'python3 manage.py test'
            }
        }
        stage ('Subir imagen') {
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
