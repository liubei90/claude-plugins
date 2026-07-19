---
name: code-archaeologist
description: 当用户要求分析 git 仓库的历史、开发流程、分支策略、CI/CD 配置或分支命名规范时触发。提供深度代码考古：代码为何这样写、工作流检测、分支用途识别和可执行的改进建议。
context: fork
agent: Explore
permissions: Bash,Read
---

# Code Archaeologist

对 git 仓库进行深度分析：提交历史、分支策略、CI/CD 配置、开发工作流检测、分支命名规范，并输出优先级排序的改进建议。仅使用标准 git/CLI 工具，零外部依赖。

## 触发条件

- "分析这个仓库的开发历史"
- "这个项目的分支策略是什么？"
- "这段代码为什么这样写？"
- "分析一下 CI/CD 配置"
- "这个团队用什么开发流程？"
- "推荐分支命名规范"
- "贡献者活跃度如何？"
- 用户要求完整的仓库健康检查

不适用场景：简单的 `git log`、代码审查、PR 管理。

## 执行流程

### 第一步：仓库概览

```bash
echo "=== 基本信息 ==="
git remote -v | head -1
echo "首次提交: $(git log --reverse --format='%ai' | head -1)"
echo "最近提交: $(git log -1 --format='%ai')"
echo "总提交数: $(git log --oneline | wc -l | tr -d ' ')"
# 探测默认分支（兼容 main/master，origin/HEAD 未设置时自动回退）
DEFAULT_BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
if [ -z "$DEFAULT_BRANCH" ]; then
  git show-ref --verify --quiet refs/heads/main && DEFAULT_BRANCH=main || DEFAULT_BRANCH=master
fi
echo "默认分支: $DEFAULT_BRANCH"
git rev-parse --is-shallow-repository
```

### 第二步：6 大分析模块

按顺序执行以下模块，收集原始数据后综合分析。

---

## 模块 1：提交历史分析

### 提交频率趋势

```bash
# 月度提交量（近 12 个月）
git log --format='%ai' --since="12 months ago" | cut -d'-' -f1,2 | sort | uniq -c

# 每周几提交最多
git log --format='%ad' --date=format:'%A' --since="6 months ago" | sort | uniq -c | sort -rn

# 工作时间分析（按小时）
git log --format='%ad' --date=format:'%H' --since="6 months ago" | sort | uniq -c
```

### 贡献者分析

```bash
# 贡献者排行（近 6 个月）
git shortlog -sn --since="6 months ago"

# 每人每月活跃度
git log --format='%ae %ai' --since="12 months ago" | awk '{split($2,d,"-"); print $1, d[1]"-"d[2]}' | sort | uniq -c | sort -rn
```

### 代码热点文件

```bash
# 最频繁变更的文件
git log --pretty=format: --name-only --since="6 months ago" | sort | uniq -c | sort -rn | head -20

# 行数变更最多的文件（churn）
git log --pretty=format: --numstat --since="6 months ago" | awk '{add[$3]+=$1; del[$3]+=$2} END{for(f in add) if(f!="") print add[f]+del[f], add[f], del[f], f}' | sort -rn | head -20

# 高 churn + 多作者 = 复杂度热点
git log --pretty=format:"%ae" --name-only --since="6 months ago" | awk '/@/{author=$0; next} NF{files[$0]++; authors[$0][author]=1} END{for(f in files) if(files[f]>10 && length(authors[f])>2) print "RISK:", f, "churn="files[f], "authors="length(authors[f])}' | sort -t= -k2 -rn
```

### 提交质量

```bash
# Conventional Commits 合规率
# 注意：grep -c 无匹配时已输出 0 且返回非零；勿加 "|| echo 0"（会重复输出 0），用 "|| true" 屏蔽退出码即可
echo -n "合规: "; git log --format='%s' --since="6 months ago" | grep -cE '^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)' || true
echo -n "总计: "; git log --oneline --since="6 months ago" | wc -l | tr -d ' '

# 合并提交占比
echo -n "Merge commits: "; git log --merges --oneline --since="6 months ago" | wc -l | tr -d ' '
echo -n "Squash (PR#): "; git log --oneline --since="6 months ago" | grep -c ' (#' || true

# 提交规模分布（每次提交变更的文件数：中位数/均值/总提交数）
# grep 同时匹配单复数 "file changed"/"files changed"；取 $1（文件数），原 $4 实为插入行数
git log --shortstat --since="6 months ago" | grep -E 'files? changed' | awk '{print $1}' | sort -n | awk 'BEGIN{c=0}{a[c++]=$1;s+=$1}END{if(c>0) print "median:"a[int(c/2)]" mean:"int(s/c)" total:"c}'
```

---

## 模块 2：分支分析

### 分支清单

```bash
# 所有分支（含最后提交日期、作者、描述）
git branch -a --format='%(committerdate:short) %(refname:short) %(authorname) %(subject)' --sort=-committerdate | head -30

# 分支数量
echo "本地: $(git branch | wc -l)"
echo "远程: $(git branch -r | wc -l)"
```

### 过期分支检测

```bash
# 30 天无提交的分支（用 git 原生 %ct 时间戳，规避 date -d 在 macOS BSD date 上不兼容）
now=$(date +%s)
for branch in $(git branch --format='%(refname:short)'); do
  last_epoch=$(git log -1 --format='%ct' "$branch" 2>/dev/null)
  if [ -n "$last_epoch" ]; then
    age=$(( (now - last_epoch) / 86400 ))
    [ "$age" -gt 30 ] && echo "${age}d $branch"
  fi
done | sort -rn
```

### 合并模式分析

```bash
# 合并方式统计
echo -n "Merge commits: "; git log --merges --oneline --since="6 months ago" | wc -l
echo -n "Squash merges: "; git log --oneline --since="6 months ago" | grep -c ' (#' || true
echo -n "Linear (rebase): "; git log --no-merges --oneline --since="6 months ago" | wc -l | tr -d ' '

# 合并消息样本
git log --merges --format='%s' --since="6 months ago" | head -10
```

### 分支用途识别

```bash
# 每个分支相对默认分支的 ahead/behind（$DEFAULT_BRANCH 来自第一步；单独执行时下方兜底探测）
DEFAULT_BRANCH=${DEFAULT_BRANCH:-$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')}
[ -z "$DEFAULT_BRANCH" ] && { git show-ref --verify --quiet refs/heads/main && DEFAULT_BRANCH=main || DEFAULT_BRANCH=master; }
for branch in $(git branch --format='%(refname:short)' | grep -vx "$DEFAULT_BRANCH"); do
  ahead=$(git rev-list --count $DEFAULT_BRANCH..$branch 2>/dev/null)
  behind=$(git rev-list --count $branch..$DEFAULT_BRANCH 2>/dev/null)
  echo "$branch: +${ahead:-0}/-${behind:-0}"
done
```

---

## 模块 3：CI/CD 检测

### 平台识别

```bash
for f in \
  .github/workflows/*.yml .github/workflows/*.yaml \
  .gitlab-ci.yml \
  Jenkinsfile \
  .circleci/config.yml \
  .travis.yml \
  bitbucket-pipelines.yml \
  azure-pipelines.yml \
  .drone.yml \
  cloudbuild.yaml \
  .buildkite/pipeline.yml \
  Dockerfile docker-compose.yml \
; do
  [ -e "$f" ] && echo "FOUND: $f ($(wc -l < "$f") lines)"
done
```

### GitHub Actions 分析

```bash
for f in .github/workflows/*.yml .github/workflows/*.yaml; do
  [ -e "$f" ] || continue
  echo "--- $(basename $f) ---"
  grep -E '^(name:|on:)' "$f"
  echo ""
done
```

### GitLab CI 分析

```bash
# 阶段和任务
grep -E '^[a-zA-Z_]+:' .gitlab-ci.yml | head -20
grep -A10 'stages:' .gitlab-ci.yml
```

### CI 健康指标

```bash
# CI 配置最后修改时间
git log -1 --format='%cr' -- .github/workflows/ .gitlab-ci.yml Jenkinsfile 2>/dev/null

# CI 配置变更频率
git log --oneline --since="6 months ago" -- .github/workflows/ .gitlab-ci.yml | wc -l
```

---

## 模块 4：开发工作流检测

### 分支模型识别

```bash
# 探测默认分支（若第一步未设置）
DEFAULT_BRANCH=${DEFAULT_BRANCH:-$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')}
[ -z "$DEFAULT_BRANCH" ] && { git show-ref --verify --quiet refs/heads/main && DEFAULT_BRANCH=main || DEFAULT_BRANCH=master; }

# GitFlow 指标
echo -n "develop 分支: "; git branch -a | grep -c 'develop' || true
echo -n "release/*: "; git branch -a | grep -cE 'release/' || true
echo -n "hotfix/*: "; git branch -a | grep -cE 'hotfix/' || true

# Trunk-based 指标
echo -n "$DEFAULT_BRANCH 直接提交 (1mo): "; git log --oneline --first-parent --since="1 month ago" $DEFAULT_BRANCH 2>/dev/null | wc -l | tr -d ' '

# PR/MR 工作流
echo -n "Pull Request merges: "; git log --merges --format='%s' --since="6 months ago" | grep -ci 'pull request' || true

# 发布方式
echo -n "Tags: "; git tag | wc -l | tr -d ' '
echo -n "Latest tag: "; git describe --tags --abbrev=0 2>/dev/null || echo "无"
```

### 分支生命周期

```bash
for branch in $(git branch --format='%(refname:short)'); do
  created_epoch=$(git log --reverse --format='%ct' "$branch" 2>/dev/null | head -1)
  updated_epoch=$(git log -1 --format='%ct' "$branch" 2>/dev/null)
  if [ -n "$created_epoch" ] && [ -n "$updated_epoch" ]; then
    age=$(( (updated_epoch - created_epoch) / 86400 ))
    echo "${age}d $branch"
  fi
done | sort -rn | head -15
```

### 工作流分类

| 模型 | 关键指标 |
|------|---------|
| **GitFlow** | develop + release/* + hotfix/* + version tags |
| **GitHub Flow** | 仅 main，短生命周期 feature 分支，PR 合并 |
| **Trunk-Based** | 仅 main，极短分支 (<2d)，feature flags |
| **GitLab Flow** | main + 环境分支 (staging/production) |
| **Release Flow** | 从 main 切出 release/*，cherry-pick |
| **Custom/Mixed** | 不明确匹配以上任何一种 |

---

## 模块 5：分支命名规范分析

```bash
branches=$(git branch -a --format='%(refname:short)' | sed 's|origin/||' | grep -v HEAD | sort -u)

# 前缀模式
echo "--- 前缀模式 ---"
echo "$branches" | grep -oE '^[a-z]+/' | sort | uniq -c | sort -rn

# Ticket ID 引用
echo "--- Ticket ID ---"
echo "$branches" | grep -oE '[A-Z]+-[0-9]+' | sort | uniq -c | sort -rn

# 分隔符风格
echo "--- 分隔符 ---"
echo -n "Hyphen (-): "; echo "$branches" | grep -c '-'
echo -n "Slash (/): "; echo "$branches" | grep -c '/'
echo -n "Underscore (_): "; echo "$branches" | grep -c '_'

# 大小写
echo -n "含大写: "; echo "$branches" | grep -cE '[A-Z]'
```

### 推荐命名规范

```
<type>/<ticket-id>-<short-description>

示例:
  feature/AUTH-123-add-oauth-login
  bugfix/PROJ-456-fix-null-pointer
  hotfix/CRITICAL-fix-payment-crash
  release/2.1.0
  chore/update-dependencies
```

标准 type:
- `feature/` — 新功能
- `bugfix/` 或 `fix/` — 非紧急 bug
- `hotfix/` — 紧急生产修复
- `release/` — 发布准备
- `chore/` — 维护、依赖、工具
- `docs/` — 仅文档
- `test/` — 测试
- `refactor/` — 代码重构
- `infra/` 或 `devops/` — 基础设施

---

## 模块 6：综合建议

基于以上所有数据，按以下维度输出建议：

1. **分支策略** — 当前模型是否适合团队规模？
2. **分支卫生** — 过期分支是否太多？缺少清理？
3. **提交质量** — Conventional Commits 一致性？签名提交？
4. **CI/CD 覆盖** — 缺少测试、lint、安全扫描？
5. **代码审查** — PR/MR 工作流？Review 要求？
6. **分支命名** — 一致性？包含 ticket 引用？
7. **发布流程** — Tags？Changelog？自动发布？
8. **热点治理** — 高 churn 文件需要重构？

## 输出报告结构

```
# Code Archaeology Report: <repo-name>

## 1. 仓库概览
## 2. 提交历史分析
## 3. 分支分析
## 4. CI/CD 评估
## 5. 开发工作流
## 6. 分支命名规范
## 7. 改进建议 (按优先级排序)
```

## 注意事项

1. 大仓库用 `--since="6 months ago"` 限制范围，避免超时
2. 浅克隆会隐藏历史，先检查 `git rev-parse --is-shallow-repository`
3. Monorepo 用 `-- path/` 限定子目录
4. 默认分支统一通过 `$DEFAULT_BRANCH` 变量引用（第一步已探测，兼容 main/master）；各模块若单独执行，顶部有兜底探测
5. 远程分支需要 `git branch -a`，仅 `git branch` 只看本地
6. 时间计算统一用 git 原生 `%ct`（Unix 时间戳），规避 `date -d` 在 macOS BSD date 上不兼容的问题
7. `grep -c` 无匹配时已输出 `0` 且返回非零退出码，**勿**加 `|| echo 0`（会重复输出），用 `|| true` 屏蔽退出码即可
8. 建议要有数据支撑（数字、百分比），而非纯主观判断
