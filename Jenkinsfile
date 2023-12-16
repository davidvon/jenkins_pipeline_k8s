// 需要在jenkins的Credentials设置中配置jenkins-harbor-creds、jenkins-k8s-config参数
pipeline {
    agent any
//     environment {
// //         HARBOR_CREDS = credentials('jenkins-harbor-creds')
// //         K8S_CONFIG = credentials('jenkins-k8s-config')
// //         GIT_TAG = "v0.01" //sh(returnStdout: true,script: 'git describe --tags --always').trim()
//     }
    parameters {
        string(name: 'HARBOR_HOST', defaultValue: '172.23.101.66', description: 'harbor仓库地址')
        string(name: 'DOCKER_IMAGE', defaultValue: 'davidvon/pipeline-demo', description: 'docker镜像名')
        string(name: 'APP_NAME', defaultValue: 'pipeline-demo', description: 'k8s中标签名')
        string(name: 'K8S_NAMESPACE', defaultValue: 'demo', description: 'k8s的namespace名称')
    }
    stages {
        stage('Maven Build') {
//             when { expression { env.GIT_TAG != null } }
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
//             when {
//                 allOf {
//                     expression { env.GIT_TAG != null }
//                 }
//             }
            agent any
            steps {
                unstash 'app'
                sh "docker login -u 108424@qq.com -p Davidvon12345"
                sh "docker build --build-arg JAR_FILE=`ls target/*.jar |cut -d '/' -f2` -t davidvon/${params.DOCKER_IMAGE}:v0.01 ."
                sh "docker push davidvon/${params.DOCKER_IMAGE}:v0.01"
                sh "docker rmi davidvon/${params.DOCKER_IMAGE}:v0.01"
            }
            
        }
        stage('Deploy') {
//             when {
//                 allOf {
//                     expression { env.GIT_TAG != null }
//                 }
//             }
            agent {
                docker {
                    image 'lwolf/helm-kubectl-docker'
                }
            }
            steps {
                sh "sed -e 's#{IMAGE_URL}#davidvon/${params.DOCKER_IMAGE}#g;s#{IMAGE_TAG}#v0.01#g;s#{APP_NAME}#${params.APP_NAME}#g;s#{SPRING_PROFILE}#k8s-test#g' k8s-deployment.tpl > k8s-deployment.yml"
                sh "kubectl apply -f k8s-deployment.yml --namespace=${params.K8S_NAMESPACE}"
            }
            
        }
        
    }
}
