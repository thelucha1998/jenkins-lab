pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    // DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    REGISTRY = 'gitlab-jenkins.opes.com.vn'
    // the project name
    // make sure your robot account have enough access to the project
    HARBOR_NAMESPACE = 'jenkins-harbor'
    // docker image name
    APP_NAME = 'docker-example'
    // ‘robot-test’ is the credential ID you created on the KubeSphere console
    HARBOR_CREDENTIAL = credentials('harbor')
  }
  stages {
    stage('Build') {
      steps {
        // sh 'docker build -t eden266/jenkins-nodejs .'
        sh 'docker build -t $REGISTRY/$HARBOR_NAMESPACE/$APP_NAME:jenkins-test .'
      }
    }
    stage('Login') {
      steps {
        // sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh '''echo $HARBOR_CREDENTIAL_PSW | docker login $REGISTRY -u 'robot$robot-test' --password-stdin'''
      }
    }
    stage('Push') {
      steps {
        // sh 'docker push eden266/jenkins-nodejs'
        sh 'docker push  $REGISTRY/$HARBOR_NAMESPACE/$APP_NAME:devops-test'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
