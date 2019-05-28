# Examples

## Commands

```shell
kubectl run multitool --image praqma/network-multitool

kubectl get deployments

kubectl delete deployment multitool
```

```shell
kubectl apply --filename examples/jira-postgresql-pv.yaml

kubectl apply --filename examples/jira-postgresql-pvc.yaml

helm install \
    --name jira-postgresql stable/postgresql \
    --values examples/jira-postgresql-values.yaml
```

```shell
helm package .

kubectl apply --filename examples/jira-server-pv.yaml

helm install jira-0.4.0.tgz \
    --name atlassian-jira \
    --values examples/jira-server-values.yaml

kubectl port-forward atlassian-jira-0 8080:8080

helm upgrade atlassian-jira jira-0.4.0.tgz \
    --values examples/jira-server-values.yaml
```

## Output

```text
helm install \
    --name jira-postgresql stable/postgresql \
    --values examples/jira-postgresql-values.yaml
NAME:   jira-postgresql
LAST DEPLOYED: Fri Jun 29 00:41:17 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME             TYPE    DATA  AGE
jira-postgresql  Opaque  1     0s

==> v1/ConfigMap
NAME             DATA  AGE
jira-postgresql  0     0s

==> v1/Service
NAME             TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)            AGE
jira-postgresql  ClusterIP  10.109.162.170  <none>       9187/TCP,5432/TCP  0s

==> v1beta1/Deployment
NAME             DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
jira-postgresql  1        1        1           0          0s

==> v1/Pod(related)
NAME                              READY  STATUS             RESTARTS  AGE
jira-postgresql-675ffc98fc-xj9vd  0/2    ContainerCreating  0         0s


NOTES:
PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:
jira-postgresql.default.svc.cluster.local
To get your user password run:

    PGPASSWORD=$(kubectl get secret --namespace default jira-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode; echo)

To connect to your database run the following command (using the env variable from above):

   kubectl run --namespace default jira-postgresql-client --restart=Never --rm --tty -i --image postgres \
   --env "PGPASSWORD=$PGPASSWORD" \
   --command -- psql -U jirauser \
   -h jira-postgresql jira



To connect to your database directly from outside the K8s cluster:
     PGHOST=127.0.0.1
     PGPORT=5432

     # Execute the following commands to route the connection:
     export POD_NAME=$(kubectl get pods --namespace default -l "app=postgresql,release=jira-postgresql" -o jsonpath="{.items[0].metadata.name}")
     kubectl port-forward --namespace default $POD_NAME 5432:5432

```

```text
helm install jira-0.4.0.tgz \
    --name atlassian-jira \
    --values examples/jira-server-values.yaml
NAME:   atlassian-jira
LAST DEPLOYED: Fri Jun 29 00:41:55 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ServiceAccount
NAME  SECRETS  AGE
jira  1        0s

==> v1beta1/ClusterRole
NAME  AGE
jira  0s

==> v1beta1/ClusterRoleBinding
NAME  AGE
jira  0s

==> v1/Service
NAME            TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)            AGE
atlassian-jira  ClusterIP  10.107.169.206  <none>       8080/TCP,8888/TCP  0s

==> v1beta1/StatefulSet
NAME            DESIRED  CURRENT  AGE
atlassian-jira  1        1        0s

==> v1beta1/Ingress
NAME            HOSTS             ADDRESS  PORTS  AGE
atlassian-jira  jira.example.com  80       0s

==> v1/Pod(related)
NAME              READY  STATUS   RESTARTS  AGE
atlassian-jira-0  0/1    Pending  0         0s


NOTES:
Jira version: latest

1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "component=atlassian-jira" -o jsonpath="{.items[0].metadata.name}")
  echo http://127.0.0.1:8080
  kubectl port-forward $POD_NAME 8080:8080

2. You can see the Postgres DB custom job outcome by typing:
   export POD_NAME=$(kubectl get pods --namespace default -a | grep atlassian-jira-postgres-setup- | awk '{print $1}')
   kubectl get logs $POD_NAME

```

```text
ubectl logs atlassian-jira-0
${JIRA_HOME}: /var/atlassian/application-data/jira
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
${PLUGIN_IDS}: com.atlassian.upm.atlassian-universal-plugin-manager-plugin; com.atlassian.troubleshooting.plugin-jira; ru.andreymarkelov.atlas.plugins.prom-jira-exporter;
Please wait while plugins are being processed....
Searching for com.atlassian.upm.atlassian-universal-plugin-manager-plugin filename....
Downloading atlassian-universal-plugin-manager-plugin-2.22.11.jar....
Searching for com.atlassian.troubleshooting.plugin-jira filename....
Downloading plugin-jira-1.11.1.jar....
Searching for ru.andreymarkelov.atlas.plugins.prom-jira-exporter filename....
Downloading prom-jira-exporter-1.0.18.jar....
```
