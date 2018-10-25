# Example SAML config

Since dex is a backend app that can support multiple [connectors](https://github.com/dexidp/dex/tree/master/Documentation/connectors), we can modify the chart in order to use SAML as the connector without modyfing the chart itself.

## SAML configuration
In most SAML Identity Providers (IP) we need to create a metadata file, which registers our application in the IP. This file can be created manually, or by the use of a UI, however the effect should be similar to this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ns3:EntityDescriptor xmlns:ns3="urn:oasis:names:tc:SAML:2.0:metadata" xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:ns2="http://www.w3.org/2001/04/xmlenc#" xmlns:ns4="urn:oasis:names:tc:SAML:2.0:assertion" ID="Sc56b5abe-07ea-471b-ac77-a956f170769e" entityID="dex.k8s.example.org">
   <ns3:SPSSODescriptor AuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      <ns3:KeyDescriptor use="signing">
         <KeyInfo>
            <KeyName>dex.k8s.example.org</KeyName>
            <X509Data>
               <X509Certificate>IDENTITY_CERT</X509Certificate>
            </X509Data>
         </KeyInfo>
      </ns3:KeyDescriptor>
      <ns3:AssertionConsumerService index="0" isDefault="true" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dex.k8s.example.org/dex/callback" />
   </ns3:SPSSODescriptor>
</ns3:EntityDescriptor>

```

## Dex configuration
We only need to modify the connectors part of the configuration in order to change our backend:

```yaml
dex:
  config:
    connectors:
      - type: saml
        # Required field for connector id.
        id: APP_ID
        # Required field for connector name.
        name: APP_NAME
        config:
          # entityId taken from the metadata
          entityIssuer: dex.k8s.example.org
          # URL to the POST endpoint of the SSO provider
          ssoURL: YOUR_SSO_POST_ENDPOINT
          # Base64 of the same cert we used in the metadata
          caData: BASE64_IDENTITY_CERT
          # POST endpoint of DEX
          redirectURI: https://dex.k8s.example.org/dex/callback
          # Parameter mapping, similar to LDAP
          usernameAttr: name
          emailAttr: email
          groupsAttr: groups
          groupsDelim: ", "
          insecureSkipSignatureValidation: true
```
