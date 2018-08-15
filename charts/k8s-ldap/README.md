# K8S LDAP

Not only LDAP :)

This chart deploys:
* Dex as IdP
* loginapp as CLI login application (generate kubeconfig template)
* keycloak proxy as Dashboard login

## Install

This chart is not yet managed by a helm repository. You must clone and install it from
local directory.

```
helm install ./k8s-ldap
```

## Configure

You can check full configuration options on values.yaml.

### Cross client configuration for k8s

A Kubernetes cluster currently allows to setup only one IdP in the configuration.

You will have to configure cross-client trust for loginapp and keycloack proxy.

Full explaination about cross-client trust can be found [here](https://github.com/coreos/dex/blob/master/Documentation/custom-scopes-claims-clients.md#cross-client-trust-and-authorized-party)

The configuration begins on Dex:
```
staticClients:
    - id: cli
      redirectURIs:
      - 'https://logincli.example.org/callback/cli'
      name: 'Login Application'
      secret: SeCrEtKeyCLI
    - id: login
      redirectURIs:
      - 'https://dashboard.example.org/oauth/callback'
      name: 'Dashboard Application'
      secret: SeCrEtKeyDashboard
      trustedPeers:
      - cli
```

Then you must configure Loginapp to use cross-client:
```
name: "Kubernetes Auth"
listen: "0.0.0.0:8080"
oidc:
  client:
    id: "cli"
    secret: SeCrEtKeyCLI
    redirect_url: "https://logincli.example.org/callback"
  issuer:
    root_ca: "/etc/ssl/ca.pem"
    url: "https://dex.example.org/dex"
  extra_scopes:
    - groups
  offline_as_scope: true
  cross_clients:
  - login
tls:
  enabled: false
log:
  level: Info
  format: json
```

*cross_client: [login]* is the important field.
