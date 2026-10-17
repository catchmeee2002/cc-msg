#!/usr/bin/env bash
# 移除 install.sh 建立的软链，不删除仓库文件。
set -euo pipefail
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.codex/skills}"

rm -f "$BIN_DIR/cc-msg"
[ -L "$SKILLS_DIR/cc-msg" ] && rm -f "$SKILLS_DIR/cc-msg"
echo "removed cc-msg links"
