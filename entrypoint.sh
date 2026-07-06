#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Initialize openclaw configuration
mkdir -p /data/.openclaw/workspace /data/.openclaw/devices /data/workspace
echo '{"gateway":{"controlUi":{"allowInsecureAuth":true},"auth":{"mode":"password","password":"H310608s","token":"H310608s"},"trustedProxies":["100.64.0.0/10","149.102.242.105"]},"agents":{"defaults":{"model":{"primary":"qwen-plus"}}},"models":{"mode":"merge","providers":{"modelstudio":{"api":"openai-completions","apiKey":"sk-e4f30418484a487aa98b93e354bd8b39","baseUrl":"https://dashscope-intl.aliyuncs.com/compatible-mode/v1","models":[{"id":"qwen-plus","name":"Qwen Plus","reasoning":false,"input":["text"],"contextWindow":262144,"maxTokens":32000}]}}}}' > /data/.openclaw/openclaw.json
chmod -R 777 /data/.openclaw
ln -sf /data/.openclaw /root/.openclaw

exec gosu openclaw node src/server.js
