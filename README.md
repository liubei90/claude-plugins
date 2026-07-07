# cc-plugins

自用 Claude Code 插件合集市场。

## 安装

```bash
claude plugin install git+ssh://git@git.software.dimpt.com/liubei/cc-plugins.git
```

或手动链接：

```bash
git clone <repo-url> ~/.claude-plugins/cc-plugins
# 在项目中使用
claude plugin add ~/.claude-plugins/cc-plugins
```

## Skills

| Skill | 触发条件 | 说明 |
|-------|---------|------|
| [code-archaeologist](skills/code-archaeologist/) | 分析仓库历史、分支策略、CI/CD、开发流程 | 6 大分析模块，零依赖 |
| [react-modal](skills/react-modal/) | 编写 React + antd 编辑弹窗 | 模板代码生成 |
| [send-email](skills/send-email/) | 发送邮件、通知、报告 | SMTP，支持多邮箱配置 |
| [yapi-fetch](skills/yapi-fetch/) | 查询 YApi 接口文档 | 根据接口路径获取详细定义 |

## Hooks

| Hook | 事件 | 说明 |
|------|------|------|
| windows-notification | Stop / Notification | WSL 环境下 Windows 桌面通知 |

## 目录结构

```
.claude-plugin/
  plugin.json         # 插件元信息
  marketplace.json    # 市场配置
skills/
  code-archaeologist/ # Git 仓库考古分析
  react-modal/        # React 弹窗模板
  send-email/         # SMTP 邮件发送
  yapi-fetch/         # YApi 接口查询
hooks/
  hooks.json          # Hook 注册配置
  windows-notification.sh   # WSL 通知脚本
  windows-notification.ps1  # PowerShell 通知脚本
```
