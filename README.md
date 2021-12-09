# NOTICE OF DEPRECATION

If you are not yet aware. Atlassian now provides Helm charts and images for the running of their Data Center products on Kubernetes.

Therefore we will deprecate our implementation known as Atlassian Software in Kubernetes (ASK) as we believe that Atlassian is in the best position to provide a deployment model like this.

Please see Atlassian's documentation for running Data Center products on Kubernetes.

- [Documentation](https://atlassian.github.io/data-center-helm-charts/)
- [Github repo](https://github.com/atlassian/data-center-helm-charts)

This means we will no longer update or maintain ASK repositories nor push new images to Docker Hub. 

You are therefor encouraged to push any images you presently use to a registry of your choice and clone/fork this repository if needed.

Other repositories affected by this are:

- https://github.com/Praqma/jira - Jira docker image
- https://github.com/Praqma/confluence - Confluence docker image
- https://github.com/Praqma/bitbucket - Bitbucket docker image


# ASK Helm Repo [![CircleCI](https://circleci.com/gh/Praqma/ask/tree/master.svg?style=svg&circle-token=3b7cc9798969fc823042248e4a9f38b22a7abaa3)](https://circleci.com/gh/Praqma/ask/tree/master)

![ASK-Logo](images/ask-logo.png)

This repository is a component of **[ASK](https://www.praqma.com/products/ask/) Atlassian Software in Kubernetes**.
The charts are built with CircleCI and pushed into the public ASK helm repository.

These Helm charts relies on the Docker images found in these repositories :
- https://github.com/Praqma/jira
- https://github.com/Praqma/confluence
- https://github.com/Praqma/bitbucket

Helper repositories :
- https://github.com/Praqma/synchrony
- https://github.com/praqma/ask-elasticsearch


To configure the repository on your machine:
```
helm repo add ask https://praqma-helm-repo.s3.amazonaws.com/
helm repo update
helm search repo ask
```

Then, you can install charts from that repo:
```
helm install ask/jira
```

# Contribution

Contributions to the charts or the the docker images are welcome through PRs! Please refer to the [contribution guide](CONTRIBUTION.md) for more info. 

# Support
For support requests, please open an issue on this repo (and tag @hoeghh) or contact [info@praqma.com](mailto:info@praqma.com)
