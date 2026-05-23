---
name: send-email
description: 当用户要求发送邮件、发送通知、发送报告或发送提醒时触发。支持 SMTP 协议，HTML 和纯文本格式，支持多邮箱配置存储与选择。
context: fork
agent: general-purpose
permissions: Bash,Read,Write
---

# 发送邮件

通过 SMTP 协议发送邮件，支持 HTML 富文本和纯文本格式。支持存储多个邮箱配置，发送时快速选择。

## 配置存储

配置文件路径：`~/.claude/email-configs.json`

```json
{
  "configs": [
    {
      "name": "工作邮箱",
      "host": "smtp.exmail.qq.com",
      "port": 465,
      "user": "zhangsan@company.com",
      "pass": "授权码xxx"
    },
    {
      "name": "个人QQ",
      "host": "smtp.qq.com",
      "port": 465,
      "user": "123456@qq.com",
      "pass": "授权码yyy"
    }
  ]
}
```

## 执行流程

```dot
digraph send_email_flow {
    "开始" [shape=doublecircle];
    "检查配置文件是否存在" [shape=diamond];
    "读取已有配置" [shape=box];
    "展示配置列表供用户选择" [shape=box];
    "用户选择配置" [shape=diamond];
    "使用选中配置" [shape=box];
    "提示用户输入 SMTP 参数" [shape=box];
    "询问是否保存为新配置" [shape=diamond];
    "写入配置文件" [shape=box];
    "收集收件人/主题/正文" [shape=box];
    "发送邮件" [shape=box];
    "完成" [shape=doublecircle];

    "开始" -> "检查配置文件是否存在";
    "检查配置文件是否存在" -> "读取已有配置" [label="存在且非空"];
    "检查配置文件是否存在" -> "提示用户输入 SMTP 参数" [label="不存在或为空"];
    "读取已有配置" -> "展示配置列表供用户选择";
    "展示配置列表供用户选择" -> "用户选择配置";
    "用户选择配置" -> "使用选中配置" [label="选择已有"];
    "用户选择配置" -> "提示用户输入 SMTP 参数" [label="新增配置"];
    "提示用户输入 SMTP 参数" -> "询问是否保存为新配置";
    "询问是否保存为新配置" -> "写入配置文件" [label="是"];
    "询问是否保存为新配置" -> "收集收件人/主题/正文" [label="否"];
    "写入配置文件" -> "收集收件人/主题/正文";
    "使用选中配置" -> "收集收件人/主题/正文";
    "收集收件人/主题/正文" -> "发送邮件";
    "发送邮件" -> "完成";
}
```

### 第一步：加载或创建配置

```bash
CONFIG_FILE="$HOME/.claude/email-configs.json"

# 检查配置文件是否存在
if [ -f "$CONFIG_FILE" ] && [ -s "$CONFIG_FILE" ]; then
    echo "CONFIG_EXISTS"
    cat "$CONFIG_FILE"
else
    echo "NO_CONFIG"
fi
```

### 第二步：展示已有配置供选择

如果配置文件存在且非空，使用 AskUserQuestion 展示列表让用户选择：

- 选项 1~N：已存储的配置（显示 `name` 和 `user`）
- 最后一个选项：「新增邮箱配置」

**示例：**

> 已检测到以下邮箱配置，请选择发件邮箱：
> 1. 工作邮箱 (zhangsan@company.com)
> 2. 个人QQ (123456@qq.com)
> 3. 新增邮箱配置

### 第三步：新增配置（仅在需要时）

当用户选择「新增配置」或无已有配置时，提示用户输入：

| 参数 | 必填 | 说明 |
|------|------|------|
| 配置名称 | 是 | 用户自定义别名，如「工作邮箱」、「个人QQ」 |
| SMTP_HOST | 是 | SMTP 服务器地址 |
| SMTP_PORT | 是 | 端口号，通常 465(SSL) 或 587(TLS) |
| SMTP_USER | 是 | 发件人邮箱账号 |
| SMTP_PASS | 是 | 邮箱授权码（非登录密码） |

输入完成后询问是否保存。如果用户同意，写入配置文件：

```bash
# 保存新配置到文件（追加到 configs 数组）
python3 << 'PYEOF'
import json, os

config_file = os.path.expanduser("~/.claude/email-configs.json")
new_config = {
    "name": "配置名称",
    "host": "smtp_host",
    "port": 465,
    "user": "user@example.com",
    "pass": "授权码"
}

if os.path.exists(config_file):
    with open(config_file, "r") as f:
        data = json.load(f)
else:
    data = {"configs": []}

data["configs"].append(new_config)

os.makedirs(os.path.dirname(config_file), exist_ok=True)
with open(config_file, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"配置 '{new_config['name']}' 已保存")
PYEOF
```

### 第四步：收集邮件内容

通过 AskUserQuestion 收集：

| 参数 | 必填 | 说明 |
|------|------|------|
| 收件人 | 是 | 一个或多个邮箱地址 |
| 邮件主题 | 是 | 邮件标题 |
| 邮件正文 | 是 | HTML 或纯文本内容 |

### 第五步：发送邮件

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(host, port, user, password, to_addrs, subject, body_html=None, body_text=None):
    if not (body_html or body_text):
        raise ValueError("必须提供 body_html 或 body_text 之一")

    msg = MIMEMultipart("alternative")
    msg["From"] = user
    msg["To"] = ", ".join(to_addrs) if isinstance(to_addrs, list) else to_addrs
    msg["Subject"] = subject

    if body_text:
        msg.attach(MIMEText(body_text, "plain", "utf-8"))
    if body_html:
        msg.attach(MIMEText(body_html, "html", "utf-8"))

    with smtplib.SMTP_SSL(host, port) as server:
        server.login(user, password)
        server.sendmail(user, to_addrs if isinstance(to_addrs, list) else [to_addrs], msg.as_string())

    print(f"邮件已发送至: {to_addrs}")
```

## 常用 SMTP 配置参考

| 邮箱 | SMTP_HOST | SMTP_PORT | 备注 |
|------|-----------|-----------|------|
| QQ 邮箱 | smtp.qq.com | 465 | 需开启 SMTP 服务，使用授权码 |
| 163 邮箱 | smtp.163.com | 465 | 需开启 SMTP 服务，使用授权码 |
| Gmail | smtp.gmail.com | 465 | 需开启应用专用密码 |
| Outlook | smtp.office365.com | 587 | 使用 TLS |
| 企业微信邮箱 | smtp.exmail.qq.com | 465 | 使用企业邮箱密码 |

## 配置管理命令

用户可通过以下指令管理已存储的配置：

- **查看配置列表**：读取 `~/.claude/email-configs.json`，展示所有已保存配置的名称和邮箱
- **删除配置**：从配置文件中移除指定配置
- **测试连接**：使用某条配置尝试连接 SMTP 服务器，验证凭证是否有效

```bash
# 测试 SMTP 连接
python3 << 'PYEOF'
import smtplib
s = smtplib.SMTP_SSL("smtp_host", 465)
s.login("user", "pass")
print("连接成功")
s.quit()
PYEOF
```

## 关键限制

- **禁止硬编码凭证**：所有敏感信息来自配置文件或用户输入
- **禁止静默失败**：发送失败必须输出完整错误信息
- **配置文件权限**：创建后建议设置 `chmod 600`，防止其他用户读取
- **授权码非密码**：QQ/163 等邮箱需要的是 SMTP 授权码，不是登录密码
