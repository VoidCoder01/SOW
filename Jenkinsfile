pipeline {
    agent any
    
    environment {
        PYTHON_VERSION = '3.9'
        DOCKER_IMAGE = 'job-dashboard'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "📥 Checked out code from ${env.GIT_BRANCH}"
            }
        }
        
        stage('Setup Python') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'python3 --version'
                        sh 'python3 -m pip install --upgrade pip'
                        sh 'python3 -m pip install -r requirements.txt'
                    } else {
                        bat 'python --version'
                        bat 'python -m pip install --upgrade pip'
                        bat 'python -m pip install -r requirements.txt'
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'python3 render_data.py'
                    } else {
                        bat 'python render_data.py'
                    }
                }
                echo "🔨 Build completed successfully"
            }
        }
        
        stage('Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            # Check if HTML file exists and has content
                            if [ ! -s index.html ]; then
                                echo "❌ HTML file is empty or missing"
                                exit 1
                            fi
                            
                            # Validate statistics are populated
                            if ! grep -q 'id="total-jobs">[0-9]' index.html; then
                                echo "❌ Total jobs not found in HTML"
                                exit 1
                            fi
                            
                            if ! grep -q 'id="us-jobs">[0-9]' index.html; then
                                echo "❌ US jobs not found in HTML"
                                exit 1
                            fi
                            
                            if ! grep -q 'id="remote-jobs">[0-9]' index.html; then
                                echo "❌ Remote jobs not found in HTML"
                                exit 1
                            fi
                            
                            echo "✅ All tests passed!"
                        '''
                    } else {
                        bat '''
                            REM Check if HTML file exists and has content
                            if not exist index.html (
                                echo ❌ HTML file is missing
                                exit /b 1
                            )
                            
                            REM Basic validation (Windows batch is limited)
                            findstr "id=\"total-jobs\">[0-9]" index.html >nul
                            if errorlevel 1 (
                                echo ❌ Total jobs not found in HTML
                                exit /b 1
                            )
                            
                            echo ✅ Basic tests passed!
                        '''
                    }
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    } else {
                        bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                        bat "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    }
                }
                echo "🐳 Docker image built successfully"
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            # Deploy to staging/production
                            echo "🚀 Deploying to production..."
                            
                            # Stop existing containers
                            docker-compose down || true
                            
                            # Start new containers
                            docker-compose up -d
                            
                            # Health check
                            sleep 10
                            curl -f http://localhost:8080/health || exit 1
                            
                            echo "✅ Deployment completed successfully!"
                        '''
                    } else {
                        bat '''
                            REM Deploy to staging/production
                            echo 🚀 Deploying to production...
                            
                            REM Stop existing containers
                            docker-compose down
                            
                            REM Start new containers
                            docker-compose up -d
                            
                            echo ✅ Deployment completed successfully!
                        '''
                    }
                }
            }
        }
        
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'index.html', fingerprint: true
                echo "📦 Artifacts archived successfully"
            }
        }
    }
    
    post {
        always {
            echo "🏁 Pipeline completed with status: ${currentBuild.result}"
        }
        success {
            echo "🎉 Pipeline succeeded!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
        cleanup {
            script {
                if (isUnix()) {
                    sh 'docker system prune -f || true'
                } else {
                    bat 'docker system prune -f || exit 0'
                }
            }
        }
    }
}
