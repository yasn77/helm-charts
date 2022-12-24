# cloudflared

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![AppVersion: 2022.12.1](https://img.shields.io/badge/AppVersion-2022.12.1-informational?style=flat-square)

Create Cloudflared Tunnels and configure ingress routes

_**This chart was taken and modifed from the awesome peeps at [Giant
Swarm](https://www.giantswarm.io/)**_

## What is this app?
This app allows you to launch [Cloudflare Tunnels](https://www.cloudflare.com/en-gb/products/tunnel/)
and then route directly to services inside of your cluster. This approach
bypasses any external ingress paths and can also be configured to bypass
Kubernetes Ingress.

## Configuring
This app can be used in 2 ways:

1) Use existing tunnels -> This is the recommended Cloudflare way of running Cloudflared Tunnels
2) App Managed -> The App manages to create and delete the tunnels for you

### 1) Use existing Tunnels

Create Cloudflared Tunnel(s) from an existing device (It is recommended to at least create two tunnels for resilience). You can run `cloudflared` command:

```bash
$ cloudflared tunnel create <NAME>
```
It creates the tunnel and generates the credentials file in the default cloudflared directory. Also, it creates a subdomain of .cfargotunnel.com.

__Note__: You can map your (sub)domain now to the tunnel one `<TUNNEL_ID>.cfargotunnel.com.`. More info in the [official guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide).

Once the tunnels are created, the credentials JSON file(s) can be found in `~/.cloudflared/`. These need to be saved in a Kubernetes secret:

```bash
kubectl create secret generic -n cloudflared-namespace cloudflared-credentials --from-file=credentials.json=~/.cloudflared/<TUNNEL_ID-1>.json
```

At the same time, it is required to set `useExistingTunnels.enabled` to true and complete the keys within `useExistingTunnels` (An example is presented [below](#use-existing-tunnels)).

### 2) App Managed Cloudflared Tunnels
In order to use this you will need to ensure you have the following:

- Email address to login to Cloudflare API
- Cloudflare Account ID
- Cloudflare API token with `Account:MyAccount Tunnel:Edit` capability

#### Optional

The Tunnel requires a secret to launch, if one is not supplied the App can
create one for you. But as this secret is essential for launching the tunnel it
must be saved securely to ensure that you can launch the tunnel elsewhere if
needed.

You can supply your own secret:

```bash
 uuidgen | base64 | kubectl create secret -n my-tunnel generic my-tunnel-secret --from-file=/dev/stdin
```

The tunnel secret needs to be 32 bytes or more and needs to be stored base64 encoded. You can later supply the Kubernetes secret name.

#### ⚠️ *WARNING* When using Cloudflared tunnels managed by the app, the tunnel will be deleted upon
removal of the app. A pre delete hook will be executed that cleans the tunnel connection and then deletes the tunnel.

**Homepage:** <https://github.com/yasn77/helm-charts>

## Source Code

* <https://github.com/yasn77/helm-charts/cloudflared>

## Requirements

Kubernetes: `>=1.18`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| accountEmail | string | `""` | Cloudflare Account Email |
| accountId | string | `""` | Clouflare Account ID to use |
| apiKey | string | `""` | Cloudflare API token (https://dash.cloudflare.com/profile/api-tokens) |
| apiKeySecretName | string | `""` | Provide a secret that contains the API token |
| config | object | `{"loglevel":"info","no-tls-verify":false,"transport-loglevel":"info"}` | Cloudflare config, this gets created in to a ConfigMap. Complete config is required. Default values should be fine |
| image.name | string | `"cloudflare/cloudflared"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"registry.hub.docker.com"` |  |
| image.tag | string | `""` |  |
| initImage.name | string | `"gitlab-ci-utils/curl-jq"` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.registry | string | `"registry.gitlab.com/gitlab-ci-utils/curl-jq"` |  |
| initImage.tag | string | `"1.1.0"` |  |
| namespace | string | `"kube-system"` |  |
| replicas | int | `2` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"100Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"100Mi"` |  |
| tunnelSecretBase64 | string | `""` | The tunnel secret to use (Base64 encoded) |
| tunnelSecretName | string | `""` | Provide a secret that contains the Tunnel secret |
| useExistingTunnel | object | `{"credentialsSecretName":"","enabled":false,"tunnel":""}` | Whether to use an existing tunnel or create new one |
| usePsp | bool | `false` |  |
| useQuickTunnel | bool | `false` | Use Cloudflare quick tunnel feature (https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/do-more-with-tunnels/trycloudflare/) |

### Examples

#### App Managed Tunnels

```
# values.yaml
accountEmail: "xxxx@xxxxx.com"
accountId: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
tunnelSecretBase64: "ZUY0xjNhZTgtNWI4MCx0ZjcvLTkxMOEt4zEyOWQyZDQpN8Y0Cg=="

config:
  no-tls-verify: false
  loglevel: "info"
  transport-loglevel: "info"
  ingress:
    - hostname: echo.xxxxxx.com
      service: http://echo-echo-server.default.svc.cluster.local
    - service: http_status:404

```

#### Use existing Tunnels
```
useExistingTunnels:
  enabled: true
  credentialsSecretName: my-tunnel-credentials
  tunnel: "f8c06a8a-1880-4e6e-8502-deb8f1d1253b"

config:
  no-tls-verify: false
  loglevel: "info"
  transport-loglevel: "info"
  ingress:
    - hostname: echo.xxxxxxxxxx.com
      service: http://echo-echo-server.default.svc.cluster.local
    - service: http_status:404
```

## Testing

Cloudflare offers the possibility of setting [Quick Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/do-more-with-tunnels/trycloudflare/) up for testing purposes.
Quick Tunnels do not require registration or credentials and they offer a random URL under the `trycloudflare.com` domain. The URL is provided by the cloudflared application in its logs.

### Quick Tunnel example

```
useQuickTunnel: true

config:
  ingress:
    - service: http://echo-echo-server.default.svc.cluster.local
```

## Credit

* https://github.com/giantswarm/cloudflared-app
