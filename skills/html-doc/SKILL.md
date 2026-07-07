---
name: html-doc
description: 生成 html-effectiveness 风格的自包含 HTML 文档。当用户明确要求"生成 HTML 文档"、"输出 HTML 格式"、"做成 HTML 页面"、"用 HTML 写个报告/计划/说明"时触发。不要在其他文档生成场景（如 Markdown、Word、PDF）中自动触发。
---

# HTML 文档生成器

基于 [html-effectiveness](https://github.com/thariqs/html-effectiveness) 的风格规范，生成零依赖、单文件、排版精美的自包含 HTML 文档。

## 核心理念

- **零依赖**：单个 `.html` 文件，无外部 CSS/JS/字体引用，无需构建步骤，浏览器直接打开
- **排版驱动**：以优雅的排版为核心，层次分明，信息密度适中
- **自包含**：所有 CSS 内联在 `<style>` 标签中，所有 SVG 图形直接嵌入
- **内容优先**：设计服务于内容，不喧宾夺主

## 工作流程

### 第一步：了解用户需求

当用户要求生成 HTML 文档时，先弄清楚：
1. 文档的主题/目的是什么
2. 目标读者是谁
3. 有哪些关键内容需要呈现

### 第二步：推荐文档类型

根据用户需求，从以下类型中推荐最合适的，列出 2-3 个选项让用户选择：

| 类别 | 文档类型 | 适用场景 |
|------|---------|---------|
| **探索与规划** | 方案对比 (code-approaches) | 比较多种技术方案的优劣 |
| | 视觉设计方向 (visual-designs) | 展示多个 UI 设计方向 |
| | 实现计划 (implementation-plan) | 里程碑、数据流图、风险表 |
| **代码审查** | 带注释的 PR 审查 (code-review) | 代码 diff + 旁注 + 严重度标签 |
| | PR 描述文档 (pr-writeup) | 动机、前后对比、逐文件说明 |
| | 模块地图 (code-understanding) | 代码架构的盒子和箭头图 |
| **设计** | 设计系统 (design-system) | 颜色、字体、间距令牌的可视化 |
| | 组件变体 (component-variants) | 组件的所有尺寸/状态/意图 |
| **原型** | 动画沙盒 (animation) | 可调参数的过渡动画演示 |
| | 可点击流程 (interaction) | 多页面交互原型 |
| **图示** | SVG 插图 (svg-illustrations) | 博客配图、示意图 |
| | 流程图 (flowchart) | 可点击的注释流程图 |
| **演示** | 幻灯片 (slide-deck) | 键盘左右键翻页的演示文稿 |
| **研究** | 功能解析 (feature-explainer) | 折叠式分步解析、代码示例 |
| | 概念讲解 (concept-explainer) | 交互式概念教学 |
| **报告** | 周报/状态报告 (status-report) | 本周成果、数据图表、下周计划 |
| | 事件报告 (incident-report) | 时间线、日志摘录、跟进清单 |
| **交互工具** | 分类看板 (triage-board) | 拖拽排序的卡片看板 |
| | 配置编辑器 (feature-flags) | 开关/配置管理界面 |
| | 提示词调试器 (prompt-tuner) | 模板编辑 + 实时预览 |

### 第三步：确认配色方案

用户选定文档类型后，简要询问配色偏好：
- "使用默认的 html-effectiveness 配色（象牙白 + 陶土色），还是自定义配色？"
- 如果用户没有特别偏好，直接使用默认配色即可，无需追问

### 第四步：生成 HTML 文档

用户选定类型和配色后，按以下规范生成文档。

---

## 设计系统 (Design Tokens)

以下是默认的 CSS 变量和设计令牌。用户可以选择使用这套默认配色，也可以自定义配色风格：

```css
:root {
  /* 颜色 */
  --ivory:    #FAF9F5;   /* 页面背景 */
  --slate:    #141413;   /* 主文字色 */
  --clay:     #D97757;   /* 强调色 / 链接 */
  --oat:      #E3DACC;   /* 次要强调 */
  --olive:    #788C5D;   /* 成功/正向 */
  --rust:     #B04A3F;   /* 错误/危险（仅在需要时引入） */
  --gray-100: #F0EEE6;   /* 浅灰背景 */
  --gray-300: #D1CFC5;   /* 边框 */
  --gray-500: #87867F;   /* 次要文字 */
  --gray-700: #3D3D3A;   /* 正文文字 */
  --white:    #FFFFFF;   /* 卡片背景 */

  /* 字体 */
  --serif: ui-serif, Georgia, "Times New Roman", Times, serif;
  --sans:  system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  --mono:  ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace;

  /* 圆角 */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 14px;
  --radius-full: 999px;

  /* 边框 */
  --border: 1.5px solid var(--gray-300);
}
```

### 自定义配色

如果用户想使用自己的配色方案，按以下方式处理：

1. **询问用户偏好**：主动询问用户是否有配色偏好，例如：
   - "使用默认的 html-effectiveness 配色（象牙白 + 陶土色），还是自定义配色？"
   - 如果自定义，可让用户提供：品牌色/主色调、偏好的风格（暖色/冷色/暗色等）

2. **自定义规则**：
   - 保持 CSS 变量名不变（`--ivory`, `--slate`, `--clay` 等），只修改变量值
   - 背景色（`--ivory`）和主文字色（`--slate`）需保持足够对比度（建议 ≥ 4.5:1）
   - 强调色（`--clay`）用于链接、高亮、按钮等交互元素
   - 灰色阶（`--gray-100` 到 `--gray-700`）需保持由浅到深的层级关系
   - 字体栈也可自定义，但推荐使用系统字体以确保零依赖

3. **示例 — 暗色主题**：
   ```css
   :root {
     --ivory:    #1A1A2E;   /* 暗色背景 */
     --slate:    #EAEAEA;   /* 浅色文字 */
     --clay:     #FF6B6B;   /* 珊瑚红强调 */
     --oat:      #2D2D44;   /* 次要区域 */
     --olive:    #6BFF8E;   /* 正向绿 */
     --gray-100: #252540;
     --gray-300: #3A3A55;
     --gray-500: #8888AA;
     --gray-700: #CCCCDD;
     --white:    #222240;
   }
   ```

4. **示例 — 蓝色主题**：
   ```css
   :root {
     --ivory:    #F5F7FA;
     --slate:    #1A2332;
     --clay:     #3B82F6;
     --oat:      #E8EDF4;
     --olive:    #10B981;
     --gray-100: #EEF1F5;
     --gray-300: #D1D8E0;
     --gray-500: #8795A7;
     --gray-700: #3D4A5C;
     --white:    #FFFFFF;
   }
   ```

## 全局样式模板

每个文档都从以下基础样式开始：

```css
* { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; }

body {
  font-family: var(--sans);
  background: var(--ivory);
  color: var(--gray-700);
  font-size: 15px;
  line-height: 1.6;
  padding: 56px 24px 120px;
  -webkit-font-smoothing: antialiased;
}

.page {
  max-width: 视内容而定（通常 860px-1120px）;
  margin: 0 auto;
}
```

## 通用排版组件

### 页面头部 (Page Header)

```html
<header class="page-head">
  <div class="eyebrow">分类标签</div>
  <h1>文档标题</h1>
  <p class="lead">简短描述</p>
</header>
```

```css
.eyebrow {
  font-family: var(--mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--gray-500);
  margin-bottom: 10px;
}

h1 {
  font-family: var(--serif);
  font-weight: 500;
  font-size: clamp(32px, 4vw, 38px);
  line-height: 1.15;
  color: var(--slate);
  margin-bottom: 14px;
  letter-spacing: -0.01em;
}

.lead {
  font-size: 15px;
  color: var(--gray-500);
  max-width: 640px;
}
```

### 章节 (Section)

```css
section { margin-bottom: 64px; }

h2 {
  font-family: var(--serif);
  font-weight: 500;
  font-size: 24px;
  color: var(--slate);
  letter-spacing: -0.01em;
  margin-bottom: 8px;
}

hr.rule {
  border: none;
  border-top: 1px solid var(--gray-300);
  margin: 0 0 22px;
}
```

### 卡片 (Card)

```css
.card {
  background: var(--white);
  border: var(--border);
  border-radius: var(--radius-md);
  padding: 24px;
}
```

### 代码块 (Code Block)

```css
.code-block {
  background: var(--slate);
  border-radius: var(--radius-md);
  padding: 18px 20px;
  overflow-x: auto;
}

.code-block pre {
  font-family: var(--mono);
  font-size: 12.5px;
  line-height: 1.65;
  color: #E8E6DE;
  white-space: pre;
}
```

### 提示框 (Callout / Prompt Box)

```css
.callout {
  background: var(--gray-100);
  border: var(--border);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  font-size: 14.5px;
}

.callout .label {
  font-family: var(--mono);
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--gray-500);
  display: block;
  margin-bottom: 6px;
}
```

### 标签/徽章 (Badge / Pill)

```css
.badge {
  display: inline-block;
  font-family: var(--mono);
  font-size: 11px;
  padding: 3px 9px;
  border-radius: var(--radius-sm);
  background: var(--oat);
  color: var(--slate);
}

.pill {
  font-family: var(--mono);
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--gray-500);
  background: var(--gray-100);
  border: var(--border);
  border-radius: var(--radius-full);
  padding: 5px 11px;
}
```

### 统计卡片 (Stat Card)

```css
.stat-card {
  background: var(--white);
  border: var(--border);
  border-radius: var(--radius-md);
  padding: 20px 22px 18px;
}

.stat-num {
  font-family: var(--serif);
  font-size: 44px;
  font-weight: 500;
  line-height: 1;
  color: var(--slate);
  margin-bottom: 8px;
}

.stat-label {
  font-family: var(--sans);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--gray-500);
}
```

---

## 各类型文档结构指南

### 方案对比 (code-approaches)
- 3 列 Grid 并排展示不同方案
- 每列包含：编号标签、方案名、一句话描述、代码块、优缺点列表
- 底部可以有推荐总结

### 视觉设计方向 (visual-designs)
- 2×2 或 3×2 的 Grid 展示不同设计方向
- 每个方向包含：名称、调色板色块、关键 UI 元素示意、适用场景

### 实现计划 (implementation-plan)
- 顶部摘要条（估算时间、涉及模块数、风险等级）
- 里程碑时间线（竖线 + 圆点 + 卡片）
- 数据流图（SVG 盒子 + 箭头）
- 风险表格
- 关键代码片段

### 代码审查 (code-review)
- PR 头部信息卡片（仓库、分支、作者、提交数）
- 审查摘要（严重/警告/建议计数）
- 每个发现：文件路径、行号、严重度标签、问题描述、建议代码
- 跳转链接

### PR 描述 (pr-writeup)
- 动机与背景
- 变更前后对比（双栏布局）
- 逐文件说明（文件路径 + 变更说明）
- 审查聚焦点

### 模块地图 (code-understanding)
- 调用关系图（SVG 盒子和箭头，热路径高亮）
- 入口点列表
- 每个模块的职责说明

### 设计系统 (design-system)
- 调色板色块网格（色值 + 变量名）
- 字体层级展示（字号 + 行高 + 字重）
- 间距刻度表
- 圆角和阴影示例

### 组件变体 (component-variants)
- 每个组件一个区域
- 横向排列所有变体（尺寸、状态、意图）
- 标注每个变体的使用场景

### 动画沙盒 (animation)
- 预览区域 + 滑块控制面板
- 可调节参数：持续时间、缓动函数、延迟
- 使用 CSS transition/animation 或少量 JS

### 可点击流程 (interaction)
- 多个屏幕状态
- 点击/悬停触发切换
- 用少量 JS 管理状态

### SVG 插图 (svg-illustrations)
- 多个 SVG 图形并排或网格排列
- 每个图形带标题和简短说明
- 使用设计系统的颜色

### 流程图 (flowchart)
- 主画布（SVG）+ 侧边详情面板
- 节点可点击，点击后侧边栏显示详情
- 使用设计系统颜色区分节点类型

### 幻灯片 (slide-deck)
- 每个 `<section class="slide">` 占满一屏
- 使用 `scroll-snap` 实现翻页
- 支持键盘左右键导航（需少量 JS）
- 可包含暗色反转页（`.slide.invert`）

### 功能解析 (feature-explainer)
- 左侧粘性导航 + 右侧内容
- TL;DR 摘要框
- 折叠式步骤详述
- Tab 切换的代码示例
- FAQ 区域

### 概念讲解 (concept-explainer)
- 交互式演示（可操作的可视化）
- 对比表格
- 术语表（hover 提示）

### 状态报告 (status-report)
- 顶部摘要统计卡片（4 列）
- 本周亮点
- 详细进展列表（完成/进行中/受阻）
- 小图表（CSS 柱状图或 SVG）
- 下周计划

### 事件报告 (incident-report)
- 影响摘要（持续时间、影响范围、严重度）
- 分钟级时间线（竖线 + 事件节点）
- 根因分析
- 修复措施
- 跟进清单（checkbox 列表）

### 交互工具 (triage-board / feature-flags / prompt-tuner)
- 功能性的 UI，需要 JavaScript
- 包含导出/复制按钮
- 操作结果可复制回对话中

---

## 编写规范

1. **HTML 文档结构**：使用 `<!DOCTYPE html>`，`<html lang="zh-CN">`（中文内容）或 `lang="en"`（英文内容），`<meta charset="utf-8">`
2. **CSS 必须内联**：所有样式写在 `<style>` 标签中，不引用外部样式表
3. **字体使用系统字体栈**：不引用 Google Fonts 等外部字体服务，使用 CSS 变量中的字体栈
4. **响应式**：使用 CSS Grid / Flexbox，配合 `clamp()` 和媒体查询确保移动端可读
5. **颜色语义**：`--clay` 用于强调和链接，`--olive` 用于正向指标，`--rust` 用于警告/错误
6. **内容充实**：不只是骨架，要填入有意义的内容、数据和示例
7. **文件名**：使用英文小写 + 连字符命名，如 `weekly-status-week11.html`
8. **注释**：CSS 中使用 `/* ── 区块名 ── */` 风格的分隔注释

## 参考示例

`references/examples/` 目录下包含 33 个 html-effectiveness 的完整示例文件，按类别组织：

| 文件 | 类型 |
|------|------|
| `index.html` | 全部示例的索引页 |
| `01-exploration-code-approaches.html` | 方案对比 |
| `02-exploration-visual-designs.html` | 视觉设计方向 |
| `03-code-review-pr.html` | 代码审查 |
| `04-code-understanding.html` | 模块地图 |
| `05-design-system.html` | 设计系统 |
| `06-component-variants.html` | 组件变体 |
| `07-prototype-animation.html` | 动画沙盒 |
| `08-prototype-interaction.html` | 可点击流程 |
| `09-slide-deck.html` | 幻灯片 |
| `10-svg-illustrations.html` | SVG 插图 |
| `11-status-report.html` | 状态报告 |
| `12-incident-report.html` | 事件报告 |
| `13-flowchart-diagram.html` | 流程图 |
| `14-research-feature-explainer.html` | 功能解析 |
| `15-research-concept-explainer.html` | 概念讲解 |
| `16-implementation-plan.html` | 实现计划 |
| `17-pr-writeup.html` | PR 描述 |
| `18-editor-triage-board.html` | 分类看板 |
| `19-editor-feature-flags.html` | 配置编辑器 |
| `20-editor-prompt-tuner.html` | 提示词调试器 |
| `unknowns/` | 11 个额外示例（盲点检查、配色说明、头脑风暴等） |

**使用方式**：当需要生成某种类型的文档时，先读取对应的参考示例文件，理解其布局结构、CSS 样式和内容组织方式，然后参照其风格生成新文档。不要直接复制示例内容，而是借鉴其设计模式和排版风格。

## 输出方式

生成文档后，告知用户：
- 文件已保存的路径
- 可以用浏览器直接打开查看
- 可以打印为 PDF（浏览器打印功能）