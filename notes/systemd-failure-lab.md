# systemd Failure Lab

## 实验目标

通过一个独立的 systemd oneshot service，观察 systemd 启动、失败、日志取证、配置修复、daemon-reload 和最终验证的完整过程。

## 故障配置

初始 ExecStart 使用 exit 1。启动后 systemd 报告 Active: failed (Result: exit-code)，并记录 Main process exited, code=exited, status=1/FAILURE。

根因是 ExecStart 启动的 shell 主动执行 exit 1，返回非零退出码，systemd 因此将 service 判定为失败。

## daemon-reload 实验

将 Unit 中的 exit 1 修改为 exit 0，但不执行 daemon-reload。此时磁盘上的 Unit 配置与 systemd 当前加载的配置不一致，启动时仍使用旧配置，并提示需要执行 systemctl daemon-reload。

修改 Unit 文件后需要执行 sudo systemctl daemon-reload，让 systemd 重新读取配置。

## 修复

执行 daemon-reload 后重新启动 service。最终结果为 Result=success、ExecMainCode=0、ExecMainStatus=0、ActiveState=inactive、SubState=dead。

对于 Type=oneshot，inactive (dead) 可以表示一次性任务已经执行完毕，并不等于故障。

## SRE 排障方法

故障 → systemctl status → 确认 failed / exit code / process → journalctl -u → 建立时间线和因果关系 → 定位根因 → 修改配置 → daemon-reload → 重新启动 → Journal + systemctl show 验证。

关键原则：发生了什么，不等于为什么发生。\n