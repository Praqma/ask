# Examples

## Commands

```shell
kubectl run multitool --image praqma/network-multitool

kubectl get deployments

kubectl delete deployment multitool
```

```shell
kubectl apply --filename examples/bitbucket-postgresql-pv.yaml

kubectl apply --filename examples/bitbucket-postgresql-pvc.yaml

helm install \
    --name bitbucket-postgresql stable/postgresql \
    --values examples/bitbucket-postgresql-values.yaml
```

```shell
helm package .

kubectl apply --filename examples/bitbucket-server-pv.yaml

helm install bitbucket-0.3.0.tgz \
    --name atlassian-bitbucket \
    --values examples/bitbucket-server-values.yaml

kubectl port-forward atlassian-bitbucket-0 7990:7990

helm upgrade atlassian-bitbucket bitbucket-0.3.0.tgz \
    --values examples/bitbucket-server-values.yaml
```

NB: if you receive the following error when running `helm package .`:

```shell
Error: found in requirements.yaml, but missing in charts/ directory: elasticsearch
```

Add the Praqma Helm Repo, see the `README.md` in the root of the repository, and run
```
helm dependency update
```


## Output

```text
helm install \
    --name bitbucket-postgresql stable/postgresql \
    --values examples/bitbucket-postgresql-values.yaml
NAME:   bitbucket-postgresql
LAST DEPLOYED: Thu Jun 28 21:53:24 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME                  TYPE    DATA  AGE
bitbucket-postgresql  Opaque  1     0s

==> v1/ConfigMap
NAME                  DATA  AGE
bitbucket-postgresql  0     0s

==> v1/Service
NAME                  TYPE       CLUSTER-IP   EXTERNAL-IP  PORT(S)            AGE
bitbucket-postgresql  ClusterIP  10.97.11.99  <none>       9187/TCP,5432/TCP  0s

==> v1beta1/Deployment
NAME                  DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
bitbucket-postgresql  1        1        1           0          0s

==> v1/Pod(related)
NAME                                   READY  STATUS             RESTARTS  AGE
bitbucket-postgresql-54f958c747-k7wsg  0/2    ContainerCreating  0         0s


NOTES:
PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:
bitbucket-postgresql.default.svc.cluster.local
To get your user password run:

    PGPASSWORD=$(kubectl get secret --namespace default bitbucket-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode; echo)

To connect to your database run the following command (using the env variable from above):

   kubectl run --namespace default bitbucket-postgresql-client --restart=Never --rm --tty -i --image postgres \
   --env "PGPASSWORD=$PGPASSWORD" \
   --command -- psql -U bitbucketuser \
   -h bitbucket-postgresql bitbucket



To connect to your database directly from outside the K8s cluster:
     PGHOST=127.0.0.1
     PGPORT=5432

     # Execute the following commands to route the connection:
     export POD_NAME=$(kubectl get pods --namespace default -l "app=postgresql,release=bitbucket-postgresql" -o jsonpath="{.items[0].metadata.name}")
     kubectl port-forward --namespace default $POD_NAME 5432:5432

```

```text
helm install bitbucket-0.3.0.tgz \
    --name atlassian-bitbucket \
    --values examples/bitbucket-server-values.yaml
2018/06/28 21:50:51 warning: destination for MatchLabels is a table. Ignoring non-table value <nil>
2018/06/28 21:50:51 warning: destination for MatchLabels is a table. Ignoring non-table value <nil>
2018/06/28 21:50:51 warning: destination for matchLabels is a table. Ignoring non-table value <nil>
2018/06/28 21:50:51 warning: destination for matchLabels is a table. Ignoring non-table value <nil>
2018/06/28 21:50:51 warning: destination for matchLabels is a table. Ignoring non-table value <nil>
NAME:   atlassian-bitbucket
LAST DEPLOYED: Thu Jun 28 21:50:51 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)                     AGE
atlassian-bitbucket  ClusterIP  10.105.195.222  <none>       7990/TCP,8888/TCP,7999/TCP  1s

==> v1beta1/StatefulSet
NAME                 DESIRED  CURRENT  AGE
atlassian-bitbucket  1        1        1s

==> v1beta1/Ingress
NAME                 HOSTS                  ADDRESS  PORTS  AGE
atlassian-bitbucket  bitbucket.example.com  80       1s

==> v1/Pod(related)
NAME                   READY  STATUS   RESTARTS  AGE
atlassian-bitbucket-0  0/1    Pending  0         1s


NOTES:
Bitbucket version: latest

1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "component=atlassian-bitbucket" -o jsonpath="{.items[0].metadata.name}")
  echo http://127.0.0.1:7990
  kubectl port-forward $POD_NAME 7990:7990

```

```text
kubectl logs atlassian-bitbucket-0
${BITBUCKET_HOME}: /var/atlassian/application-data/bitbucket
${BITBUCKET_INSTALL}: /opt/atlassian/bitbucket
...
${SSL_CERTS_PATH}: /var/atlassian/certificates/
${CERTIFICATE}:
${ENABLE_CERT_IMPORT}: true
The JAVA_KEYSTORE_PASSWORD is empty. Using the default value.
Use JAVA_KEYSTORE_PASSWORD as an ENV variable.
Importing certificate: /var/atlassian/certificates//eastwind.crt ...
Certificate was added to keystore
Importing certificate: /var/atlassian/certificates//localhost.crt ...
Certificate was added to keystore
Importing certificate: /var/atlassian/certificates//northwind.crt ...
Certificate was added to keystore
Importing certificate: /var/atlassian/certificates//southwind.pem ...
Certificate was added to keystore
Importing certificate: /var/atlassian/certificates//westwind.pem ...
Certificate was added to keystore
Imported certificates:
Alias name: southwind.pem
Alias name: northwind.crt
Alias name: westwind.pem
Alias name: eastwind.crt
Alias name: localhost.crt
${PLUGIN_IDS}: com.atlassian.upm.atlassian-universal-plugin-manager-plugin; com.atlassian.troubleshooting.plugin-bitbucket; ru.andreymarkelov.atlas.plugins.prom-bitbucket-exporter;
Searching for com.atlassian.upm.atlassian-universal-plugin-manager-plugin filename....
Please wait while plugins are being processed....
Downloading atlassian-universal-plugin-manager-plugin-2.22.11.jar....
Searching for com.atlassian.troubleshooting.plugin-bitbucket filename....
Downloading plugin-bitbucket-1.11.1.jar....
Searching for ru.andreymarkelov.atlas.plugins.prom-bitbucket-exporter filename....
Downloading prom-bitbucket-exporter-1.0.3.jar....
```
