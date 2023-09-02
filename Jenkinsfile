pipeline {
    agent any
    //tools {nodejs "node"}

    stages {
        
        stage("Build Docker Image") {
            steps {
                echo "building the application :  ${IMAGE_NAME}"
                sh "docker build -t ${IMAGE_NAME} ."
                
            }
        }
        stage("Login to Docker") {
            steps {
                echo 'Logging to DockerHub'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage("Push to DockerHub") {
            steps {
                echo 'Push to DockerHub'
                sh "docker push ${IMAGE_NAME}"
            }
        }
        stage("Deploying to Test Server"){
            steps{
                script{
                    echo "Test Server is working."
                    //def shellCmd = "bash ./serverCmd.sh ${IMAGE_NAME}"
            
                    //sshagent(['linode-blasterbk']) {
                        // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                       // sh 'scp serverCmd.sh blasterbk@170.187.251.224:/home/blasterbk'
                       // sh 'scp docker-compose.yaml blasterbk@170.187.251.224:/home/blasterbk'
                       // sh 'scp .env blasterbk@170.187.251.224:/home/blasterbk'
                        //sh "ssh -o StrictHostKeyChecking=no blasterbk@170.187.251.224 ${shellCmd}"
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
    
