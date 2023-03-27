# No-IP Dynamic DNS Update Client in Kubernetes

This repository describes how to run No-IP DUC in Kubernetes.

> Note: This repository using No-IP DUC in beta version. It is incompatible with Version 2.x.

* [中文文檔](./docs/zh-TW.md)

## Build image

> Note: If you want to test image first, you can put `.env` file in `scripts` folder before you build the image, container will read and set environment variables from the file.

> If it runs in production environment, put these sensitive data in secrets is recommanded.

Bulid image is easy when all necessary configurations are written in Dockerfile.
You can just run `docker build --tag <IMAGE_NAME> . --no-cache` to build image yourself.

## Deploy to Kubernetes

Before deploying to Kubernetes, you need to configure namespace and secrets for No-IP DUC pod.

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

  No-IP DUC needs your username, password and domain to run, so you need to create a secret to define these values for No-IP DUC.

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

  Deployment file is located in `.kubernetes` folder. You need to edit some values in that file to match the right value.

  After you edited, issue `kubectl apply -f deployment.yaml` to deploy to Kubernetes.

### Using GitHub Actions

  Before you use GitHub Actions to deploy your No-IP DUC, you need to edit `production.yml` in `.github/workflows` folder first.
  Set all secrets and vars which declares in yaml file into repository secrets and vars on GitHub.
  And change all values with upper case alphabets between `<` and `>` to correct value.

  > Don't forget to uncomment at least one block on `on` block.

  When these are finished, you can do git commit and git push to run deployment.

## Update No-IP DUC client version

  > Note: No-IP DUC version 2.x, which is known as stable version, is incompatible with 3.x configurations.

  To update No-IP DUC client, you just need to do below three steps:

  1. Change the download url in `Dockerfile` to newer version.
  2. Build the image.
  3. Deploy to Kubernetes and done.

## Update configurations

  To update configurations, just edit secrets and restart the pod.

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
- [How To Set Environment Variable in Bash](https://devconnected.com/set-environment-variable-bash-how-to/)
- [How do I delete an exported environment variable?](https://stackoverflow.com/a/6877747)
