---
layout: post
title:  "Nginx World"
author: commando
categories: [ nginx, tutorial, ingress ]
image: assets/images/1.jpg
---
# Nginx-Ingress-demo

## What and Benefits
The NGINX Ingress Controller an implementation of a Kubernetes Ingress Controller for NGINX and NGINX Plus.

**What is the Ingress?**
This is one of a special type of kubernetes resources which extend the kubernetes functionality to deliver the outside/external request to the underline kubernetes services/resources. It also lets you configure an HTTP load balancer for applications running on Kubernetes, represented by one or more Services. 

The Ingress resource supports the following features:

- **Content-based routing:**
  - Host-based routing. For example, routing requests with the host header foo.example.com to one group of services and the host header bar.example.com to another group.
  - Path-based routing. For example, routing requests with the URI that starts with /serviceA to service A and requests with the URI that starts with /serviceB to service B.

## Usage
### Start `Minikube`

```
minikube start --nodes 2 --driver qemu --network socket_vmnet --cpus=4 --memory=6g --disk-size=10g
```

### Create `EKS` cluster
```shell
eksctl create cluster \
  --name nlb-lab \
  --version 1.20 \
  --nodegroup-name nlb-lab-workers \
  --node-type t2.medium \
  --nodes 2 \
  --region us-west-2
```

### Install `Nginx`
- Via Kubectl apply
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml
```
- Via Helm
```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

# Install
helm install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true --namespace nginx-ingress --create-namespace

# Verify
kubectl get pods --all-namespaces -l app=nginx-ingress-nginx-ingress
```

### Start `minikube tunnel`
`minikube tunnel`

### Expose the App to the Internet
`kubectl apply -f deploy.yaml`

### Apply Igress
`kubectl apply -f ingress.yaml`

### Validate the changes
At this point changes can be validated by directly hitting the LB hostname by appending the URI.  
EX: curl -vk https://a9f699f8ab8894c368345dd10bcc962a-6436a3934072ca42.elb.eu-west-2.amazonaws.com/api/v1/health  
Response:    
```shell
curl -I a9f699f8ab8894c368345dd10bcc962a-6436a3934072ca42.elb.eu-west-2.amazonaws.com/api/v1/health 
HTTP/1.1 200 
Date: Mon, 28 Aug 2023 16:32:23 GMT
Content-Type: application/json
Content-Length: 185
Connection: keep-alive

curl  a9f699f8ab8894c368345dd10bcc962a-6436a3934072ca42.elb.eu-west-2.amazonaws.com/api/v1/health 
{ 
  "Status" : "OK",
  "Version" : "V4-Argo-Resyncing",
  "Hostname": "parking-lot-8466dbbbbc-xqjxj",
  "Hostaddr": "10.0.2.204",
  "CanonicalHostName": "parking-lot-8466dbbbbc-xqjxj"
}
```

Now, we will be implementing the `cert-manager` to add the certificate so to terminate the request via `https`.

### Install `cert-manager`
```shell
helm repo add jetstack https://charts.jetstack.io
helm repo update

# next, install Cert-Manager into your cluster:

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.2 \
  --set installCRDs=true
```

### Delete `admissionhooks`
In this example, I will be adding the loadbalancer hostname as a hosts for this example and by default `cert-manager` admission hooks won't allow me to do so as there is a validation that common name cannot be more than 65 bytes. Thus, for this, we need to delete the below two admissionhooks.

```shell
kubectl delete validatingwebhookconfigurations cert-manager-webhook
kubectl delete mutatingwebhookconfigurations cert-manager-webhook
```

## Cleanup
cert-manager
```shell
helm ls
helm uninstall cert-manager -n cert-manager
```

nginx-ingress
```shell
helm uninstall nginx-ingress 
or 
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml
```
