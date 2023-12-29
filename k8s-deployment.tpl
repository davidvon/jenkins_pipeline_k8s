apiVersion: apps/v1
kind: Deployment
metadata:
  name: {APP_NAME}
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
      - image: {DOCKER_IMAGE}:{IMAGE_TAG}
        name: {APP_NAME}
        ports:
        - containerPort: 30080
---
apiVersion: v1
kind: Service
metadata:
  name: {APP_NAME}-svc
  labels:
    app: {APP_NAME}
spec:
  selector:
    app: {APP_NAME}
  ports:
    - port: 30080
      targetPort: 30080
  type: NodePort
