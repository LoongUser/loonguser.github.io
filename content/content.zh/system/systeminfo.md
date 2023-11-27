---
title: 系统下查看一些信息
author: Ayden Meng
categories: 2. 系统
toc: true
---

## 1. 查看系统版本

```
[root@mxd mxd]# cat /etc/os-release
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
PRIVACY_POLICY_URL="https://terms.archlinux.org/docs/privacy-policy/"
LOGO=archlinux-logo
```

## 2. 查看内核版本

```
[root@mxd mxd]# uname -a
Linux mxd 6.5.0-4 #1 SMP PREEMPT Thu, 31 Aug 2023 09:38:08 +0000 loongarch64 GNU/Linux
```

## 3. 查看固件版本

```
[root@mxd mxd]# cat /sys/firmware/loongson/boardinfo
BIOS Information
Vendor			: Loongson
Version			: Loongson-UDK2018-V4.0.05494-stable202305
ROM Size		: 4096 KB
Release Date		: 07/10/23 18:05:47

Board Information
Manufacturer		: Loongson
Board Name		: Loongson-LS3A6000-7A2000-1w-EVB-V1.21
Family			: LOONGSON64
```

## 4. 查看ip

```
[root@mxd mxd]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s3f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:55:7b:b5:7d:f7 brd ff:ff:ff:ff:ff:ff
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether ce:38:b3:df:3b:23 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.13/23 brd 192.168.1.255 scope global dynamic noprefixroute enp2s0
       valid_lft 40218sec preferred_lft 40218sec
    inet6 fe80::80b6:e9f0:ab6c:e9c5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:4e:12:01:c7 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```

## 5. 查看pci设备

```
[root@mxd mxd]# lspci 
00:00.0 Host bridge: Loongson Technology LLC Hyper Transport Bridge Controller
00:00.1 Host bridge: Loongson Technology LLC Hyper Transport Bridge Controller (rev 01)
00:00.2 Host bridge: Loongson Technology LLC Device 7a20 (rev 01)
00:00.3 Host bridge: Loongson Technology LLC Device 7a30
00:03.0 Ethernet controller: Loongson Technology LLC Device 7a13
00:04.0 USB controller: Loongson Technology LLC OHCI USB Controller (rev 02)
00:04.1 USB controller: Loongson Technology LLC EHCI USB Controller (rev 02)
00:05.0 USB controller: Loongson Technology LLC OHCI USB Controller (rev 02)
00:05.1 USB controller: Loongson Technology LLC EHCI USB Controller (rev 02)
00:06.0 Multimedia video controller: Loongson Technology LLC Device 7a25 (rev 01)
00:06.1 VGA compatible controller: Loongson Technology LLC Device 7a36 (rev 02)
00:06.2 Audio device: Loongson Technology LLC Device 7a37
00:07.0 Audio device: Loongson Technology LLC HDA (High Definition Audio) Controller
00:08.0 SATA controller: Loongson Technology LLC Device 7a18
00:09.0 PCI bridge: Loongson Technology LLC Device 7a49
00:0a.0 PCI bridge: Loongson Technology LLC Device 7a39
00:0b.0 PCI bridge: Loongson Technology LLC Device 7a39
00:0c.0 PCI bridge: Loongson Technology LLC Device 7a39
00:0d.0 PCI bridge: Loongson Technology LLC Device 7a49
00:0f.0 PCI bridge: Loongson Technology LLC Device 7a69
00:10.0 PCI bridge: Loongson Technology LLC Device 7a59
00:13.0 PCI bridge: Loongson Technology LLC Device 7a59
00:16.0 System peripheral: Loongson Technology LLC Device 7a1b
00:19.0 USB controller: Loongson Technology LLC Device 7a34
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
05:00.0 Non-Volatile memory controller: Shenzhen Longsys Electronics Co., Ltd. SM2263EN/SM2263XT-based OEM SSD (rev 03)
07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Oland [Radeon HD 8570 / R5 430 OEM / R7 240/340 / Radeon 520 OEM] (rev 87)
07:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Oland/Hainan/Cape Verde/Pitcairn HDMI Audio [Radeon HD 7000 Series]
```

### 5.1 详细查看某pci设备使用的驱动

其中`07:00.0`是上面左侧显示的一段数字, 根据描述, `07:00.0`那一行指一个`VGA兼容设备`, 换句话说是指显示设备, 业内叫做`显卡`

如下, 该显卡使用的驱动是:`radeon`

```
[root@mxd mxd]# lspci  -vvv -s 07:00.0 2>/dev/null | grep driver -A 2
	Kernel driver in use: radeon
```

## 6. 查看系统下某驱动是否加载

如下显示:

第1列：表示模块的名称，如`radeon`表示`radeon`模块。

第2列：表示模块的大小，如`1687552`表示`radeon`模块的大小为`1687552`字节。

第3列：表示依赖模块的个数，如`74`表示`radeon`有`74`个依赖模块。

第4列：表示依赖模块的内容, 如`drm_suballoc_helper`依赖于`amdgpu`,`radeon`俩模块

```
[root@mxd mxd]# lsmod  | grep radeon
radeon               1687552  74
drm_suballoc_helper    49152  2 amdgpu,radeon
drm_ttm_helper         49152  2 amdgpu,radeon
ttm                   131072  3 amdgpu,radeon,drm_ttm_helper
drm_display_helper    229376  2 amdgpu,radeon
drm_kms_helper        229376  5 drm_dma_helper,drm_display_helper,amdgpu,radeon,loongson
```

## 7. 查看系统启动log

当不确定开发人员需要哪些信息时, 请优先将此信息给出.

```
[root@mxd mxd]# dmesg
[    2.248064] ATOM BIOS: C57701
[    2.248176] radeon 0000:07:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
[    2.248179] radeon 0000:07:00.0: GTT: 2048M 0x0000000080000000 - 0x00000000FFFFFFFF
[    2.248180] [drm] Detected VRAM RAM=2048M, BAR=256M
[    2.248182] [drm] RAM width 64bits DDR
[    2.248289] [drm] radeon: 2048M of VRAM memory ready
[    2.248292] [drm] radeon: 2048M of GTT memory ready.
[    2.248300] [drm] Loading oland Microcode
[    2.249595] [drm] Internal thermal controller with fan control
[    2.259143] [drm] radeon: dpm initialized
[    2.261098] [drm] GART: num cpu pages 131072, num gpu pages 524288
[    2.261845] [drm] PCIE gen 3 link speeds already enabled
[    2.328096] [drm] PCIE GART of 2048M enabled (table at 0x0000000000168000).
[    2.328289] radeon 0000:07:00.0: WB enabled
[    2.328291] radeon 0000:07:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00
[    2.328293] radeon 0000:07:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04
[    2.328294] radeon 0000:07:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08
[    2.328296] radeon 0000:07:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c
[    2.328297] radeon 0000:07:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10
[    2.343597] radeon 0000:07:00.0: fence driver on ring 5 use gpu addr 0x0000000000075a18
[    2.343678] radeon 0000:07:00.0: radeon: MSI limited to 32-bit
......
......
```

或:

```
[root@mxd mxd]# journalctl  -b -0
10月 11 09:16:21 mxd kernel: Linux version 6.5.0-4 (linux@archlinux) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU Binutils)>
10月 11 09:16:21 mxd kernel: 64-bit Loongson Processor probed (LA664 Core)
10月 11 09:16:21 mxd kernel: CPU0 revision is: 0014d000 (Loongson-64bit)
10月 11 09:16:21 mxd kernel: FPU0 revision is: 00000000
10月 11 09:16:21 mxd kernel: efi: EFI v2.7 by EDK II
10月 11 09:16:21 mxd kernel: efi: ACPI 2.0=0xfa3b0000 SMBIOS 3.0=0xfe5b0000 INITRD=0xfa2d0e98 MEMRESERVE=0xfa2d0d98 ME>
10月 11 09:16:21 mxd kernel: ACPI: Early table checksum verification disabled
10月 11 09:16:21 mxd kernel: ACPI: RSDP 0x00000000FA3B0000 000024 (v02 LOONGS)
10月 11 09:16:21 mxd kernel: ACPI: XSDT 0x00000000FA3A0000 000064 (v01 LOONGS LOONGSON 00000002      01000013)
10月 11 09:16:21 mxd kernel: ACPI: FACP 0x00000000FA370000 0000F4 (v03 LOONGS LOONGSON 00000002 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: DSDT 0x00000000FA340000 002676 (v02 LOONGS LOONGSON 00000002 INTL 20180629)
10月 11 09:16:21 mxd kernel: ACPI: FACS 0x00000000FA380000 000040
10月 11 09:16:21 mxd kernel: ACPI: APIC 0x00000000FA390000 0000FA (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: IVRS 0x00000000FA360000 00004C (v01 LARCH  LOONGSON 00000001 LIUX 00000001)
10月 11 09:16:21 mxd kernel: ACPI: MCFG 0x00000000FA350000 00003C (v01 LOONGS LOONGSON 00000001 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: SRAT 0x00000000FA330000 000100 (v02 LOONGS LOONGSON 00000002 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: SLIT 0x00000000FA320000 00002D (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: VIAT 0x00000000FA310000 00002C (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
10月 11 09:16:21 mxd kernel: ACPI: PPTT 0x00000000FA300000 000128 (v03 LOONGS LOONGSON 00000002 LIUX 01000013)
......
......
```

两种打印不一致是因为`dmesg`命令显示的内容是从2秒开始的, 前面的内容被冲掉了, 而`journalctl`显示的内容则更完整.

### 7.1 查看系统上一次的启动log

```
[root@mxd mxd]# journalctl  -b -1
9月 06 16:19:37 mxd kernel: Linux version 6.5.0-4 (linux@archlinux) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU Binutils) >
9月 06 16:19:37 mxd kernel: 64-bit Loongson Processor probed (LA664 Core)
9月 06 16:19:37 mxd kernel: CPU0 revision is: 0014d000 (Loongson-64bit)
9月 06 16:19:37 mxd kernel: FPU0 revision is: 00000000
9月 06 16:19:37 mxd kernel: efi: EFI v2.7 by EDK II
9月 06 16:19:37 mxd kernel: efi: ACPI 2.0=0xfa3b0000 SMBIOS 3.0=0xfe5b0000 INITRD=0xfa2d0e98 MEMRESERVE=0xfa2d0d18 MEM>
9月 06 16:19:37 mxd kernel: ACPI: Early table checksum verification disabled
9月 06 16:19:37 mxd kernel: ACPI: RSDP 0x00000000FA3B0000 000024 (v02 LOONGS)
9月 06 16:19:37 mxd kernel: ACPI: XSDT 0x00000000FA3A0000 000064 (v01 LOONGS LOONGSON 00000002      01000013)
9月 06 16:19:37 mxd kernel: ACPI: FACP 0x00000000FA370000 0000F4 (v03 LOONGS LOONGSON 00000002 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: DSDT 0x00000000FA340000 002676 (v02 LOONGS LOONGSON 00000002 INTL 20180629)
9月 06 16:19:37 mxd kernel: ACPI: FACS 0x00000000FA380000 000040
9月 06 16:19:37 mxd kernel: ACPI: APIC 0x00000000FA390000 0000FA (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: IVRS 0x00000000FA360000 00004C (v01 LARCH  LOONGSON 00000001 LIUX 00000001)
9月 06 16:19:37 mxd kernel: ACPI: MCFG 0x00000000FA350000 00003C (v01 LOONGS LOONGSON 00000001 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: SRAT 0x00000000FA330000 000100 (v02 LOONGS LOONGSON 00000002 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: SLIT 0x00000000FA320000 00002D (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: VIAT 0x00000000FA310000 00002C (v01 LOONGS LOONGSON 00000002 LIUX 01000013)
9月 06 16:19:37 mxd kernel: ACPI: PPTT 0x00000000FA300000 000128 (v03 LOONGS LOONGSON 00000002 LIUX 01000013)
......
......
```


## 8. 查看磁盘挂载信息

```
[root@mxd mxd]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 931.5G  0 disk
├─sda1        8:1    0   500M  0 part
├─sda2        8:2    0     1G  0 part
├─sda3        8:3    0   500G  0 part
└─sda4        8:4    0   430G  0 part /work
nvme0n1     259:0    0 238.5G  0 disk
├─nvme0n1p1 259:1    0   300M  0 part /boot/efi
├─nvme0n1p2 259:2    0   300M  0 part /boot
├─nvme0n1p3 259:3    0    80G  0 part /
├─nvme0n1p4 259:4    0 150.4G  0 part /home
└─nvme0n1p5 259:5    0   7.5G  0 part
```

## 9. 查看磁盘使用信息

```
[root@mxd mxd]# df -h
文件系统        大小  已用  可用 已用% 挂载点
dev             7.9G     0  7.9G    0% /dev
run             7.9G  6.2M  7.9G    1% /run
efivarfs         59K   14K   46K   23% /sys/firmware/efi/efivars
/dev/nvme0n1p3   80G   16G   65G   20% /
tmpfs           7.9G  338M  7.6G    5% /dev/shm
tmpfs           7.9G  1.9G  6.1G   24% /tmp
/dev/nvme0n1p4  150G   99G   52G   66% /home
/dev/nvme0n1p2  272M  110M  147M   43% /boot
/dev/nvme0n1p1  300M  196K  300M    1% /boot/efi
/dev/sda4       430G   22G  408G    6% /work
tmpfs           1.6G  608K  1.6G    1% /run/user/1000
```

## 10. 查看内存使用情况

```
[root@mxd mxd]# free -m
               total        used        free      shared  buff/cache   available
内存：         16146       13354        1372        2354        5945        2792
交换：             0           0           0
```

## 11. 查看系统某服务运行情况

比如`NetworkManager`服务

```
[root@mxd mxd]# systemctl status NetworkManager
● NetworkManager.service - Network Manager
     Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; preset: disabled)
     Active: active (running) since Wed 2023-10-11 09:16:23 CST; 2 weeks 1 day ago
       Docs: man:NetworkManager(8)
   Main PID: 2746 (NetworkManager)
      Tasks: 4 (limit: 19334)
     Memory: 10.7M
        CPU: 8min 57.592s
     CGroup: /system.slice/NetworkManager.service
             └─2746 /usr/bin/NetworkManager --no-daemon

10月 26 09:20:04 mxd NetworkManager[2746]: <info>  [1698283204.0241] manager: NetworkManager state is now CONNECTED_GL>
10月 26 09:22:31 mxd NetworkManager[2746]: <info>  [1698283351.8060] dhcp4 (enp2s0): state changed new lease, address=>
10月 26 09:35:23 mxd NetworkManager[2746]: <info>  [1698284123.6465] manager: NetworkManager state is now CONNECTED_SI>
10月 26 09:39:39 mxd NetworkManager[2746]: <info>  [1698284379.0202] manager: NetworkManager state is now CONNECTED_GL>
10月 26 09:49:58 mxd NetworkManager[2746]: <info>  [1698284998.6470] manager: NetworkManager state is now CONNECTED_SI>
10月 26 09:54:14 mxd NetworkManager[2746]: <info>  [1698285254.0105] manager: NetworkManager state is now CONNECTED_GL>
10月 26 10:04:33 mxd NetworkManager[2746]: <info>  [1698285873.6467] manager: NetworkManager state is now CONNECTED_SI>
10月 26 10:05:06 mxd NetworkManager[2746]: <info>  [1698285906.0615] manager: NetworkManager state is now CONNECTED_GL>
```

### 11.1 查看某服务的运行log

比如`NetworkManager`服务

```
[root@mxd mxd]# journalctl -b -u NetworkManager
10月 11 09:16:23 mxd systemd[1]: Starting Network Manager...
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.3066] NetworkManager (version 1.42.6-1) is starting... >
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.3069] Read config: /etc/NetworkManager/NetworkManager.c>
10月 11 09:16:23 mxd systemd[1]: Started Network Manager.
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.3090] bus-manager: acquired D-Bus service "org.freedesk>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.3143] manager[0x5555767b5ec0]: monitoring kernel firmwa>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5504] hostname: hostname: using hostnamed
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5505] hostname: static hostname changed from (none) to >
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5509] dns-mgr: init: dns=default,systemd-resolved rc-ma>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5529] manager[0x5555767b5ec0]: rfkill: Wi-Fi hardware r>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5529] manager[0x5555767b5ec0]: rfkill: WWAN hardware ra>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5566] Loaded device plugin: NMAtmManager (/usr/lib/Netw>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5615] Loaded device plugin: NMBluezManager (/usr/lib/Ne>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5627] Loaded device plugin: NMOvsFactory (/usr/lib/Netw>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5831] Loaded device plugin: NMTeamFactory (/usr/lib/Net>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5842] Loaded device plugin: NMWifiFactory (/usr/lib/Net>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5849] Loaded device plugin: NMWwanFactory (/usr/lib/Net>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5851] manager: rfkill: Wi-Fi enabled by radio killswitc>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5852] manager: rfkill: WWAN enabled by radio killswitch>
10月 11 09:16:23 mxd NetworkManager[2746]: <info>  [1696986983.5852] manager: Networking is enabled by state file
......
......
```

## 12. 查看USB连接信息

```
[root@mxd mxd]# lsusb -t
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ohci-pci/4p, 12M
    |__ Port 2: Dev 7, If 0, Class=Vendor Specific Class, Driver=pl2303, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/4p, 480M
    |__ Port 1: Dev 103, If 0, Class=Hub, Driver=hub/4p, 480M
        |__ Port 1: Dev 104, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M
        |__ Port 3: Dev 105, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M
        |__ Port 3: Dev 105, If 1, Class=Human Interface Device, Driver=usbhid, 1.5M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ohci-pci/4p, 12M
    |__ Port 1: Dev 4, If 0, Class=Vendor Specific Class, Driver=pl2303, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/4p, 480M
```

## 13. 查看CPU相关信息

```
[root@mxd mxd]# lscpu
架构：               loongarch64
  CPU 运行模式：     32-bit, 64-bit
  Address sizes:     48 bits physical, 48 bits virtual
  字节序：           Little Endian
CPU:                 8
  在线 CPU 列表：    0-7
BIOS 厂商 ID：       Loongson
型号名称：           Loongson-3A6000
  BIOS 型号名称：    Loongson-3A6000 Not Specified CPU @ 2.5GHz
  BIOS CPU family:   603
  CPU 系列：         Loongson-64bit
  型号：             0x00
  每个核的线程数：   2
  每个座的核数：     4
  座：               1
  BogoMIPS：         5000.00
  标记：             cpucfg lam ual fpu lsx lasx crc32 complex crypto lvz lbt_x86 lbt_arm lbt_mips
Caches (sum of all):
  L1d:               512 KiB (8 instances)
  L1i:               512 KiB (8 instances)
  L2:                2 MiB (8 instances)
  L3:                16 MiB (1 instance)
NUMA:
  NUMA 节点：        1
  NUMA 节点0 CPU：   0-7
```

以及:

```
[root@mxd mxd]# cat /proc/cpuinfo 
system type		: generic-loongson-machine

processor		: 0
package			: 0
core			: 0
global_id		: 0
CPU Family		: Loongson-64bit
Model Name		: Loongson-3A6000
CPU Revision		: 0x00
FPU Revision		: 0x00
CPU MHz			: 2500.00
BogoMIPS		: 5000.00
TLB Entries		: 2112
Address Sizes		: 48 bits physical, 48 bits virtual
ISA			: loongarch32 loongarch64
Features		: cpucfg lam ual fpu lsx lasx crc32 complex crypto lvz lbt_x86 lbt_arm lbt_mips
Hardware Watchpoint	: yes, iwatch count: 8, dwatch count: 4
......
......
```

## 14. 查看SMBIOS详细信息

```
[root@mxd mxd]# dmidecode
# dmidecode 3.5
Getting SMBIOS data from sysfs.
SMBIOS 3.2.0 present.
Table at 0xFE5A0000.

Handle 0x0000, DMI type 0, 26 bytes
BIOS Information
	Vendor: Loongson
	Version: Loongson-UDK2018-V4.0.05494-stable202305
	Release Date: 07/10/23 18:05:47
	ROM Size: 4 MB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		Serial services are supported (int 14h)
		USB legacy is supported
		UEFI is supported
	BIOS Revision: 4.0

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Loongson
	Product Name: Loongson-3A6000-7A2000-1w-V0.1-EVB
	Version: Not Specified
	Serial Number: Not Specified
	UUID: Not Present
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified
......
......
```

可以使用`-t`参数只看某一项信息

如查看`processor`信息:

```
[root@mxd mxd]# dmidecode -t processor
# dmidecode 3.5
Getting SMBIOS data from sysfs.
SMBIOS 3.2.0 present.

Handle 0x0004, DMI type 4, 48 bytes
Processor Information
	Socket Designation: CPU0
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: Loongson
	ID: 33 41 36 30 30 30 00 00
	Version: Loongson-3A6000
	Voltage: Unknown
	External Clock: Unknown
	Max Speed: Unknown
	Current Speed: 2500 MHz
	Status: Populated, Enabled
	Upgrade: <OUT OF SPEC>
	L1 Cache Handle: Not Provided
	L2 Cache Handle: Not Provided
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 8
	Core Enabled: 8
	Thread Count: 8
	Characteristics:
		64-bit capable
		Multi-Core
		Hardware Thread
```

## 15. 查看媒体文件信息

```
[root@mxd video_test]# mediainfo yangman.wav
General
Complete name                            : yangman.wav
Format                                   : Wave
Format settings                          : PcmWaveformat
File size                                : 43.4 MiB
Duration                                 : 3 min 56 s
Overall bit rate mode                    : Constant
Overall bit rate                         : 1 541 kb/s
Album                                    : 少年
Track name                               : 少年
Track name/Position                      : 1
Performer                                : 梦然
Director                                 : ÃÎÈ»
Genre                                    : pop
Recorded date                            : 2019
Original source form/Name                : ÉÙÄê
Copyright                                : 夏星星收藏
Cover                                    : Yes
Cover type                               : Cover (front)
Cover MIME                               : image/jpeg
ITRK                                     : 1
iurl                                     : http://user.qzone.qq.com/

Audio
Format                                   : PCM
Format settings                          : Little / Signed
Codec ID                                 : 1
Duration                                 : 3 min 56 s
Bit rate mode                            : Constant
Bit rate                                 : 1 536 kb/s
Channel(s)                               : 2 channels
Sampling rate                            : 48.0 kHz
Bit depth                                : 16 bits
Stream size                              : 43.2 MiB (100%)
```

## 16. 查看文件

### 16.1 产看文件类型

```
[root@mxd video_test]# file yangman.wav
yangman.wav: RIFF (little-endian) data, WAVE audio, Microsoft PCM, 16 bit, stereo 48000 Hz
```

### 16.2 查看文件大小

```
[root@mxd video_test]# du -sh yangman.wav
44M	yangman.wav
```

### 16.3 查看文件校验码

如`md5`:

```
[root@mxd video_test]# md5sum yangman.wav
07c75d425e152d3ef782a8dd4b420ab7  yangman.wav
```

## 17. 查看网络端口信息

```
[root@mxd video_test]# netstat -tnup | grep 3389
tcp6       0      0 192.168.1.3:3389           192.168.1.4:59708       ESTABLISHED -
```
