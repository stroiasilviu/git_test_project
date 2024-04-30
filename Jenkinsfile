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
        stage('Clean-up containers') {
            steps{
                sh '''
                    if docker container ls -a | grep app ;
                    then
                        docker container stop app
                        docker container rm app
                    fi   
                ''' 
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
       
        stage('Deploy container') {
            steps {
                sh 'docker run -d -p 4000:80 --name app appimg'
                sleep 10
                sh 'curl -k localhost:4000'
            }
        }
    }
}
