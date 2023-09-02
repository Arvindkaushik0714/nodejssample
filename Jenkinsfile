pipeline {
    agent any
    //tools {nodejs "node"}
    environment {
        DOCKERHUB_CREDENTIALS=credentials('docker-hub')
        IMAGE_NAME = 'blasterbk/my-app:1.0.28'
    }

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
                    def shellCmd = "bash ./serverCmd.sh ${IMAGE_NAME}"
            
                    sshagent(['linode-blasterbk']) {
                        // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                        sh 'scp serverCmd.sh blasterbk@170.187.251.224:/home/blasterbk'
                        sh 'scp docker-compose.yaml blasterbk@170.187.251.224:/home/blasterbk'
                        sh 'scp .env blasterbk@170.187.251.224:/home/blasterbk'
                        sh "ssh -o StrictHostKeyChecking=no blasterbk@170.187.251.224 ${shellCmd}"
                    }
                }
            }

        }
      
        stage("Deploying to Production Server") {
            input {
                message "Select the environment to deploy to"
                ok "Done"
                parameters{
                    choice(name:'Decision' , choices: ['Deploy to Prod', 'Denay'], description: '')      
                }
            }

            steps {
                script {
                    def name = "${Decision}"
                    // sh "echo SUCCESS on ${Test}"
                    echo "Test part : $name"
                    echo 'deploying the application !'

                    if(name == "Deploy to Prod"){
                        echo "Development is working."
                        def shellCmd = "bash ./serverCmd.sh ${IMAGE_NAME}"          
                        sshagent(['linode-blasterbk']) {
                            // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                            sh 'scp serverCmd.sh root@45.79.120.68:/root'
                            sh 'scp docker-compose.yaml root@45.79.120.68:/root'
                            sh 'scp .env root@45.79.120.68:/root'
                            sh "ssh -o StrictHostKeyChecking=no root@45.79.120.68 ${shellCmd}"
                    }
                    }
                    if(name == "Denay"){
                        echo "Not Deploy to Production"
                    }
                    else{
                        // sh "echo SUCCESS on ${Test}"
                        echo "Else part"
                    }

                    // def shellCmd = "bash ./serverCmd.sh ${IMAGE_NAME}"          
                    // sshagent(['linode-blasterbk']) {
                    //     // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                    //     sh 'scp serverCmd.sh blasterbk@170.187.251.224:/home/blasterbk'
                    //     sh 'scp docker-compose.yaml blasterbk@170.187.251.224:/home/blasterbk'
                    //     sh 'scp .env blasterbk@170.187.251.224:/home/blasterbk'
                    //     sh "ssh -o StrictHostKeyChecking=no blasterbk@170.187.251.224 ${shellCmd}"
                    // }
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
    
