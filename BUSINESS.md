# efo-chart-web — 业务与代码梳理

## 概览
- 单体 monorepo（npm workspaces）：packages/charts-web、packages/utils。
- 目标：chart 练习/演示工程（使用 echarts 做可视化演示）。

## 技术栈
- 前端：Vue 3 (Vite)、Element Plus、Pinia、vue-router、echarts
- 构建：Vite（packages/charts-web/build/vite.config.ts）

## 项目结构（重要目录）
- package.json（仓库根）
  - workspaces: packages/charts-web, packages/utils
  - 脚本：`dev:charts-web`（运行 charts-web 子包的 dev）
- packages/charts-web
  - package.json：dev/build 脚本，依赖项（echarts、element-plus、pinia 等）
  - src/index.ts：应用入口，挂载 router、pinia，加载 App 组件
  - src/view：视图集合
    - app.vue：主布局（EfoHeader、Aside、router-view、Footer）
    - guide/index.vue：引导页视图
    - charts/index.vue：图表页（应显示 echarts 示例）
    - notFound/index.vue：404
  - src/router：路由配置
    - router/index.ts：创建 router，集成 NProgress（路由进度条）
    - router/main.ts：定义路由表（/, /charts, NotFound）
  - src/store：Pinia 全局状态
    - globalStore.ts：全局 store，目前仅有 userInfo 字段（boolean）
  - src/common：公共组件与样式（components、styles）
- packages/utils
  - package.json：占位工具包，当前无实现（主入口 index.js）

## 主要代码逻辑与业务逻辑
- 启动流程
  1. 入口 packages/charts-web/src/index.ts 调用 bootstrap（目前为空）并创建 Vue 应用。
  2. 安装 router（含路由守卫）和 Pinia 后挂载到 #vue-app。
- 路由与导航
  - 路由表很简单：引导页（/）、图表页（/charts）和 404。路由守卫使用 NProgress 显示页面加载进度。
- 状态管理
  - 使用 Pinia，globalStore 持有基础用户信息标识（userInfo），当前未实现权限/鉴权流程。
- 视图与组件
  - App.vue 实现布局骨架，依赖公共组件 EfoHeader；主要内容由 router-view 填充。
  - charts 页面用于展示 echarts，可在该视图中挂载具体图表组件并从 utils 或远端获取数据。
- 工具包（packages/utils）
  - 当前为空：预留给通用函数、数据处理、格式化、封装请求等。

## 数据流（高层）
- 目前没有后端/API 集成，图表数据显然为本地或静态示例数据。真实使用场景应：
  1. 在 charts 视图或其子组件中调用数据源（本地 mock 或远端 API）；
  2. 处理/格式化数据（可放入 utils）；
  3. 使用 echarts 渲染并响应用户交互。

## 运行方式
- 根目录：npm install
- 启动 Charts 开发服务器：npm run dev:charts-web
- 或进入 packages/charts-web：npm install && npm run dev

## 已知的简要实现/占位点
- src/index.ts 中的 bootstrap 是空的（可用于异步初始化，如读取配置、预取数据、国际化初始化等）。
- globalStore 仅有 userInfo 占位字段，未实现登录/用户信息管理。
- packages/utils 暂无实现，建议把通用工具放入此包并在 charts-web 中引用。
- common/components 中的 EfoHeader 暂未查看实现，需确认是否包含导航/登出等业务按钮。

## 建议/下一步（业务与代码）
1. 补全 charts 页面：实现至少一个 echarts 示例组件并封装数据加载流程。
2. 在 bootstrap 中实现异步初始化：配置加载、权限检查、全局错误处理等。
3. 扩展 globalStore：用户信息、权限、主题设置、全局 loading 状态。
4. 实现 packages/utils：常用数据处理、请求封装、日期/数值格式化、图表数据转换。
5. 增加文档：README 扩展、组件使用说明、路由与状态设计说明。

---
（此文档基于当前仓库文件快照生成，若需要更详尽的函数级、组件级梳理或自动提取 API/组件依赖关系，可按需继续深入。）
