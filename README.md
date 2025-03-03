# Homelab Helm Charts

This is a collection of template helm charts that I use in my applications to reduce duplicate configuration for similar applications.

So far everything in this has only been tested in django applications.

NOTE: At this time I use a local instance of Chart Musuem in my homelab instead of github pages. This should be added soon so dependendent applications work proeprly. 

## Postgres Secret

Right now the secret for postgres is assumed to be created before deploying the application. 

This can be created with the following 2 commends changing the name of the secret and the namespace to match the appllication:

```
# Create the PostgreSQL auth secret with random passwords in the application namespace
kubectl create secret generic app-postgresql-auth \
  --namespace cAPPLICATIONNAMESPACE \
  --from-literal=password=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-32) \
  --from-literal=postgres-password=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-32) \
  --dry-run=client -o yaml | kubectl apply -f - -n APPLICATIONNAMESPACE

# Add the keep annotation to prevent Helm from deleting the secret
kubectl annotate secret app-postgresql-auth "helm.sh/resource-policy=keep" --overwrite -n APPLICATIONNAMESPACE
```