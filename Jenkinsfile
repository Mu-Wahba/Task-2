pipeline {
    agent {
            label "mynode"
    }
    environment{
	    MY_EMAIL = credentials('my_email')
	    DOCKER_USER = credentials('docker_user')
	    DOCKER_PASS = credentials('docker_pass')
	}
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Dockerize the App') {
            steps {
                sh "docker build -t ${DOCKER_USER}/my-app:${BUILD_NUMBER} ."
                sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                sh "docker push ${DOCKER_USER}/my-app:${BUILD_NUMBER}"
                  }
	                               }
	   stage('Deploy to the cluster') {
	       // agent {label "Production Instances" } we Should define our production instances
            steps {
                //admin must trigger deployment process manually within 60s to start deployment
		timeout(time:60 , unit:'SECONDS'){
			input message: 'Are you sure!!', ok:'YES!',submitter:'admin'
		}
                sh './scripts/deploy_to_cluster.sh 2'
                  }
                                  }
    }
    post {
	always {
	    // you may want to set post build for each case (sucess,failure,...etc)
		archiveArtifacts artifacts:'target/*.jar'
		mail ( from: 'Muhammad Wahba',
			   to: "${MY_EMAIL}",
			   subject: "${JOB_NAME}",
			   body: "Running build: ${BUILD_NUMBER} by executer ${EXECUTOR_NUMBER} , on node: ${NODE_NAME}")	
	    
	      }
       } 
    options{
        //No. of artifacts to keep
	buildDiscarder(logRotator(numToKeepStr:'3'))
	//pipeline timeout
	timeout(time:60, unit:'MINUTES')

}   

}
