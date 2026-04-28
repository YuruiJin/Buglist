#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   GITHUB_TOKEN=xxx ./scripts/create_yuruijin_coursework_repo.sh
# Optional env vars:
#   OWNER (default: yuruijin)
#   REPO_NAME (default: coursework-master)
#   PRIVATE (default: true)
#   DESCRIPTION (default: 硕士阶段 coursework 资料仓库)

OWNER="${OWNER:-yuruijin}"
REPO_NAME="${REPO_NAME:-coursework-master}"
PRIVATE="${PRIVATE:-true}"
DESCRIPTION="${DESCRIPTION:-硕士阶段 coursework 资料仓库}"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "[ERROR] 请先设置 GITHUB_TOKEN 环境变量（需要有创建仓库权限）。" >&2
  exit 1
fi

API_URL="https://api.github.com/user/repos"

payload=$(cat <<JSON
{
  "name": "${REPO_NAME}",
  "description": "${DESCRIPTION}",
  "private": ${PRIVATE},
  "auto_init": true,
  "gitignore_template": "Python",
  "license_template": "mit"
}
JSON
)

response=$(curl -sS -X POST "${API_URL}" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "${payload}")

if echo "${response}" | rg -q '"full_name"'; then
  full_name=$(echo "${response}" | sed -n 's/.*"full_name": "\([^"]*\)".*/\1/p' | head -n1)
  html_url=$(echo "${response}" | sed -n 's/.*"html_url": "\([^"]*\)".*/\1/p' | head -n1)
  echo "[OK] 仓库创建成功: ${full_name}"
  echo "[URL] ${html_url}"
else
  echo "[ERROR] 仓库创建失败，GitHub 返回："
  echo "${response}"
  exit 1
fi

if [[ "${OWNER}" != "$(echo "${full_name}" | cut -d/ -f1)" ]]; then
  echo "[WARN] 当前 token 对应账号不是 ${OWNER}，实际创建在：${full_name}" >&2
fi
