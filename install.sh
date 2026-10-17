#!/usr/bin/env bash
# 建立 cc-msg 命令与 Codex skill 的软链。幂等。
set -euo pipefail
REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.codex/skills}"

mkdir -p "$BIN_DIR" "$SKILLS_DIR"
ln -sfn "$REPO/cc-msg" "$BIN_DIR/cc-msg"
ln -sfn "$REPO/skills/cc-msg" "$SKILLS_DIR/cc-msg"

chmod +x "$REPO/cc-msg"
echo "linked: $BIN_DIR/cc-msg -> $REPO/cc-msg"
echo "linked: $SKILLS_DIR/cc-msg -> $REPO/skills/cc-msg"
