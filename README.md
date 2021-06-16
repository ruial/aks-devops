# AKS DevOps

A simple end to end project to deploy a Go application on Kubernetes using Azure Devops Pipelines. Makes use of Terraform to provision the AKS cluster, ingress-nginx to route requests based on the HTTP Host header, cert-manager to handle TLS certificates from Let's Encrypt, and external-dns to manage DNS records. Read more about it on my [blog post](https://briefbytes.com/2021/Azure-Kubernetes-Service-Pipelines).
