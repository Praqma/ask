#!/bin/bash

PUBLISH=false
if [ "$1" == "publish" ]; then 
PUBLISH=true
fi

function sanity_check() {
  if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    echo "AWS_ACCESS_KEY_ID found empty. Exiting ..."
    exit 1
  fi

  if [ -z "${AWS_DEFAULT_REGION}" ]; then
    echo "AWS_DEFAULT_REGION found empty. Exiting ..."
    exit 1
  fi

  if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "AWS_SECRET_ACCESS_KEY found empty. Exiting ..."
    exit 1
  fi

  if [ -z "${PRAQMA_HELM_REPO_NAME}" ]; then
    echo "REPO_NAME found empty. Exiting ..."
    exit 1
  fi

  if [ -z "${PRAQMA_S3_HELM_REPO_BUCKET_NAME}" ]; then
    echo "REPO_URL found empty. Exiting ..."
    exit 1
  fi
}

echo "performing sanity checks ..."
sanity_check

echo "initializing helm ..."
helm init --client-only

echo "creating repo URLs ..."
export PRAQMA_S3_HELM_REPO_URL="https://$PRAQMA_S3_HELM_REPO_BUCKET_NAME.s3.amazonaws.com/"

echo "adding helm repo ..."
helm repo add $PRAQMA_HELM_REPO_NAME $PRAQMA_S3_HELM_REPO_URL

echo "creating .charts & .generated directory ..."
mkdir -p .charts
mkdir -p .generated

echo "linting ..."
for d in */ ; do
    if [ "$d" != "docs/" ] && [ "$d" != "images/" ]; then
      echo "linting package $d"
      helm lint $d
      if [ $? -gt 0 ]; then
        echo "Package $d has errors ... Terminating!"
        exit 9
      fi
    fi
done

echo "validating generated chart templates ..."
for d in */ ; do
    if [ "$d" != "docs/" ] && [ "$d" != "images/" ]; then
      echo "validating templates of chart $d"
      if [ -e $d/requirements.yaml ]; then
        cd $d;
        helm dependency update;
        cd ..
      fi
      helm template $d --output-dir .generated
      kubeval --strict .generated/${d}/templates/*
      if [ $? -gt 0 ]; then
        echo "Chart $d has errors ... Terminating!"
        exit 9
      fi
    fi
done

echo "building ..."
for d in */ ; do
    if [ "$d" != "docs/" ] && [ "$d" != "images/" ]; then
      echo "building package $d"
      if [ -e $d/requirements.yaml ]; then
        cd $d;
        helm dependency update;
        cd ..
      fi
      helm package $d -d .charts
      if [ $? -gt 0 ]; then
        echo "Package $d has errors ... Terminating!"
        exit 9
      fi
    fi
done

function publish() {
  # pulling existing helm repo index.yaml to be merged with the new charts info.
  # Without this, old chart versions can become undiscoverable in the repo.
  aws s3 cp s3://$PRAQMA_S3_HELM_REPO_BUCKET_NAME/index.yaml oldIndex.yaml

  echo "generating index.yaml ..."
  helm repo index .charts --url $PRAQMA_S3_HELM_REPO_URL --merge oldIndex.yaml

  echo "pushing charts to $PRAQMA_HELM_REPO_NAME repo ..."

  # pushing charts to s3
  aws s3 cp .charts s3://$PRAQMA_S3_HELM_REPO_BUCKET_NAME/ --recursive
  if [ $? -gt 0 ]; then
      echo "Failed to push charts to S3 ... Terminating!"
      exit 9
  fi


  echo "updating repo ..."
  helm repo update

  echo "listing charts in $PRAQMA_HELM_REPO_NAME repo ..."
  helm search $PRAQMA_HELM_REPO_NAME
}

if [ $PUBLISH == true ]; then 
  publish
fi

