#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

if [ ! -d "node_modules" ]; then
  echo "正在安装依赖..."
  npm install
fi

echo "启动代理服务器..."
npm start
