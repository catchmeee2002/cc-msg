# cc-msg

从命令行向运行中的 Claude Code 会话投递消息，用于 Codex 与 Claude Code 前台会话之间的双向协作。

## 原理

Claude Code 每个运行中进程会暴露一个 Unix socket 收件箱：

- 会话元数据：`~/.claude/sessions/<pid>.json`，包含 `sessionId`、`name`、`messagingSocketPath`、`status`。
- peer 认证：`~/.claude/sessions/<pid>.<hash>.key` 内的 `peerToken`。
- 协议：换行分隔 JSON。首行认证，随后是 user 消息：

```
{"type":"auth","token":"<peerToken>"}
{"type":"user","message":{"role":"user","content":"消息"}}
```

消息进入目标会话的输入队列，与用户手动输入等价。

## 安装

```bash
./install.sh
```

默认建立两个软链：

- `~/.local/bin/cc-msg` → 仓库内的 `cc-msg`
- `~/.codex/skills/cc-msg` → 仓库内的 `skills/cc-msg`

可用 `BIN_DIR` / `SKILLS_DIR` 覆盖目标目录。卸载执行 `./uninstall.sh`。

## 用法

```bash
cc-msg list                                  # 列出运行中的 CC 会话
cc-msg send <pid|名称|session-id> "消息"      # 投递
echo "多行消息" | cc-msg send <目标> -        # 从 stdin 读
```

带来源标识，便于接收方回投：

```bash
cc-msg send root-ae \
  --from "codex:my-thread" \
  --reply-to "<codex-thread-uuid>" \
  "消息"
```

接收方会看到：

```
[跨会话消息 | 发送方: codex:my-thread | 回复: codex queue --thread <uuid> --message "..."]
```

除了 CC → CC、Codex → CC，任何能执行 shell 的进程都可以投递。

## 限制

- 协议为 Claude Code 未公开的实现，升级后 socket/key 格式可能变化；失败时命令返回非 0。
- 消息等同用户本人输入，目标会话按自身权限设置执行。
- 目标会话有对话框未关闭（`waitingFor=dialog open`）时，消息排队等待。
- 消息包装不含发送方身份，回投依赖消息正文里的回复地址。
- 目标会话运行在 `bypassPermissions`（含 `plan` + bypass 可用）时，Claude Code 的跨会话入站门控会挂起未声明权限等级的投递：消息不报错、也不入队，只在目标会话里显示一条 `Held peer message … The sender did not attest its permission mode`，等用户批准或超时作废。跨用户不受影响，这是接收方权限模式决定的。
  - 放行：在接收方 `~/.claude/settings.json` 顶层设 `"crossSessionInbound": "accept"`，消息直接入队。显式值优先于模式对等；项目/本地设置只能收紧，managed 最高。
  - 接收方为 `auto` 等提示型模式（`prompting`）时不做此拦截。
  - 发送方声明了权限等级但与接收方类别不一致时，同样挂起（`mode-mismatch`），因此不要随手补 `from-mode`。
- 接收方显示「来源不明 / unidentified session」是缺少 `from` 字段的显示层默认值，与是否放行无关。

## License

MIT
