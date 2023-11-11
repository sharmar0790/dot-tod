---
layout: post
title:  "Quick glance to the Traefik Ingress Controllers"
author: commando
# categories: [ Jekyll, tutorial ]
# image: assets/images/1.jpg
---

Ingress controllers are simply a reverse proxy that sits between the end users and actual application services. It provides an abstraction layer to the clients and provides an easy way to access all of the application running inside the Kubernetes cluster.

You might be thinking ingress controller only does provide an abstraction layer, here you're wrong. However, it provides other functionality as well like 
- Certificate management
- Centralised Monitoring.
- Authentication and Authorization.
- Caching
- Many more.

In this article I am going to discuss with you one of the Ingress Controller - Traefik. How it works and a small demo.

**Traefik** controller provides many out of the box functionlity like
- API Management
- API Gateway
- Kubernetes Ingress
- Docker Swarm Ingress

For demo I'm going to create a 
- minikube cluster
- deploy Traefik controller
- sample microservice.


## Usage
### Start `Minikube`

```
minikube start --driver qemu --network socket_vmnet --cpus=4 --memory=6g --disk-size=10g
```

### Start `minikube tunnel`
`$ minikube tunnel`

### Install `traefik`
```shell
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

# Install
helm install traefik traefik/traefik --namespace traefik --create-namespace

# verify
kubectl get svc -l app.kubernetes.io/name=traefik
```

```
❯ kubectl get pods -n traefik
NAME                       READY   STATUS    RESTARTS   AGE
traefik-6f88d7c47d-52xp8   1/1     Running   0          18s
```

## Deploying a sample service
Here, I will be deploying the sample `whoami` pod for keep this demo as simple and small.

```yaml
#  Deploy.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami
  namespace: traefik
spec:
  replicas: 1
  selector:
    matchLabels:
      app: whoami
  template:
    metadata:
      labels:
        app: whoami
    spec:
      containers:
      - name: whoami
        image: traefik/whoami
---
apiVersion: v1
kind: Service
metadata:
  name: whoami
  namespace: traefik
spec:
  ports:
  - name: http
    targetPort: 80
    port: 80
  selector:
    app: whoami
```

You can deploy it simply by running:

`$ kubectl apply -f whoami.yaml`

Then you can validate the deployment is running:

```shell
❯ kubectl get pods -n traefik
NAME                       READY   STATUS    RESTARTS   AGE
traefik-6f88d7c47d-52xp8   1/1     Running   0          3m21s
whoami-6f57d5d6b5-6rwvw    1/1     Running   0          5s
```

## Creating the Ingress
```yaml
# ingress.yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: whoami
  namespace: traefik
spec:
  rules:
  - http:
      paths:
      - path: /whoami
        pathType: Prefix
        backend:
          service:
            name: whoami
            port:
              number: 80
```              

Apply the manifest using:

`$ kubectl apply -f ingress.yaml`

Validate the ingress

```shell
❯ kubectl get ingress -n traefik
NAME     CLASS     HOSTS   ADDRESS   PORTS   AGE
whoami   traefik   *                 80      33s
```

```shell
❯ k get svc -n traefik
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
traefik   LoadBalancer   10.111.125.174   10.111.125.174   80:31986/TCP,443:30507/TCP   6m23s
whoami    ClusterIP      10.107.63.105    <none>           80/TCP                       3m7s
```

Access the ingress application
```
❯ curl 10.111.125.174/whoami
Hostname: whoami-6f57d5d6b5-6rwvw
IP: 127.0.0.1
IP: 10.244.0.4
RemoteAddr: 10.244.0.3:43740
GET /whoami HTTP/1.1
Host: 10.111.125.174
User-Agent: curl/8.1.2
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 10.244.0.1
X-Forwarded-Host: 10.111.125.174
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: traefik-6f88d7c47d-52xp8
X-Real-Ip: 10.244.0.1
```

## Cleanup
`minikube delete`

## Conclusion
Ingress Controllers are powerful and can give you granular control over the networking on your Kubernetes cluster. In this article I tried to show how we can use the ingress controller with very minimal settings and locally using `minikube`. 
