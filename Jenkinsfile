pipeline {

  environment {
    dockerimagename = "srijaldocker/nodechat"
    dockerImage = ""
  }

  agent any

  stages {
    stage('Checkout Source') {
      steps {
        git 'https://github.com/SrijalKarmacharya/node-chat.git'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
       
          withCredentials([
        file(credentialsId: "kubeconfig", variable: 'KUBECRED')
        
    ]) {
        sh """
       export KUBECONFIG=$KUBECRED
       kubectl apply -f deploymentservice.yml
        """
    
        }
      }
    }
  }
    post {
        success {
            slackSend channel: "#general", message: "Build Succeded: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        failure {
            slackSend failOnError:true, message:"Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }



}
