# Tasks Archive

归档目录，一般存放已完成、已失败、已废弃的任务。

建议结构：

```text
/tasks/archive/
  task-001/
    v1.0.0/
      manifest.yaml
      task.md
      logs/
        run.log
        summary.md
```

归档规则：

- 任务成功完成：移入 archive
- 任务失败但需要保留：移入 archive，并写明失败原因
- 任务废弃：移入 archive，并写明废弃理由

归档后应保留：

- 原始任务内容
- 版本号
- 执行日志
- 结论或总结
