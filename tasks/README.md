# Tasks Workflow

这个目录用于统一管理项目任务、按顺序执行、记录版本化日志与归档结果。

## 目录结构

```text
/tasks
  README.md
  archive/
    README.md
  current/
    task-001/
      manifest.yaml
      version.txt
      task.md
      logs/
        v1.0.0/
          run.log
          summary.md
  scripts/
    next-version.ps1
    run-task.ps1
```

## 设计原则

1. 每个任务独立目录：每个任务一份目录，便于跟踪范围、版本和日志。
2. 任务有顺序：通过 `manifest.yaml` 的 `order` 字段控制执行顺序。
3. 任务有版本：每次修改任务文档或实现逻辑，升级 `version.txt`，并新增 `logs/<version>/` 目录。
4. 每次执行都保留日志：每个版本都必须有 `run.log` 和 `summary.md`。
5. 完成后归档：已完成、失败或废弃任务统一移入 `tasks/archive`。

## 版本规则

建议使用 SemVer：`MAJOR.MINOR.PATCH`

- `1.0.0`: 初始版本
- `1.0.1`: 修正错误
- `1.1.0`: 新增功能

## 使用方法

### 1. 新建任务

复制 `tasks/current/task-001` 模板，重命名为 `task-002` 等，并填写：

- `manifest.yaml`
- `task.md`
- `version.txt`

### 2. 用 Copilot 执行单个任务

在 VS Code / Copilot Chat 中输入：

```text
请按 tasks/current/task-001/manifest.yaml 与 task.md 的要求执行任务，
并将过程记录到 tasks/current/task-001/logs/v1.0.0/run.log，
最后输出总结到 tasks/current/task-001/logs/v1.0.0/summary.md。
```

### 3. 版本升级

执行：

```powershell
pwsh ./tasks/scripts/next-version.ps1 -TaskDir "./tasks/current/task-001"
```

脚本会：

- 读取当前版本
- 生成下一版本号
- 创建新的 `logs/<newVersion>/` 目录
- 写入版本日志模板

### 4. 任务归档

任务完成后，将目录移动至：

```text
/tasks/archive/
```

例如：

```text
/tasks/archive/task-001/v1.0.0/
```

## 顺序执行策略

运行脚本：

```powershell
pwsh ./tasks/scripts/run-task.ps1
```

脚本会扫描 `tasks/current/*/manifest.yaml`，按 `order` 排序后输出执行顺序；真正的执行动作由你在 Copilot 中按顺序启动。这样就可以实现“任务串行化 + 版本日志归档”。

## 建议的工作流

1. 任务分目录：`current/` 保存待执行，`archive/` 保存已完成
2. 任务说明写在 `task.md`
3. 执行前先写一个版本：如 `1.0.0`
4. 每次修改时增加版本号并新建日志目录
5. 完成后，将任务目录移入 `archive` 并保留日志

## 质量约束

- 任务必须能追踪“何时执行、谁执行、执行结果是什么”
- 每次版本变更必须保留历史日志，不允许直接覆盖旧版本
- 大型任务拆分为多个小任务，优先顺序执行

---

说明：这个目录是任务管理模板，不直接参与业务代码运行；它是用来组织 Copilot 工作流和版本日志的结构化入口。
