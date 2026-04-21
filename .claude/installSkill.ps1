<#
.SYNOPSIS
Claude Skills 子文件夹单独链接脚本（Windows）
.DESCRIPTION
仅将本地 skills 下的子文件夹创建软链接到 Claude skills 目录，避免覆盖其他技能
#>

# --------------- 配置区（自动识别当前目录，无需手动修改）---------------
# 自动获取脚本运行目录下的 skills 文件夹
$currentDir = $PWD.Path
$localSkillsRoot = Join-Path -Path $currentDir -ChildPath "skills"
# Claude 技能根目录（默认无需修改）
$claudeSkillsRoot = "$env:USERPROFILE\.claude\skills"
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

# 1. 检查本地 skills 根目录是否存在
if (-not (Test-Path $localSkillsRoot -PathType Container)) {
    Write-Host "❌ 错误：当前目录下未找到 skills 文件夹 → $localSkillsRoot" -ForegroundColor Red
    $createLocal = Read-Host "是否自动创建该文件夹？(Y/N)"
    if ($createLocal -eq "Y" -or $createLocal -eq "y") {
        New-Item -ItemType Directory -Path $localSkillsRoot -Force | Out-Null
        Write-Host "✅ 已创建本地 skills 根文件夹：$localSkillsRoot" -ForegroundColor Green
        Write-Host "⚠️ 请先在该文件夹下创建技能子文件夹（如 my-skill-1），再重新运行脚本" -ForegroundColor Yellow
        pause
        exit 0
    } else {
        Write-Host "🔴 脚本终止，请先创建 skills 文件夹并放入技能子文件夹" -ForegroundColor Red
        pause
        exit 1
    }
}

# 2. 获取本地 skills 下的所有子文件夹（仅一级）
$localSkillFolders = Get-ChildItem -Path $localSkillsRoot -Directory -ErrorAction SilentlyContinue
if (-not $localSkillFolders -or $localSkillFolders.Count -eq 0) {
    Write-Host "❌ 错误：本地 skills 文件夹下无任何子文件夹（需放入具体技能文件夹）" -ForegroundColor Red
    Write-Host "👉 示例结构：$localSkillsRoot\my-skill-1、$localSkillsRoot\my-skill-2" -ForegroundColor Yellow
    pause
    exit 1
}

# 3. 确保 Claude skills 根目录存在（不存在则创建）
if (-not (Test-Path $claudeSkillsRoot -PathType Container)) {
    New-Item -ItemType Directory -Path $claudeSkillsRoot -Force | Out-Null
    Write-Host "✅ 已创建 Claude skills 根目录：$claudeSkillsRoot" -ForegroundColor Green
}

# 4. 遍历本地技能子文件夹，逐个创建软链接
$successCount = 0
$failCount = 0
Write-Host "`n📌 开始创建子文件夹软链接..." -ForegroundColor Cyan

foreach ($folder in $localSkillFolders) {
    $skillName = $folder.Name  # 技能文件夹名称（如 my-skill-1）
    $localSkillPath = $folder.FullName  # 本地技能文件夹绝对路径
    $claudeSkillLinkPath = Join-Path -Path $claudeSkillsRoot -ChildPath $skillName  # Claude 侧链接路径

    try {
        # 处理已存在的同名链接/文件夹
        if (Test-Path $claudeSkillLinkPath) {
            $item = Get-Item $claudeSkillLinkPath -Force
            if ($item.Attributes -match "ReparsePoint") {
                # 已是软链接，直接删除替换
                Remove-Item $claudeSkillLinkPath -Force -ErrorAction Stop
                Write-Host "ℹ️ 已删除原有软链接：$skillName" -ForegroundColor Gray
            } else {
                # 是普通文件夹，备份后删除
                $backupPath = "$claudeSkillLinkPath-backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
                Move-Item $claudeSkillLinkPath $backupPath -Force
                Write-Host "📦 已备份同名文件夹 $skillName 到：$backupPath" -ForegroundColor Cyan
            }
        }

        # 创建单个技能的软链接
        New-Item -ItemType SymbolicLink -Path $claudeSkillLinkPath -Target $localSkillPath -Force -ErrorAction Stop | Out-Null
        Write-Host "✅ 成功链接：$skillName → $localSkillPath" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host "❌ 链接失败：$skillName → $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

# 5. 结果汇总
Write-Host "`n📊 链接创建完成：" -ForegroundColor Cyan
Write-Host "   ✅ 成功：$successCount 个" -ForegroundColor Green
Write-Host "   ❌ 失败：$failCount 个" -ForegroundColor Red
Write-Host "   📁 Claude 技能目录：$claudeSkillsRoot" -ForegroundColor Gray

# 6. 提示后续操作
Write-Host "`n📢 下一步操作：" -ForegroundColor Cyan
Write-Host "   1. 重启 Claude 客户端" -ForegroundColor Gray
Write-Host "   2. 在 Claude 中输入 /reload skills 重载所有技能" -ForegroundColor Gray
Write-Host "   3. 输入 /skills 查看已加载的技能（含本地和其他途径安装的）" -ForegroundColor Gray

pause