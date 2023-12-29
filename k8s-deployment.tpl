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
      - name: {APP_NAME}
        image: {DOCKER_IMAGE}:{IMAGE_TAG}
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: {APP_NAME}
  labels:
    app: {APP_NAME}
spec:
  selector:
    app: {APP_NAME}
  ports:
    - port: 30080
      targetPort: 30080
  type: NodePort
