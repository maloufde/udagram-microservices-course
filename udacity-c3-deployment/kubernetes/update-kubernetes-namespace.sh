#!/bin/bash

NAMESPACE=${1:?Namespace must be provided}

NL="\n"
#DRYRUN_OPTION="--dry-run"

function verify_namespace {
  echo "verify namespace ${NAMESPACE}"

  if ! kubectl get ns | grep ${NAMESPACE}
  then
    kubectl create namespace ${NAMESPACE} ${DRYRUN_OPTION:-}
  fi

}

function create_configmap {
  echo "create configmap"

  cat env-templates/udagram-configmap.yml \
  | sed "s/{{UDCD_POSTGRES_HOST}}/${UDCD_POSTGRES_HOST:?}/g" \
  | sed "s/{{UDCD_POSTGRES_DATABASE}}/${UDCD_POSTGRES_DATABASE:?}/g" \
  | sed "s/{{UDCD_AWS_PROFILE}}/${UDCD_AWS_PROFILE:?}/g" \
  | sed "s/{{UDCD_AWS_REGION}}/${UDCD_AWS_REGION:?}/g" \
  | sed "s/{{UDCD_AWS_MEDIA_BUCKET}}/${UDCD_AWS_MEDIA_BUCKET:?}/g" \
  | sed "s,{{UDCD_CORS_ALLOW}},${UDCD_CORS_ALLOW:?},g" \
  | kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f -

}

function create_env_secret {
  echo "create env-secret"

  UDCD_POSTGRES_USERNAME_BASE64=`echo -n ${UDCD_POSTGRES_USERNAME:?} | base64 -w 0`
  UDCD_POSTGRES_PASSWORD_BASE64=`echo -n ${UDCD_POSTGRES_PASSWORD:?} | base64 -w 0`
  UDCD_JWT_SECRET_BASE64=`echo -n ${UDCD_JWT_SECRET:?} | base64 -w 0`

  cat env-templates/udagram-env-secret.yml \
  | sed "s/{{UDCD_POSTGRES_USERNAME_BASE64}}/${UDCD_POSTGRES_USERNAME_BASE64}/g" \
  | sed "s/{{UDCD_POSTGRES_PASSWORD_BASE64}}/${UDCD_POSTGRES_PASSWORD_BASE64}/g" \
  | sed "s/{{UDCD_JWT_SECRET_BASE64}}/${UDCD_JWT_SECRET_BASE64}/g" \
  | kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f -

}

function create_aws_secret {
  echo "create aws-secret"

  AWS_CREDENTIALS_CONTENT="[default]${NL}aws_access_key_id = ${UDCD_AWS_ACCESS_KEY_ID:?}${NL}aws_secret_access_key = ${UDCD_AWS_SECRET_ACCESS_KEY:?}${NL}"
  AWS_CREDENTIALS_BASE64=`echo -e ${AWS_CREDENTIALS_CONTENT} | base64 -w 0`

  cat env-templates/udagram-aws-secret.yml \
  | sed "s/{{AWS_CREDENTIALS_BASE64}}/${AWS_CREDENTIALS_BASE64}/g" \
  | kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f -

}

function create_services {
  echo "create services"

  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f services/udagram-feed-service.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f services/udagram-user-service.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f services/udagram-proxy-service.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f services/udagram-frontend-service.yml
}

function create_deployments {
  echo "create deployments"

  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f deployments/restapi-feed-deployment.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f deployments/restapi-user-deployment.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f deployments/reverseproxy-deployment.yml
  kubectl apply -n $NAMESPACE ${DRYRUN_OPTION:-} -f deployments/frontend-deployment.yml
}

# Start
verify_namespace
create_configmap
create_env_secret
create_aws_secret
create_services
create_deployments
