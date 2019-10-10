# Contribution Guide

Contributions to the charts or the the docker images are welcome through PRs!

When making a PR, make sure:
- You describe what problem you are trying to solve and link to the issue it's solving if applicable.
- Describe what manual/automated tests have been applied to verify your PR.
- It would be great, if a helm test is added to test what your PR does. This makes it easier for the maintainers to verify your changes.
- Tag a maintainer as a reviewer in the PR to make sure they are notified about it.

## CI Build

When you submit a PR, CI will run helm lint and helm package on all the charts in the repo. This will fail when there are small syntax or yaml errors. 

Thanks for your interest in contributing to ASK!