pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
  stages {
    stage('Build') {
      steps {
        sh 'git checkout -b jenkins'
        sh 'docker build -t eden266/jenkins-nodejs .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push eden266/jenkins-nodejs'
      }
    }
    stage('Deploying into k8s'){
      steps{
        sh 'kubectl apply -f deployment.yml'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
