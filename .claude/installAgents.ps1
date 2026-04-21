<#
.SYNOPSIS
Claude Agents MD 文件安装脚本（Windows）
.DESCRIPTION
将本地 agents 文件夹中的所有 .md 文件软链接到 Claude agents 目录
无任何子文件夹，仅处理 .md 格式 Agent 文件
#>

# --------------- 配置区（自动识别当前目录，无需手动修改）---------------
# 自动获取脚本运行目录下的 agents 文件夹
$currentDir = $PWD.Path
$localAgentsRoot = Join-Path -Path $currentDir -ChildPath "agents"
# Claude 官方默认 agents 目录
$claudeAgentsRoot = "$env:USERPROFILE\.claude\agents"
# --------------------------------------------------------------

# 管理员权限检测
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ 错误：需要以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "👉 操作：右键 PowerShell → 以管理员身份运行" -ForegroundColor Yellow
    pause
    exit 1
}

# 1. 检查本地 agents 根目录是否存在
if (-not (Test-Path $localAgentsRoot -PathType Container)) {
    Write-Host "❌ 错误：当前目录下未找到 agents 文件夹 → $localAgentsRoot" -ForegroundColor Red
    $createLocal = Read-Host "是否自动创建该文件夹？(Y/N)"
    if ($createLocal -eq "Y" -or $createLocal -eq "y") {
        New-Item -ItemType Directory -Path $localAgentsRoot -Force | Out-Null
        Write-Host "✅ 已创建本地 agents 根文件夹：$localAgentsRoot" -ForegroundColor Green
        Write-Host "⚠️ 请先放入 .md 格式的 Agent 文件，再重新运行脚本" -ForegroundColor Yellow
        pause
        exit 0
    } else {
        Write-Host "🔴 脚本终止，请先创建 agents 文件夹并放入 .md 文件" -ForegroundColor Red
        pause
        exit 1
    }
}

# 2. 获取本地 agents 下所有 .md 文件（仅一级，无子文件夹）
$localAgentFiles = Get-ChildItem -Path $localAgentsRoot -File -Filter "*.md" -ErrorAction SilentlyContinue
if (-not $localAgentFiles -or $localAgentFiles.Count -eq 0) {
    Write-Host "❌ 错误：本地 agents 文件夹下没有任何 .md 文件" -ForegroundColor Red
    Write-Host "👉 放入文件示例：$localAgentsRoot\联网文档助手.md" -ForegroundColor Yellow
    pause
    exit 1
}

# 3. 确保 Claude agents 根目录存在
if (-not (Test-Path $claudeAgentsRoot -PathType Container)) {
    New-Item -ItemType Directory -Path $claudeAgentsRoot -Force | Out-Null
    Write-Host "✅ 已创建 Claude agents 根目录：$claudeAgentsRoot" -ForegroundColor Green
}

# 4. 遍历所有 .md 文件，创建软链接
$successCount = 0
$failCount = 0
Write-Host "`n📌 开始安装 Claude Agents（软链接）..." -ForegroundColor Cyan

foreach ($file in $localAgentFiles) {
    $agentFileName = $file.Name          # 如 联网文档助手.md
    $localAgentPath = $file.FullName     # 本地文件完整路径
    $claudeAgentPath = Join-Path -Path $claudeAgentsRoot -ChildPath $agentFileName

    try {
        # 如果目标已存在，先删除
        if (Test-Path $claudeAgentPath) {
            Remove-Item $claudeAgentPath -Force -ErrorAction Stop
            Write-Host "ℹ️ 已替换旧文件：$agentFileName" -ForegroundColor Gray
        }

        # 创建文件软链接
        New-Item -ItemType SymbolicLink -Path $claudeAgentPath -Target $localAgentPath -Force -ErrorAction Stop | Out-Null
        Write-Host "✅ 已安装：$agentFileName" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "❌ 安装失败：$agentFileName -> $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

# 5. 结果汇总
Write-Host "`n📊 安装完成：" -ForegroundColor Cyan
Write-Host "   ✅ 成功安装：$successCount 个 Agent" -ForegroundColor Green
Write-Host "   ❌ 失败：$failCount 个" -ForegroundColor Red
Write-Host "   📁 Claude 安装目录：$claudeAgentsRoot" -ForegroundColor Gray

# 6. 使用提示
Write-Host "`n📢 立即生效方法：" -ForegroundColor Cyan
Write-Host "   1. 重启 Claude 客户端" -ForegroundColor Gray
Write-Host "   2. 或在 Claude 内输入：/reload agents" -ForegroundColor Gray
Write-Host "   3. 输入 /agents 即可看到你安装的所有本地 Agent" -ForegroundColor Gray

pause