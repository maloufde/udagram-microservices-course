#!/bin/bash

mkdir -p ${HOME}/.kube
cp kubeconfig-template ${HOME}/.kube/config

kubectl config set clusters.maloufde-udagram.server "${KUBECTL_SERVER:?}"
kubectl config set clusters.maloufde-udagram.certificate-authority-data "${KUBECTL_CLUSTER_CERT:?}"
kubectl config set users.kubernetes-admin.client-certificate-data "${KUBECTL_CLIENT_CERT:?}"
kubectl config set users.kubernetes-admin.client-key-data "${KUBECTL_CLIENT_KEY_DATA:?}"
