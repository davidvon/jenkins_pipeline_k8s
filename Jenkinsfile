// 需要在jenkins的Credentials设置中配置jenkins-harbor-creds、jenkins-k8s-config参数
//     environment {
//         HARBOR_CREDS = credentials('jenkins-harbor-creds')
//         K8S_CONFIG = credentials('jenkins-k8s-config')
//         GIT_TAG = sh(returnStdout: true,script: 'git describe --tags --always').trim()
//     }

pipeline {
    agent any
    parameters {
        string(name: 'GIT_TAG', defaultValue: 'v0.0.1', description: 'TAG分支')
        string(name: 'REPO_EMAIL', defaultValue: '108424@qq.com', description: '仓库用户邮箱')
        string(name: 'REPO_PWD', defaultValue: 'Davidvon12345', description: '仓库密码')
        string(name: 'REPO_HOST', defaultValue: '', description: '仓库地址')
        string(name: 'DOCKER_IMAGE', defaultValue: 'davidvon/pipeline-demo', description: 'docker镜像名')
        string(name: 'APP_NAME', defaultValue: 'pipeline-demo', description: 'k8s中标签名')
        string(name: 'K8S_NAMESPACE', defaultValue: 'demo', description: 'k8s的namespace名称')
    }
    stages {
        stage('Maven Build') {
            when { expression { params.GIT_TAG != null } }
            agent {
                docker {
                    image 'maven:3-jdk-8-alpine'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean package -Dfile.encoding=UTF-8 -DskipTests=true'
                stash includes: 'target/*.jar', name: 'app'
            }

        }
        stage('Docker Build') {
            when {
                allOf {
                    expression { params.GIT_TAG != null }
                }
            }
            agent any
            steps {
                unstash 'app'
                sh "docker login -u ${params.REPO_EMAIL} -p ${params.REPO_PWD} ${params.REPO_HOST}"
                sh "docker build --build-arg JAR_FILE=`ls target/*.jar |cut -d '/' -f2` -t ${params.DOCKER_IMAGE}:${params.GIT_TAG} ."
                sh "docker push ${params.DOCKER_IMAGE}:${params.GIT_TAG}"
                sh "docker rmi ${params.DOCKER_IMAGE}:${params.GIT_TAG}"
            }

        }
        stage('Deploy') {
            when {
                allOf {
                    expression { params.GIT_TAG != null }
                }
            }
            agent {
                docker {
                    image 'lwolf/helm-kubectl-docker'
                }
            }
            steps {
//                 sh "mkdir -p ~/.kube"
//                 sh "echo ${K8S_CONFIG} | base64 -d > ~/.kube/config"
                sh "sed -e 's#{DOCKER_IMAGE}#${params.DOCKER_IMAGE}#g;s#{IMAGE_TAG}#${params.GIT_TAG}#g;s#{APP_NAME}#${params.APP_NAME}#g;s#{SPRING_PROFILE}#k8s-test#g' k8s-deployment.tpl > k8s-deployment.yml"
                sh "kubectl apply -f k8s-deployment.yml"
//                 --namespace=${params.K8S_NAMESPACE}
            }
            
        }
        
    }
}
