---
title: 龙芯UEFI使用详解
author: Ayden Meng
categories: 1. 固件
toc: true
---

![](/images/uefi-png/)
## 龙芯UEFI使用详解

## 1. UEFI主界面及设置语言

在串口或者显示界面下显示`BDS`字样的时候(如下图), 按方向下(`↓`)或`F2`即可进入`Setup`界面， 即主界面。

光标默认在`语言设置`，可以通过方向键选择，示例为修改语言。

![UEFI Booting](/images/uefi-png/language.png)

## 2. 主板信息

进入主板信息，可以查看BIOS版本、主板型号、CPU名字等相关硬件基础信息，如下图：
![主板信息](/images/uefi-png/info_main.png)

### 2.1 PCIE信息

选择`PCIe设备信息`可以查看主板的PCIe的全部信息，如下图：
![PCIe信息](/images/uefi-png/info_pcie.png)

### 2.2 USB信息

选择`USB设备信息`可以查看主板的USB的全部信息，如下图：
![USB信息](/images/uefi-png/info_usb.png)

## 3. 设置系统时间

操作系统时间通常默认使用rtc时钟，所以可以在固件下设置rtc时间以改变操作系统的默认时间。（当操作系统不通过rtc时间同步时，此方法不一定生效，关于系统下的配置，本文不作讨论）

![](/images/uefi-png/system_time.png)

## 4. 安全设置

安全设置包括如下内容：安全启动、恢复出厂设置、BIOS密码配置、固件更新等。
![](/images/uefi-png/secure_all.png)
### 4.1 安全启动配置

在下图界面中，可以看到安全启动相关的配置，包括状态和开启开关，同事包含相关自定义配置。

安全启动开启后，BIOS会开启自身校验功能，对普通用户来说，安全性提高的同时，会对启动速度产生一定影响。

![](/images/uefi-png/secureboot.png)

### 4.2 恢复出厂设置

如下图，按照提示执行恢复出厂设置后，原先所有在BIOS下保存的个人配置（如启动顺序、传统启动模式等）都将会被重置。

![](/images/uefi-png/recover.png)

### 4.3 BIOS密码设置

BIOS密码分为管理员密码和普通用户密码，其中当设定管理员密码后，则必须解锁管理员密码才可进一步更改相关配置，TODO.

![](/images/uefi-png/admin_passwd.png)

### 4.4 固件更新

固件更新应该是目前龙芯用户最关心的功能，截止目前（2024/12/13），龙芯UEFI下的固件更新功能可额外指定三项功能，如下图，分别是: 是否保留SMBIOS信息、是否保留BIOS配置（如启动顺序）、是否校验要更新的BIOS文件等。

![](/images/uefi-png/firmware_update_main.png)

倘若无需修改，则可以通过`选择文件`进入文件列表，并加载相应的BIOS文件。

> PS: UEFI固件下通常仅支持NTFS、FAT、EXT2/3/4等格式的文件系统，由于国内系统镜像制备流程不是非常规范，导致在不同阶段的UEFI下默认可能还支持ISO9660格式的文件系统，在高级选项中可配。

> PS：第一步选择设备时，设备名非常冗长难以理解，但在其中通常有NVME、SATA、USB等字样可供判断。

> PS：此方式仅支持烧录UEFI文件，不支持PMON、U-Boot等其他文件。

![](/images/uefi-png/file_explorer.png)
![](/images/uefi-png/firmware_update.png)

## 5. 电源设置

电源设置中仅包含`定时唤醒功能`，如下图：

![](/images/uefi-png/wakeup_timer.png)
![](/images/uefi-png/wakeup_timer_setup.png)

## 6. 高级设置

高级设置中包含许多用户关心的配置，包括PCIe特性、启动模式配置、其他兼容配置等。
![](/images/uefi-png/advanced_main.png)

### 6.1 PCI总线设置

在PCI总线配置中有如下配置选项：

1. 开启4G以上地址空间支持，等同于可以设置PCIe的Bar地址为64位地址，即支持使用更大Bar空间的设备，当使用一些高端显卡等需要较大的Bar空间的设备，优先考虑此配置。

2. SR-IOV支持，即PCIe设备虚拟化，开启并插入支持SR-IOV的设备后，将会为虚拟设备预留Bus和内存资源，当设备较多，资源占用较大时，若需要适用此功能，应该考虑开启`4G以上地址空间支持`的功能配合使用。

3. 解锁Bar限制，开启后将解锁BAR的最大空间地址，即支持设备使用大于4G空间的Bar. 同样应与`4G以上地址空间支持`的功能配合使用。

4. GPU模拟开关，在固件下显卡设备通常没有专用驱动，即需要模拟程序驱动显卡，而模拟程序针对特殊或高端显卡时，可能会无法正常模拟，此时使用模拟程序或许会导致固件卡死，因而显卡无法正常点亮时，可以考虑使用集显配置完成后，关闭EMU功能再通过独显进入系统，可使系统下显卡可用。

![](/images/uefi-png/pci_advanced_main.png)

### 6.2.1 传统启动模式

由于Loongarch架构早期对兼容性考虑的不足，导致有新旧世界两种系统，针对两种系统，固件也对应着两种传参。

> PS: 选项为`传统启动`，关闭时可起新世界系统，开启时启动旧世界系统。

![](/images/uefi-png/legacy_bootmode.png)

### 6.2.2 ISO文件系统支持

与传统启动模式类似，早期的国产系统厂商通常将系统文件直接打包成ISO9660格式的系统镜像，不带有任何分区信息，与诸如debian上游等iso制作有着些许区别。

> PS: 如何判断ISO文件系统支持是否需要启用：
>> 执行`fdisk -l iso_filename`，有EFI分区的则不需要启用，否则需要启用。
>> 如下debian则不需要启用, Loongnix-server则需要启用：

debian:
```
root@aosc [ mxd ] # fdisk -l /work/iso/debian-live-12.2.0-amd64-gnome.iso 
Disk /work/iso/debian-live-12.2.0-amd64-gnome.iso: 3.18 GiB, 3419209728 bytes, 6678144 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe4ed1d81

Device                                        Boot Start     End Sectors  Size Id Type
/work/iso/debian-live-12.2.0-amd64-gnome.iso1 *       64 6678143 6678080  3.2G  0 Empty
/work/iso/debian-live-12.2.0-amd64-gnome.iso2       6908   17147   10240    5M ef EFI (FAT-12/16/32)
```

Loongnix-server:
```
root@aosc [ mxd ] # fdisk -l /work/iso/Loongnix-server-8.4.0.livecd.loongarch64.iso 
Disk /work/iso/Loongnix-server-8.4.0.livecd.loongarch64.iso: 1.81 GiB, 1938675712 bytes, 3786476 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

```

![](/images/uefi-png/legacy_iso.png)

### 6.3 基础显示

龙芯目前支持多种显示设备，包括桥片提供的集显、pcie提供的显卡、bmc提供的显示。

龙芯固件支持配置优先使用哪种设备作为显示，如下图。

> PS: 配置为自动时的优先级：显卡 > BMC > 集显

![](/images/uefi-png/primary_display.png)

### 6.4 系统管理核心配置

此项包括龙芯平台的动态调频调压策略配置，由于更完善的功能尚未推出，暂不介绍

## 7. 设备管理

龙芯平台支持对设备进行开关，包括SATA、USB、网口、唤醒设置、IO虚拟化、电源恢复策略、7A桥片提供的PCIE控制器等，详情如下图：

![](/images/uefi-png/dev_manager.png)

1. SATA开关

![](/images/uefi-png/dev_manager_sata.png)

2. USB开关

![](/images/uefi-png/dev_manager_usb.png)

3. 网口开关

> PS: 龙芯平台的网口0和网口1分别为每个7A桥片的GNET, 倘若没有或不是，则不可通过此项控制

![](/images/uefi-png/dev_manager_network.png)

4. 唤醒设置

![](/images/uefi-png/wakeup_manager.png)

4. IO虚拟化开关

即IOMMU控制器开关，开启后可在虚拟机中对设备直通访问。

![](/images/uefi-png/dev_manager_iommu.png)

5. 电源恢复策略

控制电源上电时的行为，如可以配置每一次按下电源键为开机，则当电源通电时即会开机，具体配置如下：

![](/images/uefi-png/battery_setup.png)

6. 7A桥片提供的PCIE控制器开关

7A桥片提供F0、F1、G0、H四个控制器，可分别通过BIOS进行开关、速率调整、带宽配置，如下图：

![](/images/uefi-png/dev_manager_pcie_enable.png)
![](/images/uefi-png/dev_manager_pcie_speed.png)
![](/images/uefi-png/dev_manager_pcie_width.png)

## 8. 启动管理

通过启动管理选项，可直接选择启动某一设备：

> PS: Enter Setup即UEFI 设置界面，选择后会回到上一页。

> PS：UEFI Shell为UEFI下的终端，可实现更灵活复杂的操作，详情可参考[如何从UEFI命令行启动到系统](firmware/uefi_boot_system/)

> PS：选择设备时，设备名非常冗长难以理解，但在其中通常有NVME、SATA、USB等字样可供判断。

![](/images/uefi-png/bootmanager.png)

UEFI Shell如下：

![](/images/uefi-png/shell.png)

## 9. 启动维护管理

启动维护管理包括启动选项配置、驱动选项配置、控制台配置、文件引导等内容，如下图：

![](/images/uefi-png/bm.png)

### 9.1 启动选项

在此项配置中，可以增加/删除启动选项、调整启动选项的顺序、禁用/启用某个启动项，也可以按照设备类型来调整启动选项。


![](/images/uefi-png/bm_setup.png)

如下为部分示例：

1. 调整启动项

> PS: 回车后通过+或-按键调整。

![](/images/uefi-png/bootable_change.png)

2. 删除启动选项

![](/images/uefi-png/bootable_delete.png)

3. 禁用启动选项

![](/images/uefi-png/bootable_disable.png)

4. 按设备类型调整启动项

![](/images/uefi-png/boottype_change.png)

### 9.2 驱动选项配置

通过此项配置可以实现加载自定义或卸载已有驱动。

![](/images/uefi-png/driver_setup.png)

如社区同学做出了睿频的EFI驱动，即可通过此项设置加载：

![](/images/uefi-png/driver_add.png)

### 9.3 控制台配置

此项用于配置stdout、stdin、stderr三项内容，并提供丰富可用的功能：

![](/images/uefi-png/console_setup.png)

以最常用的输出设备为例，即通常为显示设备，但当偶尔显示设备无法点亮时，可以通过设置控制台输出设备的模式来使串口显示(配置为100x31或更小)：

![](/images/uefi-png/con-output.png)

## 10. 保存退出

修改相应配置后，大多数需要重启后生效，除`F10`快捷键外，可通过此项保存，并选择重启或关机。

![](/images/uefi-png/save_exit.png)
