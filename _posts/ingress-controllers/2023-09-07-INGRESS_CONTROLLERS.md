---
layout: post
title:  "Ingress Controllers"
author: commando
# categories: [ Jekyll, tutorial ]
# image: assets/images/1.jpg
---

# Kubernetes Ingress Controller

## What is Kubernetes Ingress Controller?
Moving production workloads to Kubernetes has many benefits, but it also increases the complexity of managing application traffic. An ingress controller is a dedicated load balancer for Kubernetes clusters.

A kubernetes ingress controller acts an reverse proxy and as a load balancer. An ingress controller is a component that abstracts the complexity of routing application traffic within a Kubernetes cluster, providing a bridge between Kubernetes services and external services. An ingress controller is configured using objects called Ingress Resources, managed via the Kubernetes API.

The main functions of a Kubernetes ingress controller are to receive and load-balance traffic from outside Kubernetes to pods running in a Kubernetes cluster, and manage egress traffic from services within the cluster to services outside the cluster. They monitor pods running on Kubernetes and automatically update load balancing rules when pods are added or removed from a service. This is part of a series of articles about [Kubernetes API gateway](https://www.solo.io/topics/kubernetes-api-gateway/).

## Benefits and Limitations
Technically, an ingress is not a service, it is a layer 7 (application layer) router that is typically exposed through a load balancer service. It is cheaper than using a cloud load balancer for each service as it relies on an ingress controller which is hosted together with the application. It ensures each service has only one IP that can be accessed from the internet, and traffic intended for this IP is routed to the correct service by the ingress controller.

### Benefits :
- **Provides secure access** to services over HTTP or HTTPS paths, instead of using direct connections. 
- **Creates access routes** to multiple services, with full control over routing of services and conditions for external access. 
- **Creates a single path** for ingress traffic, which can be modified based on conditions defined by the operator, instead of opening many connections to access a Kubernetes application.
- **Simplifies management** of complex ingress processes, with the ability to easily manage access to multiple services in one system. This can have a significant impact on performance and management costs of large systems.
- All ingress controllers support a set of annotations that enable specific software-based features. For example, in the Traefik ingress controller, users can use annotations to add middleware to ingress, even if not supported by the Ingress specification.

### Limitations :
- The Ingress controller only handles layer 7 traffic, while an ingress routes HTTP and HTTPS traffic. This means it is not possible to route TCP and UDP traffic.
- Ingress is used in a single namespace. This means that anything within a Kubernetes namespace can only reference services within the same namespace. To solve this problem, Kubernetes has introduced a gateway API specification, which enables cross-namespace communication. This specification is still in alpha status. A Kubernetes-native API Gateway can be used today for cross-namespace communications.

### How to choose an ingress controller

There are several ingress controllers available in Kubernetes, each has advantages and preferred use cases. It can be challenging to select the ingress controller suitable for your needs.

If you’re managing a small production environment and don’t plan to scale it, you probably need only the standard features such as load balancing, flow control, and flow splitting. Be careful not to select a controller that has more functionality than you need, because this can negatively impact performance and create unneeded management complexity. 

However, if your application runs in a distributed, multi-cloud environment, you may need an enterprise-grade, high-performance networking solution. 

## Ingress Controller Solutions
Kubernetes currently provides two ingress solutions by default —GCE L7 Load Balancer (GLBC) and ingress-nginx. You can use other solutions, but you’ll have to first deploy them in your Kubernetes cluster. Here is a full list of ingress controllers supported by Kubernetes. 

We’ll cover a few popular open source solutions.

### Istio Ingress
Istio Ingress is a service mesh solution that can also serve as an ingress controller, regulating outside traffic entering a Kubernetes cluster. Istio makes use of Envoy proxies, deployed in a sidecar container alongside every exposed service in the cluster. Envoy offers advanced traffic routing and observability capabilities.

When Istio is used as an ingress solution, it runs completely separated from services, intercepting all traffic and collecting metrics, tracing headers, and applying JWT authentication.

### NGINX
Ingress-nginx is an open-source ingress controller built into the official Kubernetes distribution. It is based on the NGINX reverse proxy, and provides simple HTTP/S routing and SSL capabilities.

NGINX Plus provides an expanded version of the basic ingress-nginx controller, with improved performance and additional features, including tracing, active health checks, JSON Web Token (JWT) authentication, and OpenID single sign on (SSO). It is a commercial software product sold on a subscription basis by NGINX, Inc.

### Traefik
Traefik, created by Containous, was originally built as an HTTP reverse proxy and load balancer with dynamic routing capabilities. It is written in Go, allowing it to support Kubernetes as well as other container environments. 

Traefik offers HTTP/2, WebSocket, and certificate encryption based on Let’s Encrypt (an open certificate authority) by default making it easy to implement for beginners. It also provides a UI that visualizes controller and Kubernetes metrics.

### Kong Ingress
Kong was originally designed as an API Gateway. Recently, its makers added gRPC support, active health checks on load balancers, and request/response authentication, making it a good option for Kubernetes ingress.

Kong has the benefit of blocking privilege escalation by ensuring the controller can only operate in one Kubernetes namespace.