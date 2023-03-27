# No-IP Dynamic DNS Update Client in Kubernetes

這儲存庫將會說明如何在 Kubernetes 上執行 No-IP Dynamic DNS Update Client (下簡稱 NoIP DUC 或 DUC)

> 備註: 此專案使用測試版本的 No-IP DUC，這些設定方式並不適用於 2.x 版本

## 建置 image

  > 注意: 如果你想先測試映像檔是否能正常運作，你可以在建置 image 前將 `.env` 檔案放置於 `scripts` 資料夾中, 執行時容器就會讀取這個檔案的內容當作環境變數去執行 No-IP DUC

  > 如果是執行在正式環境上，建議使用 Secrets 儲存這些敏感資訊，並將之設給 Pod 的環境變數，而不是使用 .env 檔的方式，可以參考部署區塊的說明

  建置映像檔非常簡單，所有的建置邏輯都寫好在 Dockerfile 內了，你只需要執行 `docker build --tag <IMAGE_NAME> . --no-cache` 指令就可以將映像檔建置起來

  > 記得將 `<IMAGE_NAME>` 取代為你希望的映像檔名稱

## 部署到 Kubernetes

  在部署前，你需要先針對 namespace 和 secrets 進行設定

### 建立命名空間 (namespace)

  > 你可以直接編輯並使用 `.kubernetes/prepare.yaml` 以建立命名空間與 secret

  執行指令 `kubectl create ns <NAMESPACE>` 或使用以下的 yaml 內容建立

  ```yaml
  # namespace.yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: <NAMESPACE_NAME>
  ```

### 建立 secrets

  > 你可以直接編輯並使用 `.kubernetes/prepare.yaml` 以建立命名空間與 secret

  No-IP DUC 需要提供帳號、密碼與欲同步的網域才能執行，所以你需要將這些設定寫到 secrets 中

  > 備註: 若你有多個網域要同步，用半形逗號隔開

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

### 編輯部署檔案

  部署檔案放在 `.kubernetes` 資料夾下，你需要先修改部分設定值後才能正常部署

  編輯完後執行 `kubectl apply -f deployment.yaml` 指令進行部署

### 使用 GitHub Actions

  在使用 GitHub Actions 前，你需要先修改 `.github/workflows/production.yml` 檔案內容，將部分以 `<` 和 `>` 包起來的大寫文字取代為正確的值
  再到 GitHub 專案設定中把相關的 secrets 設到儲存庫秘密 (repository secrets) 中

  > `on` 區塊至少要有一個區塊被解除註解，否則 GitHub Actions 再推送 commit 後會直接拋錯

  當全部完成後確認無問題，就可以將這些變更進行 git commit 和 git push 執行版控和部署了

## 更新 No-IP DUC 客戶端版本

  > 注意: NoIP DUC 的穩定版本 2.x 與 3.x 的設定方式不同，兩邊無法相容

  更新 No-IP DUC 客戶端版本你只需要進行以下修改:

  1. 變更 `Dockerfile` 中的下載網址為新版網址
  2. 重新建置映像
  3. 重新部署到 Kubernetes

## 更新設定

  更新設定非常簡單，編輯 secrets 後重新啟動 Pod 就可以了

## 參考資料

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
