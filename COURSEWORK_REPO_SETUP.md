# 在 yuruijin 账号下创建硕士 coursework 仓库

我已经在仓库里准备好一键脚本：

- `scripts/create_yuruijin_coursework_repo.sh`

## 1) 准备 GitHub Token

在 GitHub `Settings -> Developer settings -> Personal access tokens` 创建 token，至少勾选：

- `repo`（创建私有仓库需要）

## 2) 执行一键创建

```bash
GITHUB_TOKEN=你的token ./scripts/create_yuruijin_coursework_repo.sh
```

默认会创建：

- Owner: `yuruijin`
- Repo: `coursework-master`
- Visibility: `private`
- 初始化内容：README、MIT License、Python `.gitignore`

## 3) 可选自定义

```bash
GITHUB_TOKEN=你的token \
OWNER=yuruijin \
REPO_NAME=coursework \
PRIVATE=true \
DESCRIPTION='硕士阶段 coursework 资料仓库' \
./scripts/create_yuruijin_coursework_repo.sh
```

## 4) 推送本地课程资料（示例）

```bash
git clone git@github.com:yuruijin/coursework-master.git
cd coursework-master
mkdir -p semester1/course1
# 放入资料后提交
git add .
git commit -m "init coursework structure"
git push origin main
```
