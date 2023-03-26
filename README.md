# No-IP Dynamic DNS Update Client in Kubernetes

This repository describes how to run no-ip DUC in Kubernetes.

> **Important note**: There are some issues when building image, you need to test before using this Dockerfile to build image.

> Note: This repository using no-ip DUC in beta version.

> Note: Traditional Chinese readme file will add in future.

## Build image

> Note: If you want to test image first, you can put `.env` file in `scripts` folder, container will read and set environment variables from the file.

> If running in production environment, put these sensitive data in secrets is recommanded.

Bulid image is easy when all necessary configurations are written in Dockerfile.
You can just run `docker build --tag <IMAGE_NAME> . --no-cache` to build image yourself.

## Deploy to Kubernetes

Before deploying to Kubernetes, you need to configure namespace and secrets for DUC pod.

### Create namespace

  > You can edit and use `prepare.yaml` to create namespace and secret in kubernetes folder directly.

  Create namespace by issue `kubectl create ns <NAMESPACE>` command or use the yaml content below.

  ```yaml
  # namespace.yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: <NAMESPACE_NAME>
  ```

### Create secrets

  > You can edit and use `prepare.yaml` to create namespace and secret in kubernetes folder directly.

  DUC needs your username, password and domain to run, so you need to create a secret to define these values for DUC.

  > Note: If you have multiple domains, split it in comma.

  ```yaml
  # duc-secrets.yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: <SECRET_NAME>
    namespace: <NAMESPACE_CREATED_ABOVE>
  type: Opaque
  data:
    username: <UERNAME_ON_NOIP>
    password: <PASSWWORD_ON_NOIP>
    domains: <DOMAIN_TO_SYNC>
  ```

### Edit deployment file

  deployment file is located in `kubernetes` folder. You need to edit some values in that file to match the right value.

  After you edited, issue `kubectl apply -f deployment.yaml` to deploy to Kubernetes.

## References

- [How to Install the Linux 3.x Dynamic Update Client (DUC)](https://www.noip.com/support/knowledgebase/install-linux-3-x-dynamic-update-client-duc/)
- [How to Install the No-IP Dynamic Update Client](https://www.linuxwebzone.com/how-to-install-the-no-ip-dynamic-update-client/)
- [Can I run a command WITHIN another command?](https://askubuntu.com/a/7407)
- [bash how to check if file exists](https://www.masteringunixshell.net/qa14/bash-how-to-check-if-file-exists.html)
- [Creating Environmental Variables](https://www.digitalocean.com/community/tutorials/how-to-read-and-set-environmental-and-shell-variables-on-linux#creating-environmental-variables)
- [Load environment variables from dotenv / .env file in Bash](https://gist.github.com/mihow/9c7f559807069a03e302605691f85572)
- [Set environment variables from file of key/value pairs](https://stackoverflow.com/a/20909045)
- [How to Set Environment Variables in Linux](https://builtin.com/software-engineering-perspectives/how-to-set-environment-variables-linux)
- [How to Read a File Line By Line in Bash](https://linuxize.com/post/how-to-read-a-file-line-by-line-in-bash/)
- [Change default shell](https://wiki.alpinelinux.org/wiki/Change_default_shell)
- [Pass args for script when going thru pipe](https://stackoverflow.com/a/53605439)
