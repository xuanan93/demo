pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "registry.anvx.local/anvx-python"
    DOCKER_REGISTRY = "https://registry.anvx.local/v2/"
  }

  // stages {
  //   stage("Test") {
  //     agent {
  //         docker {
  //           image 'python:3.8-slim-buster'
  //           args '-u 0:0 -v /tmp:/root/.cache'
  //         }
  //     }
  //     steps {
  //       sh "pip install poetry"
  //       sh "poetry install"
  //       sh "poetry run pytest"
  //     }
  //   }
  
  stages {
    stage("Test") {
      agent {
          docker {
            image 'node:12.22.10-slim'
            args '-u 0:0 -v /tmp:/root/.cache'
          }
      }
      steps {
        sh 'npm install'
       
      }
    }

    stage("build") {
      agent { node {label 'master'}}
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-registry-local', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY'
        }

        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . " 
        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        script {
          if (GIT_BRANCH ==~ /.*master.*/) {
            sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            sh "docker push ${DOCKER_IMAGE}:latest"
          }
        }

        //clean to save disk
         //clean to save disk
         //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
      }
    }
     }

  post {
    success {
      echo "SUCCESSFUL"
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}
