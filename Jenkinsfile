pipeline {
    agent any
    //tools {nodejs "node"}
  environment {     
    DOCKERHUB_CREDENTIALS= credentials('docker-hub')
    IMAGE_NAME = 'arvindkaushik/samplenode:1.0'
}
    stages {
        
        stage('Build Docker Image') {  
       steps{                     
	//sh 'docker build -t ${IMAGE_NAME} .'     
	echo 'Build Image Completed'                
    }           
    } 
      stage('Login to Docker Hub') {      	
           steps{                       	
	      // sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                		
	       echo 'Login Completed'      
               }           
           } 

      stage('Push Image to Docker Hub') {         
         steps{                            
         //sh 'docker push ${IMAGE_NAME}'           
         echo 'Push Image Completed'       
           }            
          }
        stage("Deploying to Test Server"){
            steps{
                script{
                    echo "Test Server is working."
                    def shellCmd = "bash ./serverCmd.sh ${IMAGE_NAME}"
            
                    //sshagent(['arvind-ssh']) {
                    
                        // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                       // sh 'scp serverCmd.sh root@172.105.52.152:/home/arvind'
                        //sh 'scp docker-compose.yml root@172.105.52.152:/home/arvind'
                        //sh 'scp .env root@172.105.52.152:/home/arvind'
                        //sh "ssh -o StrictHostKeyChecking=no root@172.105.52.152"
                    //}
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
                        sshagent(['arvind-ssh']) {
                            // when you use variable in ssh, then use double quote. If you're using single quote, then it will not work.
                            sh 'scp serverCmd.sh root@172.105.52.152:/root'
                            sh 'scp docker-compose.yml root@172.105.52.152:/root'
                           // sh 'scp .env root@172.105.52.152:/root'
                            sh "ssh -o StrictHostKeyChecking=no root@172.105.52.152 ${shellCmd}"
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
    
