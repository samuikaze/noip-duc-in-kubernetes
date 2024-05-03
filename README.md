# No-IP Dynamic DNS Update Client in Kubernetes

This repository will describe how to deploy No-IP DUC to Kubernetes.

> [!NOTE]
> This repository using beta version of No-IP DUC. The configuration of this version is incompatible with Version 2.x.

- [中文文檔](./docs/zh-TW.md)

## Table of contents

- [Building image](#building-image)
- [Deploy to Kubernetes](#deploy-to-kubernetes)
  - [Create namespace](#create-namespace)
  - [Create secrets](#create-secrets)
  - [Edit deployment file](#edit-deployment-file)
  - [Using GitHub Actions](#using-github-actions)
- [Update No-IP DUC client version](#update-no-ip-duc-client-version)
- [Update configurations](#update-configurations)
- [References](#references)

## Building image

> [!NOTE]
> If you want to test the image first, you can put `.env` file in `scripts` directory before you build the image, the startup script will read and set environment variables from the file.

> [!WARNING]
> It is recommanded to put these sensitive data in secret store such as Kubernetes secret if No-IP DUC runs in production environment.

Buliding image is easy while all necessary configurations are written in Dockerfile.
You can just issue `docker build --tag <IMAGE_NAME> . --no-cache` command to build image.

## Deploy to Kubernetes

Before deploying No-IP DUC to Kubernetes, you need to create namespace and secrets for No-IP DUC pod first.

### Create namespace

> You can simply edit and use `prepare.yaml` to create namespace and secret in `.kubernetes` directory.

Namespace can be created by issuing `kubectl create ns <NAMESPACE>` command or save the contents below as a yaml file and apply it with command `kubectl apply -f <YAML_FILE_NAME>`.

```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: <NAMESPACE_NAME>
```

### Create secrets

> You can simply edit and use `prepare.yaml` to create namespace and secret in `.kubernetes` directory.

To run No-IP DUC, you need to provide these required parameters lists below:

- username
- password
- domain name

You can create a secret to store these values.

> [!NOTE]
> If you have multiple domain names, split domain names with comma.

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

Deployment file is located in `.kubernetes` directory. You need to change values, which with uppercase alphabets and underscores, to the correct values in the file.

After it, issue `kubectl apply -f deployment.yaml` command to deploy No-IP DUC to Kubernetes.

### Using GitHub Actions

Before using GitHub Actions, you need to modify `production.yml` in `.github/workflows` directory first.

Find out all vars and secrets in the yaml file, and set these values under GitHub repository vars and secrets.
> `Vars` are start with `vars.` prefix, and `secrets` are start with `secret.` prefix.

And change all values with uppercase alphabets between `<` and `>` to correct value.

> Don't forget to uncomment at least one block on `on` block.

When these steps are finished, you can commit and push the repository to GitHub to start deployment flow.

## Update No-IP DUC client version

> [!NOTE]
> No-IP DUC version 2.x, which is known as stable version, is incompatible with 3.x configurations.

To update No-IP DUC client, simply follow these three steps below:

1. Change the download url in `Dockerfile` to a newer version.
2. Build the image.
3. Deploy to Kubernetes, that's all.

## Update configurations

To update the configurations, simply change the values in secrets and restart the pod, that's all.

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
