---
name: cc-msg
description: 从 Codex 向运行中的 Claude Code 会话发送消息时使用。用户提到给 CC / Claude Code 发消息、让两个 agent 协作、等待 CC 结果时触发。
---

# Codex -> Claude Code 跨会话通信

## 列目标

```bash
cc-msg list
```

用 pid 或完整会话名指定目标。

## 取自己的 thread id

```bash
tail -5 ~/.codex/session_index.jsonl
```

最新一条的 `id` 为 thread UUID，`thread_name` 为名称。

## 发送

```bash
cc-msg send <pid|会话名> --from "codex:<thread_name>" --reply-to "<thread UUID>" "消息"
echo "多行消息" | cc-msg send <目标> --from ... --reply-to ... -
```

## 接收 CC 回复

CC 执行 `codex queue --thread <thread UUID> --message "..."` 后，消息进入当前会话队列。

## 约束

- 发送前确认目标会话；消息等同用户本人输入。
- 目标 `waitingFor=dialog open` 时消息排队，不立即处理。
- 目标不存在或已退出时命令返回非 0。
