# 任务：在 charts-web 中实现 ECharts 示例组件

目标
- 在 packages/charts-web 中新增一个可复用的 ECharts 组件（EChartBarLine.vue），并在 charts 页面展示柱状图 + 折线图示例。

约束
- 使用 echarts 库（已在 devDependencies 中）
- 不改动现有路由结构，仅在 charts 视图中引用组件
- 组件需处理 resize 与卸载 dispose

步骤
1. 在 src/common/components 下创建 EChartBase.vue 或 EChartBarLine.vue
2. 在 charts/index.vue 中按需引入并显示示例数据
3. 启动 dev: npm run dev:charts-web，确认图表渲染
4. 将操作日志写入 logs/v1.0.0/run.log，并在 summary.md 中写执行结果

输出
- logs/v1.0.0/run.log
- logs/v1.0.0/summary.md
