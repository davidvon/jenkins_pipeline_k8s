apiVersion: apps/v1
kind: Deployment
metadata:
  name: {APP_NAME}-deployment
  labels:
    app: {APP_NAME}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {APP_NAME}
  template:
    metadata:
      labels:
        app: {APP_NAME}
    spec:
      containers:
      - name: {APP_NAME}
        image: {DOCKER_IMAGE}:{IMAGE_TAG}
        ports:
        - containerPort: 8080
        env:
          - name: SPRING_PROFILES_ACTIVE
            value: {SPRING_PROFILE}
---
apiVersion: v1
kind: Service
metadata:
  name: {APP_NAME}-service
  labels:
    app: {APP_NAME}
spec:
  selector:
    name: {APP_NAME}
    app: {APP_NAME}
  ports:
    - port: 8088
      targetPort: 8080
      nodePort: 30000
  type: NodePort
