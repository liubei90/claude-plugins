#!/bin/bash

# windows-notification.sh
# 跨平台 Windows 通知脚本（支持 WSL/Git Bash/MSYS）

show_help() {
    echo "Usage: $0 [-Title \"title\"] [-Message \"message\"]"
    echo "   or: $0 \"title\" \"message\""
    exit 0
}

# 解析参数
if [[ "$1" == "-Title" ]] || [[ "$1" == "--title" ]]; then
    TITLE="$2"
    MESSAGE="$4"
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
else
    TITLE="${1:-Claude Code}"
    MESSAGE="${2:-Task Completed}"
fi

# 方法1: PowerShell Toast 通知（Windows 10/11）
send_toast() {
    powershell.exe -Command "
        try {
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > \$null
            \$template = @'
<toast>
    <visual>
        <binding template='ToastText02'>
            <text id='1'>$TITLE</text>
            <text id='2'>$MESSAGE</text>
        </binding>
    </visual>
    <audio src='ms-winsoundevent:Notification.Default'/>
</toast>
'@
            \$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
            \$xml.LoadXml(\$template)
            \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
            [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('ClaudeCode').Show(\$toast)
            exit 0
        } catch {
            exit 1
        }
    " 2>/dev/null
}

# 方法2: 气球通知（回退方案）
send_balloon() {
    powershell.exe -Command "
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        \$notification = New-Object System.Windows.Forms.NotifyIcon
        \$notification.Icon = [System.Drawing.SystemIcons]::Information
        \$notification.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        \$notification.BalloonTipTitle = '$TITLE'
        \$notification.BalloonTipText = '$MESSAGE'
        \$notification.Visible = \$true
        \$notification.ShowBalloonTip(5000)
        Start-Sleep -Seconds 5
        \$notification.Dispose()
    " 2>/dev/null
}

# 方法3: 控制台输出（最终回退）
send_console() {
    echo "========================================="
    echo "🔔 NOTIFICATION: $TITLE"
    echo "📝 MESSAGE: $MESSAGE"
    echo "========================================="
}

# 尝试发送通知
echo "📢 Sending notification..."

if send_toast; then
    echo "✓ Toast notification sent"
elif send_balloon; then
    echo "✓ Balloon notification sent"
else
    echo "⚠️  Unable to send graphical notification"
    send_console
    exit 1
fi

exit 0