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

    helmRepo = 'https://artifactory-webinar.jfrogdev.co/artifactory/helm'
    helmRelease = 'webinar-example'

    dockerTag = '0.0'
    helmChartVersion = '0.0.1'
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
        sh '''echo $HARBOR_CREDENTIAL_PSW | docker login $REGISTRY -u 'admin' --password-stdin'''
      }
    }
    stage('Push') {
      steps {
        // sh 'docker push eden266/jenkins-nodejs'
        sh 'docker push  $REGISTRY/$HARBOR_NAMESPACE/$APP_NAME:jenkins-test'
      }
    }
    stage('Helm package') {
        steps {
            script {
                echo "========== Helm package =========="
                sh "helm package demo"

                echo "========== Publish helm chart =========="
                sh "curl -u${HARBOR_CREDENTIAL} -T ./demo-${helmChartVersion}.tgz '${helmRepo}/demo-${helmChartVersion}.tgz'"
            }
        }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
