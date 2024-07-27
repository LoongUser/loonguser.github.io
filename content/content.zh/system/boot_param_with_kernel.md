---
title: 龙芯系统启动参数
author: Ayden Meng
categories: 2. 系统
toc: true
---

## 龙芯平台常用启动参数

### 增加串口

```bash
console=ttyS0,115200 earlycon=uart,mmio,0x1fe001e0
```

注意:
- `console`即是指控制台输出, `ttyS0`是龙芯默认的串口终端, 波特率是`115200`.
- `earlycon`是用来打印早期`acpi`初始化过程的参数, 在使用`dts`传参时可能不可用.

### 核数限制

```bash
nr_cpus=3 maxcpus=3
```

### 多核调度限制

```bash
isolcpus=0-1,3-5
```

示例可以使`0,1,3,4,5`核不参与调度, 即被孤立.

### 禁用SMP

```bash
nosmp
```

### 串口调试休眠

```bash
no_console_suspend
```

在`s3`和`s4`的过程中, 串口将打印执行流程.

### 设置替代初始化进程

```bash
rdinit=/sbin/my_init
```

```bash
init=/sbin/my_init
```

### 减少内核启动时的输出

```bash
quiet
```

### 设置日志级别

```bash
loglevel=3
```

### 设置根文件系统所在设备

```bash
root=/dev/sda3
```

### 加载ramdisk

```bash
initrd=/path/to/initrd.img
```

### 设置PCI属性

如禁用`msi`

```bash
pci=nomsi
```

### 设置挂载参数

```bash
mount_param=noatime
```

### 设置SELinux启用

```bash
selinux=1
```

### 禁用gpu驱动

```bash
gsgpu.LG100_support=0
```

### 使能lsdc驱动

```bash
lsdc.modeset=1
```

## 内核参数查询
龙芯系统支持的内核启动参数可以使用如下命令查看:

```bash
cat System.map-4.19.0-19-loongson-3 | grep "__setup_str_" | sed 's/.*__setup_str_//g'
```

这些启动参数涵盖了`Linux`内核启动时可以配置的众多方面，从初始化行为到硬件配置。下面是这些参数的一些简要说明及使用样例, 具体以内核源码为准.

初始化相关
- `initcall_blacklist`: 禁止特定的初始化回调函数。
使用示例: 
```bash
initcall_blacklist=my_initcall
```
- `rdinit_setup`: 设置替代初始化进程。
使用示例: 
```bash
rdinit=/sbin/my_init
```
- `init_setup`: 设置初始化进程。
使用示例: 
```bash
init=/sbin/my_init
```
- `loglevel`: 设置日志级别。
使用示例: 
```bash
loglevel=3
```
- `quiet_kernel`: 减少内核启动时的输出。
使用示例: 
```bash
quiet
```
- `debug_kernel`: 开启内核调试。
使用示例: 
```bash
debug
```
- `set_reset_devices`: 设置需要重置的设备列表。
使用示例: 
```bash
reset_devices=pci0000:00/0000:00:01.0
```
- `root_delay_setup`: 设置在尝试挂载根文件系统之前等待的时间。
使用示例: 
```bash
root_delay=10
```
- `fs_names_setup`: 设置文件系统名称。
使用示例: 
```bash
fs_names=xfs,ext4
```
- `root_data_setup`: 设置根文件系统的数据。
使用示例: 
```bash
root_data=root=/dev/sda1 ro
```
- `rootwait_setup`: 设置是否等待根文件系统可用。
使用示例: 
```bash
rootwait
```
- `root_dev_setup`: 设置根设备。
使用示例: 
```bash
root=/dev/sda1
```
- `readwrite`: 标记根文件系统为可读写。
使用示例: 
```bash
rw
```
- `readonly`: 标记根文件系统为只读。
使用示例: 
```bash
ro
```
- `load_ramdisk`: 加载ramdisk。
使用示例: 
```bash
initrd=/path/to/initrd.img
```
- `no_initrd`: 不使用initrd。
使用示例: 
```bash
no_initrd
```
- `retain_initrd_param`: 保留initrd参数。
使用示例: 
```bash
retain_initrd_param
```
- `lpj_setup`: 设置每秒的循环数（loops per jiffy）。
使用示例: 
```bash
lpj=5000000
```
- `early_parse_memmap`: 早期解析内存映射。
使用示例: 
```bash
early_parse_memmap
```
- `early_parse_mem`: 早期解析内存参数。
使用示例: 
```bash
early_parse_mem
```
- `loongson_syscall_disable`: 禁用特定的Loongson系统调用。
使用示例: 
```bash
loongson_syscall_disable=1
```
- `rd_size_early`: 设置早期的根设备大小。
使用示例: 
```bash
rd_size_early=512M
```
- `rd_start_early`: 设置早期的根设备起始位置。
使用示例: 
```bash
rd_start_early=1024
```
- `early_initrd`: 设置早期的initrd。
使用示例: 
```bash
early_initrd=/path/to/early-initrd.img
```
- `debug_alt`: 启用备用调试选项。
使用示例: 
```bash
debug_alt
```
- `set_pv_time`: 设置PV（Para-virtualized）时间。
使用示例: 
```bash
set_pv_time
```
- `set_pv_ipi`: 设置PV IPI（Interrupt Request）。
使用示例: 
```bash
set_pv_ipi
```
- `coredump_filter_setup`: 设置core dump过滤器。
使用示例: 
```bash
coredump_filter=0x00000000
```
- `oops_setup`: 设置Oops异常处理。
使用示例: 
```bash
oops=panic
```
- `mitigations_parse_cmdline`: 解析命令行中的缓解措施。
使用示例: 
```bash
mitigations=auto
```
- `strict_iomem`: 启用严格的I/O内存管理。
使用示例: 
```bash
strict_iomem=1
```
- `reserve_setup`: 预留内存区域。
使用示例: 
```bash
reserve=128M
```
- `file_caps_disable`: 禁用文件能力。
使用示例: 
```bash
file_caps_disabled
```
- `setup_print_fatal_signals`: 设置打印致命信号。
使用示例: 
```bash
print_fatal_signals=1
```
- `reboot_setup`: 设置重启行为。
使用示例: 
```bash
reboot=k
```
- `setup_schedstats`: 设置调度统计。
使用示例: 
```bash
schedstats
```
- `setup_relax_domain_level`: 设置放松域级别。
使用示例: 
```bash
relax_domain_level=1
```
- `sched_debug_setup`: 设置调度调试。
使用示例: 
```bash
sched_debug
```
- `housekeeping_isolcpus_setup`: 设置隔离CPU。
使用示例: 
```bash
isolcpus=0-3
```
- `housekeeping_nohz_full_setup`: 设置完全nohz（no-Hertz）行为。
使用示例: 
```bash
nohz_full
```
- `mem_sleep_default_setup`: 设置内存睡眠默认行为。
使用示例: 
```bash
mem_sleep_default=deep
```
- `nohibernate_setup`: 禁用休眠。
使用示例: 
```bash
nohibernate
```
- `resumedelay_setup`: 设置恢复延迟。
使用示例: 
```bash
resumedelay=10
```
- `resumewait_setup`: 设置恢复等待时间。
使用示例: 
```bash
resumewait=5
```
- `hibernate_setup`: 设置休眠行为。
使用示例: 
```bash
resume=/dev/mapper/my-swap
```
- `resume_setup`: 设置恢复行为。
使用示例: 
```bash
resume=/dev/mapper/my-swap
```
- `resume_offset_setup`: 设置恢复偏移。
使用示例: 
```bash
resume_offset=1024
```
- `noresume_setup`: 禁用恢复。
使用示例: 
```bash
noresume
```
- `keep_bootcon_setup`: 保持引导控制台设置。
使用示例: 
```bash
keep_bootcon
```
- `console_suspend_disable`: 禁用控制台挂起。
使用示例: 
```bash
console_suspend_disable
```
- `console_setup`: 设置控制台。
使用示例: 
```bash
console=ttyS0,115200
```
- `console_msg_format_setup`: 设置控制台消息格式。
使用示例: 
```bash
console_msg_format=%t %l %u: %m
```
- `ignore_loglevel_setup`: 忽略日志级别设置。
使用示例: 
```bash
ignore_loglevel
```
- `log_buf_len_setup`: 设置日志缓冲区长度。
使用示例: 
```bash
log_buf_len=16M
```
- `control_devkmsg`: 控制/dev/kmsg。
使用示例: 
```bash
devkmsg=on
```
- `irq_affinity_setup`: 设置中断亲和性。
使用示例: 
```bash
irqaffinity=balanced
```
- `setup_forced_irqthreads`: 强制使用IRQ线程。
使用示例: 
```bash
forced_irqthread
```
- `irqpoll_setup`: 设置IRQ轮询模式。
使用示例: 
```bash
irqpoll
```
- `irqfixup_setup`: 设置IRQ修复。
使用示例: 
```bash
irqfixup
```
- `noirqdebug_setup`: 禁用IRQ调试。
使用示例: 
```bash
noirqdebug
```
- `early_cma`: 设置早期CMA（Contiguous Memory Allocator）。
使用示例: 
```bash
early_cma=128M
```
- `setup_io_tlb_npages`: 设置I/O TLB（Translation Lookaside Buffer）页面数量。
使用示例: 
```bash
io_tlb_npages=128
```
- `setup_hrtimer_hres`: 设置高分辨率定时器。
使用示例: 
```bash
hrtimer_hres=1
```
- `ntp_tick_adj_setup`: 设置NTP时钟调整。
使用示例: 
```bash
ntp_tick_adj=1
```
- `boot_override_clock`: 覆盖时钟。
使用示例: 
```bash
boot_override_clock
```
- `boot_override_clocksource`: 覆盖时钟源。
使用示例: 
```bash
boot_override_clocksource=pit
```
- `skew_tick`: 设置skew tick。
使用示例: 
```bash
skew_tick
```
- `setup_tick_nohz`: 设置nohz（no-Hertz）行为。
使用示例: 
```bash
tick_nohz=1
```
- `maxcpus`: 设置最大CPU数量。
使用示例: 
```bash
maxcpus=8
```
- `nrcpus`: 设置CPU数量。
使用示例: 
```bash
nrcpus=4
```
- `nosmp`: 禁用SMP（Symmetric Multi-Processing）。
使用示例: 
```bash
nosmp
```
- `cgroup_disable`: 禁用cgroup。
使用示例: 
```bash
cgroup_disable
```
- `cgroup_no_v1`: 禁用cgroup v1。
使用示例: 
```bash
cgroup_no_v1
```
- `audit_backlog_limit_set`: 设置审计队列限制。
使用示例: 
```bash
audit_backlog_limit=1024
```
- `audit_enable`: 启用审计。
使用示例: 
```bash
audit=1
```
- `hung_task_panic_setup`: 设置Hung Task Panic行为。
使用示例: 
```bash
hung_task_panic
```
- `softlockup_all_cpu_backtrace_setup`: 设置Soft Lockup All CPU Backtrace。
使用示例: 
```bash
softlockup_all_cpu_backtrace
```
- `nosoftlockup_setup`: 禁用软锁死检测。
使用示例: 
```bash
nosoftlockup
```
- `nowatchdog_setup`: 禁用Watchdog。
使用示例: 
```bash
nowatchdog
```
- `softlockup_panic_setup`: 设置Soft Lockup Panic行为。
使用示例: 
```bash
softlockup_panic
```
- `delayacct_setup_disable`: 禁用Delay Account。
使用示例: 
```bash
delayacct_disable
```
- `set_graph_max_depth_function`: 设置图的最大深度。
使用示例: 
```bash
graph_max_depth_function=10
```
- `set_graph_notrace_function`: 设置不跟踪函数。
使用示例: 
```bash
graph_notrace_function=my_function
```
- `set_graph_function`: 设置跟踪函数。
使用示例: 
```bash
graph_function=my_function
```
- `set_ftrace_filter`: 设置ftrace过滤器。
使用示例: 
```bash
ftrace_filter=my_function
```
- `set_ftrace_notrace`: 设置ftrace不跟踪。
使用示例: 
```bash
ftrace_notrace=my_function
```
- `set_tracing_thresh`: 设置跟踪阈值。
使用示例: 
```bash
tracing_thresh=1
```
- `set_buf_size`: 设置缓冲区大小。
使用示例: 
```bash
buf_size=16K
```
- `set_tracepoint_printk`: 设置tracepoint printk。
使用示例: 
```bash
tracepoint_printk=1
```
- `set_trace_boot_clock`: 设置跟踪启动时钟。
使用示例: 
```bash
trace_boot_clock=1
```
- `set_trace_boot_options`: 设置跟踪启动选项。
使用示例: 
```bash
trace_boot_options=trace
```
- `boot_alloc_snapshot`: 设置启动分配快照。
使用示例: 
```bash
boot_alloc_snapshot=1
```
- `stop_trace_on_warning`: 设置在警告时停止跟踪。
使用示例: 
```bash
stop_trace_on_warning
```
- `set_ftrace_dump_on_oops`: 设置在Oops时转储ftrace。
使用示例: 
```bash
ftrace_dump_on_oops
```
- `set_cmdline_ftrace`: 设置命令行ftrace。
使用示例: 
```bash
cmdline_ftrace=1
```
- `enable_stacktrace`: 启用栈跟踪。
使用示例: 
```bash
enable_stacktrace
```
- `setup_trace_event`: 设置跟踪事件。
使用示例: 
```bash
trace_event=my_event
```
- `setup_elfcorehdr`: 设置ELF Core Header。
使用示例: 
```bash
elfcorehdr
```
- `set_hashdist`: 设置哈希分布。
使用示例: 
```bash
hashdist=1
```
- `cmdline_parse_movablecore`: 解析movablecore命令行。
使用示例: 
```bash
movablecore=1
```
- `cmdline_parse_kernelcore`: 解析kernelcore命令行。
使用示例: 
```bash
kernelcore=1
```
- `setup_numa_zonelist_order`: 设置NUMA区域列表顺序。
使用示例: 
```bash
numa_zonelist_order=node,zone
```
- `set_mminit_loglevel`: 设置内存初始化日志级别。
使用示例: 
```bash
mminit_loglevel=2
```
- `percpu_alloc_setup`: 设置per-CPU分配。
使用示例: 
```bash
percpu_alloc=1
```
- `setup_slab_nomerge`: 设置slab不合并。
使用示例: 
```bash
slab_nomerge
```
- `slub_nomerge`: 设置SLUB不合并。
使用示例: 
```bash
slub_nomerge
```
- `disable_randmaps`: 禁用随机映射。
使用示例: 
```bash
disable_randmaps
```
- `cmdline_parse_stack_guard_gap`: 解析堆栈保护间隙。
使用示例: 
```bash
stack_guard_gap=16
```
- `early_memblock`: 设置早期内存块。
使用示例: 
```bash
early_memblock=1
```
- `hugetlb_default_setup`: 设置 HugeTLB 默认配置。
使用示例: 
```bash
hugetlb_default=always
```
- `hugetlb_nrpages_setup`: 设置 HugeTLB 页面数量。
使用示例: 
```bash
hugetlb_nrpages=128
```
- `setup_numabalancing`: 设置NUMA平衡。
使用示例: 
```bash
numabalancing=1
```
- `early_page_poison_param`: 设置早期页面中毒参数。
使用示例: 
```bash
early_page_poison=1
```
- `setup_slub_memcg_sysfs`: 设置SLUB memcg sysfs。
使用示例: 
```bash
slub_memcg_sysfs
```
- `setup_slub_min_objects`: 设置SLUB最小对象数量。
使用示例: 
```bash
slub_min_objects=128
```
- `setup_slub_max_order`: 设置SLUB最大顺序。
使用示例: 
```bash
slub_max_order=6
```
- `setup_slub_min_order`: 设置SLUB最小顺序。
使用示例: 
```bash
slub_min_order=3
```
- `cmdline_parse_movable_node`: 解析movable node命令行。
使用示例: 
```bash
movable_node=1
```
- `setup_memhp_default_state`: 设置内存热插拔默认状态。
使用示例: 
```bash
memhp_default_state=off
```
- `parse_memtest`: 解析内存测试命令行参数。
使用示例: 
```bash
memtest=on
```
- `setup_transparent_hugepage`: 设置透明 Huge Page。
使用示例: 
```bash
transparent_hugepage=always
```
- `enable_swap_account`: 启用交换分区会计。
使用示例: 
```bash
swapaccount=1
```
- `cgroup_memory`: 设置cgroup内存。
使用示例: 
```bash
cgroup_memory=1
```
- `set_dhash_entries`: 设置dhash entries。
使用示例: 
```bash
dhash_entries=1024
```
- `set_ihash_entries`: 设置ihash entries。
使用示例: 
```bash
ihash_entries=1024
```
- `set_mphash_entries`: 设置mphash entries。
使用示例: 
```bash
mphash_entries=1024
```
- `set_mhash_entries`: 设置mhash entries。
使用示例: 
```bash
mhash_entries=1024
```
- `choose_lsm`: 选择LSM（Linux Security Module）。
使用示例: 
```bash
choose_lsm=selinux
```
- `checkreqprot_setup`: 设置检查请求保护。
使用示例: 
```bash
checkreqprot=1
```
- `selinux_enabled_setup`: 设置SELinux启用。
使用示例: 
```bash
selinux=1
```
- `enforcing_setup`: 设置强制模式。
使用示例: 
```bash
enforcing=1
```
- `tomoyo_trigger_setup`: 设置Tomoyo触发器。
使用示例: 
```bash
tomoyo_trigger=1
```
- `tomoyo_loader_setup`: 设置Tomoyo加载器。
使用示例: 
```bash
tomoyo_loader=1
```
- `apparmor_enabled_setup`: 设置AppArmor启用。
使用示例: 
```bash
apparmor=1
```
- `integrity_audit_setup`: 设置完整性审计。
使用示例: 
```bash
integrity=1
```
- `ca_keys_setup`: 设置CA密钥。
使用示例: 
```bash
ca_keys=/etc/ssl/certs/ca-certificates.crt
```
- `elevator_setup`: 设置电梯算法。
使用示例: 
```bash
elevator=cfq
```
- `force_gpt_fn`: 设置强制GPT功能。
使用示例: 
```bash
force_gpt_fn=1
```
- `ddebug_setup_query`: 设置ddebug查询。
使用示例: 
```bash
ddebug=on
```
- `pci_setup`: 设置PCI。
使用示例: 
```bash
pci=nomsi
```
- `pcie_port_pm_setup`: 设置PCIe端口PM。
使用示例: 
```bash
pcie_port_pm=1
```
- `pcie_port_setup`: 设置PCIe端口。
使用示例: 
```bash
pcie_port=1
```
- `pcie_aspm_disable`: 禁用PCIe ASPM。
使用示例: 
```bash
pcie_aspm=off
```
- `pcie_pme_setup`: 设置PCIe PME。
使用示例: 
```bash
pcie_pme=1
```
- `no_scroll`: 禁用滚动。
使用示例: 
```bash
no_scroll
```
- `text_mode`: 设置文本模式。
使用示例: 
```bash
text
```
- `video_setup`: 设置视频。
使用示例: 
```bash
video=vesafb:mode=1024x768
```
- `fb_console_setup`: 设置帧缓冲控制台。
使用示例: 
```bash
fbcon=map:vesa
```
- `acpi_force_32bit_fadt_addr`: 强制使用32位FADT地址。
使用示例: 
```bash
acpi_force_32bit_fadt_addr
```
- `acpi_force_table_verification_setup`: 设置ACPI表验证。
使用示例: 
```bash
acpi_force_table_verification
```
- `acpi_parse_apic_instance`: 解析APIC实例。
使用示例: 
```bash
acpi_parse_apic_instance
```
- `osi_setup`: 设置OSI（Operating System Identification）。
使用示例: 
```bash
osi=Linux
```
- `acpi_disable_return_repair`: 禁用ACPI返回修复。
使用示例: 
```bash
acpi_disable_return_repair
```
- `acpi_no_static_ssdt_setup`: 禁用静态SSDT。
使用示例: 
```bash
acpi_no_static_ssdt
```
- `acpi_enforce_resources_setup`: 设置ACPI资源强制。
使用示例: 
```bash
acpi_enforce_resources
```
- `acpi_no_auto_serialize_setup`: 禁用ACPI自动序列化。
使用示例: 
```bash
acpi_no_auto_serialize
```
- `acpi_os_name_setup`: 设置ACPI OS名称。
使用示例: 
```bash
acpi_os_name=Linux
```
- `setup_acpi_rsdp`: 设置ACPI RSDP。
使用示例: 
```bash
acpi_rsdp=1
```
- `acpi_backlight`: 设置ACPI背光。
使用示例: 
```bash
acpi_backlight=vendor
```
- `acpi_irq_balance_set`: 设置ACPI IRQ平衡。
使用示例: 
```bash
acpi_irq_balance=1
```
- `acpi_irq_nobalance_set`: 设置ACPI IRQ不平衡。
使用示例: 
```bash
acpi_irq_nobalance=1
```
- `acpi_irq_pci`: 设置ACPI IRQ PCI。
使用示例: 
```bash
acpi_irq_pci=1
```
- `acpi_irq_isa`: 设置ACPI IRQ ISA。
使用示例: 
```bash
acpi_irq_isa=1
```
- `acpi_gpe_set_masked_gpes`: 设置ACPI GPE屏蔽。
使用示例: 
```bash
acpi_gpe_masked_gpes=1
```
- `disable_acpi_watchdog`: 禁用ACPI Watchdog。
使用示例: 
```bash
disable_acpi_watchdog
```
- `disable_acpi_memory_hotplug`: 禁用ACPI内存热插拔。
使用示例: 
```bash
disable_acpi_memory_hotplug
```
- `pnp_setup_reserve_mem`: 设置PNP预留内存。
使用示例: 
```bash
pnp_setup_reserve_mem
```
- `pnp_setup_reserve_io`: 设置PNP预留I/O。
使用示例: 
```bash
pnp_setup_reserve_io
```
- `pnp_setup_reserve_dma`: 设置PNP预留DMA。
使用示例: 
```bash
pnp_setup_reserve_dma
```
- `pnp_setup_reserve_irq`: 设置PNP预留IRQ。
使用示例: 
```bash
pnp_setup_reserve_irq
```
- `pnpacpi_setup`: 设置PNP ACPI。
使用示例: 
```bash
pnpacpi_setup
```
- `sysrq_always_enabled_setup`: 设置sysrq始终启用。
使用示例: 
```bash
sysrq_always_enabled
```
- `param_setup_earlycon`: 设置早期控制台参数。
使用示例: 
```bash
earlycon
```
- `parse_trust_cpu`: 解析信任CPU参数。
使用示例: 
```bash
trust_cpu
```
- `iommu_set_def_domain_type`: 设置默认IOMMU域类型。
使用示例: 
```bash
iommu_set_def_domain_type=1
```
- `la_iommu_setup`: 设置LA IOMMU。
使用示例: 
```bash
la_iommu=1
```
- `deferred_probe_timeout_setup`: 设置延迟探测超时。
使用示例: 
```bash
deferred_probe_timeout=10
```
- `mount_param`: 设置挂载参数。
使用示例: 
```bash
mount_param=noatime
```
- `pd_ignore_unused_setup`: 设置PD忽略未使用。
使用示例: 
```bash
pd_ignore_unused
```
- `stmmac_cmdline_opt`: 设置STMMAC命令行选项。
使用示例: 
```bash
stmmac_cmdline_opt=1
```
- `cpuidle_sysfs_setup`: 设置CPUidle sysfs。
使用示例: 
```bash
cpuidle_sysfs=1
```
- `efivar_ssdt_setup`: 设置EFI变量SSDT。
使用示例: 
```bash
efivar_ssdt=1
```
- `parse_efi_cmdline`: 解析EFI命令行。
使用示例: 
```bash
parse_efi_cmdline=1
```
- `setup_noefi`: 设置无EFI。
使用示例: 
```bash
noefi
```
- `parse_ras_param`: 解析RAS参数。
使用示例: 
```bash
parse_ras_param=1
```
- `netdev_boot_setup`: 设置网络设备引导。
使用示例: 
```bash
netdev_boot_setup=1
```
- `set_thash_entries`: 设置THash entries。
使用示例: 
```bash
thash_entries=1024
```
- `set_tcpmhash_entries`: 设置TCP mhash entries。
使用示例: 
```bash
tcpmhash_entries=1024
```
- `set_uhash_entries`: 设置UHash entries。
使用示例: 
```bash
uhash_entries=1024
```
- `debug_boot_weak_hash_enable`: 启用弱哈希调试。
使用示例: 
```bash
debug_boot_weak_hash_enable
```

这些参数覆盖了从低级别的硬件配置到高级别的系统行为。根据你的具体需求，你可以使用这些参数来微调内核的启动过程和配置。

## 模块参数查看

可以用如下命令:

```bash
root@loongson-pc:/lib/modules/4.19.0-19-loongson-3# modinfo kernel/drivers/gpu/drm/gsgpu/gpu/gsgpu.ko

......
name:           gsgpu
parm:           LG100_support:LG100 support (1 = enabled (default), 0 = disabled (int)
......
```
