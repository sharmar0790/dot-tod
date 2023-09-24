---
layout: post
title:  "Welcome to Kong World!!!"
author: sal
categories: [ Jekyll, tutorial ]
image: assets/images/16.jpg
---
# Kong-demo

## What and Benefits
Kubernetes has become the name of the game when it comes to container orchestration. It allows teams to deploy and scale applications to meet changes in demand while providing a great developer experience.

The key to handling modern dynamic, scalable workloads in Kubernetes is a networking stack that can deliver API management, a service mesh and an ingress controller. Kong Ingress Controller allows users to manage the routing rules that control external user access to the service in a Kubernetes cluster from the same platform.

This article will look at how you can use Kong for full-stack application deployments with Kubernetes. By full-stack, we mean Kong can handle:

- Containers
- Container networking
- Pod networking
- Service networking
- Host networking
- Load balancing
- Rate limiting
- HTTPS redirects

## Usage
### Start `Minikube`

```
minikube start --nodes 2 --driver qemu --network socket_vmnet --cpus=4 --memory=6g --disk-size=10g
```


### Kong Installation
- Via Kubectl apply
```
kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/latest/deploy/single/all-in-one-dbless.yaml
```

- Using helm 
```
helm repo add kong https://charts.konghq.com 
helm repo update
```

- Helm 3
```
helm install kong/kong --generate-name --set ingressController.installCRDs=false
```


### Start `minikube tunnel`
`minikube tunnel`

### Note the `kong-proxy` load balancer ip
`kubectl get svc -n kong`
`kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy`

### Expose the App to the Internet
`kubectl apply -f deploy.yaml`

### Access the app via `kong`
`http://<KONG_PROXY_LB_IP>/<PATH>`

## Plugin
- kong-plugin.yaml
```
kubectl patch svc frontend \
  -p '{"metadata":{"annotations":{"konghq.com/plugins": "rl-by-ip\n"}}}'
```


# Configuring an HTTPS Redirect

```
kubectl patch ingress guestbook -p '{"metadata":{"annotations":{"konghq.com/protocols":"https","konghq.com/https-redirect-status-code":"301"}}}'
```

