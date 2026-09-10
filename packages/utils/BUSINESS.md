# @efo/utils — 共享工具包设计与使用说明

> 目的：为 monorepo 中所有子项目提供可复用的工具函数、数据转换器和公共平台抽象。此文档参考成熟开源工具库编写，面向使用者与贡献者。

## 设计目标
- 轻量、无副作用：工具函数应为纯函数或可控副作用。
- 明确导出 API：通过 index.ts 集中导出，便于按需引入。
- 可测试：为核心转换函数编写单元测试。
- 文档友好：每个导出函数应有用例和边界条件说明。

## 推荐模块划分
- data/ — 数据转换与聚合（时间序列处理、空值补齐、分桶）
- format/ — 显示格式化（数字、百分比、时间）
- http/ — 请求封装（可选，轻量 fetch wrapper 或 axios adapter）
- chart/ — 图表数据适配器（将后端原始数据转换为 echarts option 或 series 格式）
- misc/ — 辅助工具（深拷贝、节流、防抖）

## 使用示例
- 安装（monorepo 内无需发布）：
  - 在 packages/charts-web 中：import { formatNumber } from '@efo/utils'
- 常见用法：
  - 时间序列归一化：const series = normalizeTimeSeries(rawData, { unit: 'day' })
  - 将后端表数据转换成 echarts series：const option = toEchartsOption(tableData)

## API 导出规范
- index.ts 只导出稳定 API，内部 utils 放在子目录并在 index 中重导出。
- 命名：使用小驼峰，避免默认导出（鼓励命名导出便于 tree-shaking）。

## 测试与质量控制
- 为核心数据转换函数提供单元测试（Jest / Vitest）。
- 在 PR 中运行测试，并确保覆盖关键路径（聚合、边界值）。

## 发布与版本策略
- 当前为私有 workspace 包，通过 monorepo 管理版本。
- 若未来单独发布到 npm：遵循 SemVer，并在 CHANGELOG.md 维护变更历史。

## 扩展与迁移建议
- 若子项目对 HTTP 客户端有偏好（axios vs fetch），提供可插拔 adapter。
- 为 chart/ 目录提供一套 schema 验证（确保 toEchartsOption 的输入输出稳定）。

## 贡献指南（简要）
- 提交功能时：追加单元测试 + 用例文档；遵循导出规范；保持向后兼容。
- 功能拆分：新增模块放入对应目录，更新 packages/utils/index.ts 导出。

## 维护者与联系方式
- 仓库地址： https://github.com/xiaoyunbingaa/efo-chart-web

---
（需要可生成的 API 文档或 TypeDoc 输出时，可添加 TypeDoc 配置并在 CI 中生成 HTML/JSON 文档。）