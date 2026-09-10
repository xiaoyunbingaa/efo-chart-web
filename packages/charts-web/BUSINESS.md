# @efo/charts-web — 业务与实现细节

> 专注于交互式图表演示的前端子项目（基于 Vue 3 + Vite + echarts）。文档参照 GitHub 上成熟前端项目风格，面向开发者与维护者。

## 项目定位与目标
- Purpose: 提供可复用的图表展示页面/组件集，作为数据可视化练习与演示的前端模板。
- 受众: 前端开发者、数据可视化工程师、业务方验收人员。

## 核心能力
- 通过 echarts 渲染交互图表（折线、柱状、饼图、地图等）。
- 简单、可扩展的页面结构和路由（支持延迟加载视图）。
- 基于 Pinia 的全局状态管理，方便跨组件数据与配置共享。

## 架构概览
- Entry: src/index.ts — 应用启动与全局插件（Pinia、Router、ElementPlus）挂载点。bootstrap 函数留作异步初始化（配置/鉴权/预取）。
- Layout: src/view/app.vue — 整体布局（EfoHeader、Aside、Main、Footer）。
- Views: src/view/* — 业务页面（guide、charts、notFound）。
- Router: src/router — createRouter + 路由守卫（NProgress 显示加载进度）。
- Store: src/store/globalStore.ts — Pinia 全局状态（userInfo 等）。
- Common: src/common — 公共组件与样式（EfoHeader、可复用 chart 容器、样式变量）。

## 目录结构（核心）
- src/
  - index.ts
  - view/
    - app.vue
    - guide/index.vue
    - charts/index.vue
    - notFound/index.vue
  - router/
    - index.ts
    - main.ts
  - store/
    - globalStore.ts
  - common/
    - components/
    - styles/

## 主要流程与业务逻辑
1. 初始化：index.ts 调用 bootstrap（可异步），然后 createApp(App)，use(router, pinia, element-plus)，mount。
2. 路由：访问页面触发路由守卫，NProgress start/finish；路由使用 defineAsyncComponent 实现视图按需加载，减少首屏体积。
3. 图表渲染：charts 页面应导入 chart 组件（将 echarts 封装为 Vue 组件），组件负责接收 props（配置、数据）并在 mounted 时初始化 ECharts 实例，响应 props 更新进行 setOption。
4. 数据：推荐采用 services 层（或 utils 包）封装数据获取与转换。数据可来自本地 mock、静态 JSON，或远端接口。
5. 状态：globalStore 用于保存用户信息、主题、全局 loading、当前选中图表类型等场景状态。

## 开发指南
- 本地运行（在仓库根）:
  - npm install
  - npm run dev:charts-web
- 或进入子包：
  - cd packages/charts-web
  - npm install
  - npm run dev

## 如何添加新图表组件（推荐流程）
1. 在 src/common/components/ 下创建组件，例如 EChartLine.vue。组件应：
   - 接收 data、options、height、width 等 props；
   - 在 onMounted 初始化 echarts 实例并设置 resize listener；
   - 使用 watch 监听 props 变更并更新 option。
2. 在 src/view/charts 下新增子路由或在现有 charts/index.vue 中导入并演示该组件。
3. 如需数据调用，将请求逻辑放入 packages/utils 或 src/services，返回已格式化的图表数据。
4. 添加文档与示例：在文档目录或组件注释中写明 props、事件与示例代码。

## 建议的代码规范与最佳实践
- 组件：拆小、单一职责、通过 props/emit 通信；样式采用 CSS modules 或 scoped 样式。
- 图表实例管理：组件卸载前 dispose 实例，避免内存泄露。
- 数据处理：在 utils 中提供通用函数（时间线归一化、聚合、缺失值处理）。
- 异步初始化：bootstrap 中做权限检查、远程配置加载（如 feature flags）和必要的预取。

## 可扩展点与优先级建议
1. 封装一个 ChartBase 组件，统一管理 echarts 实例生命周期与 resizing。（高）
2. 完善 packages/utils：数据格式化、HTTP 封装（基于 fetch/axios）、mock 数据生成。（中）
3. 增加 Storybook 或类似工具用于组件可视化与测试。（中）
4. 添加单元/集成测试（组件渲染、store 行为）。（低至中）

## 贡献指南（简要）
- Fork -> 新分支(feature/xxx) -> 提交 -> 发 PR。PR 包含：变更说明、截图或 demo、测试说明。
- 代码风格：遵守项目 ESLint/Prettier 配置（如无则建议统一引入）。

## 联系与维护者
- 仓库: https://github.com/xiaoyunbingaa/efo-chart-web
- 维护者: 仓库贡献者（详见 Git 历史）

---
（需要更细粒度的组件级 API 文档或示例代码时，可对单个组件目录生成 README 或 STORY 文件。）
