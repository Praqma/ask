# Examples

## Commands

```shell
kubectl run multitool --image praqma/network-multitool

kubectl get deployments

kubectl delete deployment multitool
```

```shell
kubectl apply --filename examples/confluence-postgresql-pv.yaml

kubectl apply --filename examples/confluence-postgresql-pvc.yaml

helm install \
    --name confluence-postgresql stable/postgresql \
    --values examples/confluence-postgresql-values.yaml
```

```shell
helm package .

kubectl apply --filename examples/confluence-server-pv.yaml

helm install confluence-0.4.0.tgz \
    --name atlassian-confluence \
    --values examples/confluence-server-values.yaml

kubectl port-forward atlassian-confluence-0 8090:8090

helm upgrade atlassian-confluence confluence-0.4.0.tgz \
    --values examples/confluence-server-values.yaml
```

## Output

```text
helm install \
    --name confluence-postgresql stable/postgresql \
    --values examples/confluence-postgresql-values.yaml
NAME:   confluence-postgresql
LAST DEPLOYED: Thu Jun 28 23:12:23 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME                   TYPE    DATA  AGE
confluence-postgresql  Opaque  1     1s

==> v1/ConfigMap
NAME                   DATA  AGE
confluence-postgresql  0     1s

==> v1/Service
NAME                   TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)            AGE
confluence-postgresql  ClusterIP  10.107.207.161  <none>       9187/TCP,5432/TCP  1s

==> v1beta1/Deployment
NAME                   DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
confluence-postgresql  1        1        1           0          1s

==> v1/Pod(related)
NAME                                    READY  STATUS             RESTARTS  AGE
confluence-postgresql-7c97f9f8c7-dppwd  0/2    ContainerCreating  0         1s


NOTES:
PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:
confluence-postgresql.default.svc.cluster.local
To get your user password run:

    PGPASSWORD=$(kubectl get secret --namespace default confluence-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode; echo)

To connect to your database run the following command (using the env variable from above):

   kubectl run --namespace default confluence-postgresql-client --restart=Never --rm --tty -i --image postgres \
   --env "PGPASSWORD=$PGPASSWORD" \
   --command -- psql -U confluenceuser \
   -h confluence-postgresql confluence



To connect to your database directly from outside the K8s cluster:
     PGHOST=127.0.0.1
     PGPORT=5432

     # Execute the following commands to route the connection:
     export POD_NAME=$(kubectl get pods --namespace default -l "app=postgresql,release=confluence-postgresql" -o jsonpath="{.items[0].metadata.name}")
     kubectl port-forward --namespace default $POD_NAME 5432:5432

```

```text
helm install confluence-0.4.0.tgz \
    --name atlassian-confluence \
    --values examples/confluence-server-values.yaml
NAME:   atlassian-confluence
LAST DEPLOYED: Thu Jun 28 23:13:33 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME                  TYPE       CLUSTER-IP    EXTERNAL-IP  PORT(S)            AGE
atlassian-confluence  ClusterIP  10.108.17.37  <none>       8090/TCP,8888/TCP  0s

==> v1beta1/StatefulSet
NAME                  DESIRED  CURRENT  AGE
atlassian-confluence  1        1        0s

==> v1beta1/Ingress
NAME                  HOSTS                   ADDRESS  PORTS  AGE
atlassian-confluence  confluence.example.com  80       0s

==> v1/Pod(related)
NAME                    READY  STATUS   RESTARTS  AGE
atlassian-confluence-0  0/1    Pending  0         0s

==> v1/ServiceAccount
NAME        SECRETS  AGE
confluence  1        0s

==> v1beta1/ClusterRole
NAME        AGE
confluence  0s

==> v1beta1/ClusterRoleBinding
NAME        AGE
confluence  0s


NOTES:
Confluence version: latest

1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "component=atlassian-confluence" -o jsonpath="{.items[0].metadata.name}")
  echo http://127.0.0.1:8090
  kubectl port-forward $POD_NAME 8090:8090

```

```text
kubectl logs atlassian-confluence-0
${CONFLUENCE_HOME}: /var/atlassian/application-data/confluence
${CONFLUENCE_INSTALL}: /opt/atlassian/confluence
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
Please wait while plugins are being processed....
${PLUGIN_IDS}: com.atlassian.upm.atlassian-universal-plugin-manager-plugin; com.atlassian.troubleshooting.plugin-confluence; ru.andreymarkelov.atlas.plugins.prom-confluence-exporter;
Searching for com.atlassian.upm.atlassian-universal-plugin-manager-plugin filename....
Downloading atlassian-universal-plugin-manager-plugin-2.22.11.jar....
Searching for com.atlassian.troubleshooting.plugin-confluence filename....
Downloading plugin-confluence-1.11.1.jar....
Searching for ru.andreymarkelov.atlas.plugins.prom-confluence-exporter filename....
Downloading prom-confluence-exporter-1.0.12.jar....
```
