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
        sh '''echo $HARBOR_CREDENTIAL_PSW | docker login $REGISTRY -u 'admin' --password-stdin'''
      }
    }
    stage('Push') {
      environment {
        registryCredential = 'harbor'
      }
      steps {
        // sh 'docker push eden266/jenkins-nodejs'
        // sh 'docker push  $REGISTRY/$HARBOR_NAMESPACE/$APP_NAME:jenkins-test'
        script {
          commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
          def appimage = docker.build imageName + ":" + commitId.trim()
          docker.withRegistry( 'https://gitlab-jenkins.opes.com.vn', registryCredential ) {
            appimage.push()
            if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'release') {
              appimage.push('latest')
              if (env.BRANCH_NAME == 'release') {
                appimage.push("release-" + "${COMMIT_SHA}")
              }
            }
          }
      }
    }
    /*
    stage('Deploy Dev') {
      when {
        branch 'main'
      }
      environment {
        registryCredential = 'harbor'
      }
      steps {
        script{
          commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
          commitId = commitId.trim()
          withKubeConfig(credentialsId: 'kubeconfig') {
            withCredentials(bindings: [usernamePassword(credentialsId: registryCredential, usernameVariable: 'HARBOR_CREDENTIAL_USER', passwordVariable: 'HARBOR_CREDENTIAL_PSW')]) {
              sh 'kubectl delete secret regcred --namespace=example-dev --ignore-not-found'
              sh 'kubectl create secret docker-registry regcred --namespace=example-dev --docker-server=https://gitlab-jenkins.opes.com.vn --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --docker-email=email@example.com'
            }
            sh "helm upgrade --set image.tag=${commitId} --install --wait dev-example-service ./chart --namespace example-dev"
          }
        }
      }
    }
    */
    
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
