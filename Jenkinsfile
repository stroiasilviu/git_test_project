pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('Install packages') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'nohup npm start &'
                sleep 10
                sh 'curl -k localhost:3000'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
                sh 'tar -czvf build.tar.gz build/*'
                archiveArtifacts artifacts: 'build.tar.gz', followSymlinks: false
                sh 'docker build -t appimg .'
                sh 'docker run -d -p 4000:80 --name app appimg'
                sleep 10
                sh 'curl -k localhost:4000'
            }
        }
        stage('Build docker image') {
            steps{
                sh 'docker build -t appimg .'
            }
        }
        stage('Clean-up containers') {
            steps{
                script {
                    def output = sh(returnStdout: true, script: "/bin/bash -c 'docker container ls -a | grep app'")
                    echo "Output: ${output}"
                    if (output != null){
                        sh 'docker container stop app'
                        sh 'docker container rm app'    
                    } else {
                        echo "skipping cleanup"
                    }
                }
            }

            }
        stage('Deploy container') {
            steps {
                sh 'docker run -d -p 4000:80 --name app appimg'
                sleep 10
                sh 'curl -k localhost:4000'
            }
        }
    }
}
