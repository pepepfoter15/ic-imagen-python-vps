pipeline {
    agent none
    stages {
        stage('Test de django') {
            agent {
                docker {
                    image 'python:3'
                    args '-u root:root'
                }
            }
            steps {
                stage('Clonacion del repo') {
                    steps {
                        git branch:'main',url:'https://github.com/pepepfoter15/ic-imagen-python.git'
                    }
                }
                stage('Instalacion de los paquetes requeridos') {
                    steps {
                        sh 'pip install --root-user-action=ignore -r requirements.txt'
                    }
                }
                stage('Test del mismo') {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }
            }
        }
        stage('Subir imagen') {
            agent any
            steps {
                stage('Docker build y docker push') {
                    steps {
                        script {
                            withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                                def dockerImage = docker.build("pepepfoter15/django:${env.BUILD_ID}")
                                dockerImage.push()
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
            }
        }
        stage ('SSH') {
            agent any 
            steps{
                sshagent(credentials : ['pepe']) {
                    sh 'ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es wget https://raw.githubusercontent.com/pepepfoter15/ic-imagen-python-vps/main/docker-compose.yaml -O docker-compose.yaml'
                    sh 'ssh -o StrictHostKeyChecking=no yoshi@yoshi.pepepfoter15.es docker compose up -d --force-recreate'
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
