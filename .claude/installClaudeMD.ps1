<#
.SYNOPSIS
将当前文件夹下的 CLAUDE.md 文件软链接到用户目录的 .claude/CLAUDE.md（Windows）
.DESCRIPTION
创建文件符号链接，实现本地文件与 Claude 配置文件同步，后期直接替换真实文件即可
#>

# --------------- 配置区（自动识别，无需修改）---------------
# 当前文件夹的 CLAUDE.md
$currentDir = $PWD.Path
$localFile = Join-Path -Path $currentDir -ChildPath "CLAUDE.md"

# 目标路径：用户目录\.claude\CLAUDE.md
$targetDir = "$env:USERPROFILE\.claude"
$targetFile = Join-Path -Path $targetDir -ChildPath "CLAUDE.md"
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

# 1. 检查本地 CLAUDE.md 是否存在
if (-not (Test-Path $localFile -PathType Leaf)) {
    Write-Host "❌ 错误：当前目录未找到 CLAUDE.md → $localFile" -ForegroundColor Red
    pause
    exit 1
}

# 2. 确保目标目录 .claude 存在
if (-not (Test-Path $targetDir -PathType Container)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "✅ 已创建目录：$targetDir" -ForegroundColor Green
}

# 3. 如果目标已存在，备份或删除
try {
    if (Test-Path $targetFile) {
        $item = Get-Item $targetFile -Force

        # 如果是软链接，直接删除
        if ($item.Attributes -match "ReparsePoint") {
            Remove-Item $targetFile -Force -ErrorAction Stop
            Write-Host "ℹ️ 已删除旧的软链接" -ForegroundColor Gray
        }
        else {
            # 普通文件 → 备份
            $backupPath = "$targetFile.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $targetFile $backupPath -Force
            Write-Host "📦 已备份原有文件 → $backupPath" -ForegroundColor Cyan
        }
    }

    # 4. 创建文件软链接
    New-Item -ItemType SymbolicLink -Path $targetFile -Target $localFile -Force -ErrorAction Stop | Out-Null
    Write-Host "`n✅ 链接创建成功！" -ForegroundColor Green
    Write-Host "🔗 源文件：$localFile"
    Write-Host "🔗 链接到：$targetFile"
}
catch {
    Write-Host "`n❌ 链接失败：$($_.Exception.Message)" -ForegroundColor Red
    pause
    exit 1
}

# 结束提示
Write-Host "`n📢 使用说明：" -ForegroundColor Cyan
Write-Host "   以后只需要修改当前文件夹的 CLAUDE.md，自动同步到 .claude 目录" -ForegroundColor Gray
Write-Host "   不需要链接时，直接删除 $targetFile 即可恢复正常" -ForegroundColor Gray

pause