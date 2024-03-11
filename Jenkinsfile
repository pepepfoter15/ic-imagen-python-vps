pipeline {
    agent any
    stages {
        stage('Test de django') {
            steps {
                script {
                    docker.image('python:3').inside('-u root:root') {
                        stage('Clonacion del repo') {
                            git branch: 'main', url: 'https://github.com/pepepfoter15/ic-imagen-python.git'
                        }
                        stage('Instalacion de los paquetes requeridos') {
                            sh 'pip install --root-user-action=ignore -r requirements.txt'
                        }
                        stage('Test del mismo') {
                            sh 'python3 manage.py test'
                        }
                    }
                }
            }
        }
        stage('Subir imagen') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                        docker.image("pepepfoter15/django:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        stage('Eliminacion de imagen') {
            steps {
                script {
                    sh "docker rmi pepepfoter15/django:${env.BUILD_ID}"
                }
            }
        }
        stage('SSH') {
            steps {
                script {
                    sshagent(credentials: ['pepe']) {
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
