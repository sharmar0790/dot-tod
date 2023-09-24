---
layout: post
title:  "Traefik"
author: commando
categories: [ Jekyll, tutorial ]
image: assets/images/1.jpg
---
# Traefik-demo

## What is Traefik
Kubernetes Ingress and Traefik Ingress controller are considered essential components of any Kubernetes cluster for managing and routing external traffic to your Kubernetes services. In this article, we’ll explore the basics of Kubernetes Ingress, and the process of installing Traefik Ingress controller on a Kubernetes cluster, and how you can utilize it to manage traffic in a Kubernetes cluster.

A Kubernetes Ingress is a resource that defines rules for managing external traffic to Kubernetes services. This resource has rules that define how traffic is routed to different Kubernetes services based on criteria such as hostnames, paths, and protocols. An Ingress Controller is a component within Kubernetes that manages incoming traffic to Kubernetes internal services. An Ingress controller is used to manage traffic at Layer 7 (HTTP/HTTPS) and also for terminating SSL/TLS and provide load balancing capabilities.

**Main functions of an Ingress Controller:**

Receive incoming external traffic and forwards it to the appropriate Kubernetes backend service.
Implements routing rules specified in an Ingress resource.
Handles SSL/TLS encryption and decryption – SSL termination.
Provides load balancing capabilities to distribute traffic across multiple pods and nodes in a Kubernetes cluster.
There are several Ingress Controllers available for use in Kubernetes environment, and each has its own set of features and capabilities. The one that we’ll use in this article is Traefik Ingress Controller.

Traefik Ingress Controller is a modern, cloud-native, and dynamic Ingress Controller with support for several backends and can be used to manage traffic across multiple Kubernetes clusters. Traefik provides advanced routing capabilities and load balancing features.


## Usage
### Start `Minikube`

```
minikube start --nodes 2 --driver qemu --network socket_vmnet --cpus=4 --memory=6g --disk-size=10g
```

### Start `minikube tunnel`
`minikube tunnel`

### Install `traefik`
Via Helm
```shell
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

# Install
helm install traefik traefik/traefik --namespace traefik --create-namespace

# verify
kubectl get svc -l app.kubernetes.io/name=traefik
```

### Expose the App to the Internet
`kubectl apply -f deploy.yaml`

### Apply Igress
`kubectl apply -f ingress.yaml`

## Cleanup

```shell
# - traefik
helm uninstall traefik -n traefik

# - minikube
minikube delete
```
