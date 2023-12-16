jenkins pipeline示例，详细说明参见：https://www.jianshu.com/p/2d89fd1b4403

docker run \
  -d \
  -u root \
  -p 9980:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean
