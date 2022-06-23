pipeline {

  environment {
    dockerimagename = "niskarsha10/nodejs_project"
    dockerImage = ""
  }

  agent any

  stages {
    

    stage('Build image') {
      steps {
          sh '''
           pwd
           docker exec -it jenkins_container_id bash
           apt-get update && apt-get install -y docker.io 
           docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker)  -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
           sudo docker
         '''
         }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhub'
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
        file(credentialsId: "kubernetes_config", variable: 'KUBECRED')
        
    ]) {
        sh """
       export KUBECONFIG=$KUBECRED
       kubectl apply -f deploymentservice.yml
        """
    
        }
      }
    }
  }
   /* post {
        success {
            slackSend channel: "#general", message: "Build Succeded: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        failure {
            slackSend failOnError:true, message:"Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }
*/


}
