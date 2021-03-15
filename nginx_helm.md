# Nginx Helm install

## Setup

### Setup KIC Open-source

`helm repo add nginx-stable https://helm.nginx.com/stable`

`helm install my-release nginx-stable/nginx-ingress`

### Setup KIC Plus

`kubectl create secret docker-registry regcred --docker-server=<REPO_URL> --docker-username=<REPO_USERNAME> --docker-password=<REPO_PASSWORD`

```
helm install my-release nginx-stable/nginx-ingress \
--set controller.image.repository=<NGINX_PLUS_IMAGE_REPO> \
--set controller.nginxplus=true \
--set controller.kind=daemonset \
--set controller.serviceAccount.imagePullSecretName=regcred \
--set controller.nginxStatus.allowCidrs=0.0.0.0/0
```

### Setup KIC Plus & NAP

## Update

## Uninstall