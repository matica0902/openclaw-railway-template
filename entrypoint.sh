#!/bin/bash
set -e

export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}"
export OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/data/workspace}"
export OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-${OPENCLAW_STATE_DIR}/openclaw.json}"

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Initialize openclaw configuration
mkdir -p "${OPENCLAW_STATE_DIR}/workspace" "${OPENCLAW_STATE_DIR}/devices" "${OPENCLAW_WORKSPACE_DIR}"
if [ ! -f "${OPENCLAW_CONFIG_PATH}" ]; then
  echo '{"gateway":{"controlUi":{"allowInsecureAuth":true},"auth":{"mode":"password","password":"H310608s","token":"H310608s"},"trustedProxies":["100.64.0.0/10","149.102.242.105"]},"agents":{"defaults":{"model":{"primary":"qwen-plus"}}},"models":{"mode":"merge","providers":{"modelstudio":{"api":"openai-completions","apiKey":"sk-e4f30418484a487aa98b93e354bd8b39","baseUrl":"https://dashscope-intl.aliyuncs.com/compatible-mode/v1","models":[{"id":"qwen-plus","name":"Qwen Plus","reasoning":false,"input":["text"],"contextWindow":262144,"maxTokens":32000}]}}}}' > "${OPENCLAW_CONFIG_PATH}"
fi
chown -R openclaw:openclaw "${OPENCLAW_STATE_DIR}" "${OPENCLAW_WORKSPACE_DIR}"
chmod -R u+rwX,g-rwx,o-rwx "${OPENCLAW_STATE_DIR}" "${OPENCLAW_WORKSPACE_DIR}"
ln -sfn "${OPENCLAW_STATE_DIR}" /root/.openclaw

exec gosu openclaw node src/server.js
