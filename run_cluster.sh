#!/usr/bin/env bash

eval $(minikube docker-env)
docker build -t app:latest

if [[ $(minikube status | grep 'host: Running') == 'host: Running' ]]; then
  echo "WARNING: Minikube is already running"
fi

if [[ $(minikube status | grep 'host: Stopped') == 'host: Stopped' ]]; then
  minikube start
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $(minikube status | grep 'host: Running') == 'host: Running' ]]; then
  echo ""
  kubectl create -f $DIR/k8s/namespace.yaml --namespace=symfony
  echo ""
  echo ""
  kubectl create -f $DIR/k8s/persistence.yaml --namespace=symfony
  echo ""
  echo ""
  kubectl apply -f $DIR/k8s/ingress.yaml --namespace=symfony
  echo ""
  kubectl create -f $DIR/k8s/deployment.yaml --namespace=symfony
  kubectl create -f $DIR/k8s/service.yaml --namespace=symfony
  echo ""
  URL_HTTP="$(minikube service symfony --url --namespace=symfony | sed -n '1 p')"
  URL_HTTPS="$(minikube service symfony --url --namespace=symfony | sed -n '2 p')"
  echo ""
  echo "SYMFONY HTTP ENDPOINT -> ${URL_HTTP}"
  echo "SYMFONY HTTPS ENDPOINT -> ${URL_HTTPS}"
  echo ""
fi