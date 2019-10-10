# Chart version 1.0.0
- The default K8S API version used for statefulsets and deployments is now `apps/v1` to support K8S 1.16 and above.
- Upgrading from previous chart versions could fail because of the API version difference. You will have to use the `kubectl convert` command as described [here](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/)  
- This chart version works with K8S >1.9 out of the box. To use it with older versions, set `apiVersion` to `apps/v1beta2` in the values file.