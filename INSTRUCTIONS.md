# Task

Build Json API application to short urls using Golang. The goal of the application is to short url https://en.wikipedia.org/wiki/URL_shortening. Feel free to use any kind of service required to build and run this application.

## API Specification

### POST /url

Create a new short url and return status code depends different states.

* Sample Request: `{"url": "http://google.com"}`
* Sample Response: `{"url": "http://google.com", "short": "http://localhost:3000/gIld"}`
* Return HTTP status 201 on success
* Return HTTP status 422 if there is invalid paramaters

### GET /*url

Search in the storage for original url and redirects.

* Return HTTP status 301/302 and Location where to redirect
* Return HTTP status 404 if there are no such url

### GET /version

Return current deployed version.

* Sample Response: `{"version": "v0.10.123"}`
* Return HTTP status 200 if application is alive and ready to process requests

### GET /metrics

In the STDOUT we should see metrics in JSON format.
Sample: `{"requests": 312, "rate_1s": 1, "rate_10s": 2, "latency_1s": 12}`.
Feel free to add own custom metrics.

## Deployment

We need to deploy application and all related service to Kubernetes cluster. Feel free to use minikube for testing or any other solution to setup a Kubernetes cluster. For testing will be used Kubernetes on AWS.

The goal of this phase: you provide simple instructions or automated script to create infrastructure for this application. The infrastructure should be scalable.

## Test on reliability

Write script `bin/benchmark`or documentation how to test performance and reliability of the application. 
