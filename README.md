# Kubernetes - LDAP authentication with Dex

* [Docs](#docs)
* [Requirements](#requirements)
* [Login application](#login-application)
* [Dex](#dex)
  * [CRD](#crd)
  * [Deployment](#deployment)
* [Test](#test)

## Docs

This deployment follows Dex by CoreOS & Kubernetes Documentations:

* [Kubernetes OIDC Doc](https://kubernetes.io/docs/admin/authentication/#option-1---oidc-authenticator)
* [Dex by CoreOS](https://github.com/coreos/dex)
* [Login App](https://github.com/Flav35/loginapp)

## Requirements

* DNS entries:
  * **dex.k8s.example.com** --> Dex OIDC provider
  * **login.k8s.example.com** --> Custom Login Application

* Kubernetes cluster available with the following requirements:
  * RBAC enabled
  * OIDC authentication enabled. API server configuration:
    * **--oidc-issuer-url=https://dex.k8s.example.com/dex**: External Dex endpoint
    * **--oidc-client-id=loginapp**: ID for our Login Application
    * **--oidc-ca-file=/etc/kubernetes/ssl/letsencrypt.pem**: Letsencrypt CA file because we will use automatic certificate requests.
    * **--oidc-username-claim=name**: Map to **nameAttr** Dex configuration. This will be used by Kubernetes RBAC to authorize users based on their name.
    * **oidc-groups-claim=groups**: This will be used by Kubernetes RBAC to authorize users based on their groups.
  * Ingress Controller available.
  * Letsencrypt automatically request certificates for Kubernetes (ex: https://github.com/jetstack/kube-lego/)

* An available LDAP

## Login application

* Create auth namespace:

```shell
kubectl create ns auth
```

* Create resources:

```shell
# CA (letsencrypt) configmap
kubectl create -f ca-cm.yml
# Login App configuration
kubectl create -f loginapp-cm.yml
# Login App Ingress and SVC
kubectl create -f loginapp-ing-svc.yml
# Login App Deployment
kubectl create -f loginapp-deploy.yml
```

It should fail because Dex is not deployed.

## Dex

### CRD

We will use Kubernetes Custom Resource Definitions (https://kubernetes.io/docs/concepts/api-extension/custom-resources/) as Dex storage backend.

```shell
kubectl create -f dex-crd.yml
```

### Deployment

* Create Dex resources:

```shell
# Dex configuration
kubectl create -f dex-cm.yml
# Dex ingress and service
kubectl create -f dex-ing-svc.yml
# Dex deployment
kubectl create -f dex-deploy.yml
```

From now it should work, try https://login.k8s.example.org, login and retrieve k8s configuration.

```shell
kubectl --user=janedoe get po
Error from server (Forbidden): pods is forbidden: User "https://dex.k8s.example.org/dex#janedoe" cannot list pods in the namespace "auth"
```

User prefix can be updated with the **--oidc-username-prefix** apiserver option.

* Create RBAC resource:

```shell
kubectl create -f rbac-admins.yml
```

Try again:

```shell
kubectl --user=janedoe get po
NAME                        READY     STATUS    RESTARTS   AGE
dex-6f6568d499-m89z6        1/1       Running   0          7m
loginapp-6474748f4b-gb5kb   1/1       Running   0          8m
loginapp-6474748f4b-prq25   1/1       Running   0          8m
loginapp-6474748f4b-vnvnb   1/1       Running   0          8m
```
