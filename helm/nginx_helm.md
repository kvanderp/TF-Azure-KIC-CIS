# Nginx Helm install

## Setup

### Setup KIC Open-source

`helm repo add nginx-stable https://helm.nginx.com/stable`

`helm repo update`

`helm install my-release nginx-stable/nginx-ingress`

### Setup KIC Plus & NAP

`kubectl create secret docker-registry regcred --docker-server=<REPO_URL> --docker-username=<REPO_USERNAME> --docker-password=<REPO_PASSWORD`

```
helm install my-release nginx-stable/nginx-ingress \
--set controller.image.repository=<NGINX_PLUS_NAP_IMAGE_REPO> \
--set controller.nginxplus=true \
--set controller.image.tag=<VERSION_TAG> \
--set controller.appprotect.enable=true \
--set controller.enablePreviewPolicies=true \
--set controller.kind=daemonset \
--set controller.serviceAccount.imagePullSecretName=regcred \
--set controller.nginxStatus.allowCidrs=0.0.0.0/0
```

## Uninstall

`helm uninstall my-release`