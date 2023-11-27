---
title: PMON的使用方法
author: Ayden Meng
categories: 1. 固件
toc: true
---

## 1. 查看设备

```
PMON> devls
syn0
wd0
usb0
```

`sync0`, `igb0`, `em0` 等字样,表示网络设备, 即网卡

`wd0`, `nvme0`, `usb0`, `cd0`等字样表示存储设备, 即硬盘, `U`盘等.

## 2. 查看pci信息

```
PMON> pciscan
>> BUS  0 <<
Dev Fun Device description
--------------------------
  0   0 vendor/product: 0x0014/0x7a00 (bridge, host, interface: 0x00, revision: 0x00)
0x00000000:0x00000000 mem @0x00000000, 0 bytes
  0   1 vendor/product: 0x0014/0x7a10 (bridge, host, interface: 0x00, revision: 0x01)
0x00000000:0x00000000 mem @0x00000000, 0 bytes
  0   2 vendor/product: 0x0014/0x7a20 (bridge, host, interface: 0x00, revision: 0x01)
0x00000000:0x00000000 mem @0x00000000, 0 bytes
  0   3 vendor/product: 0x0014/0x7a30 (bridge, host, interface: 0x00, revision: 0x00)
0x00000000:0x00000000 mem @0x00000000, 0 bytes
  4   0 vendor/product: 0x0014/0x7a24 (serialbus, USB, interface: 0x10, revision: 0x02)
64-bit mem,low address
0x59648004:0xffff8004 mem @0x59648000, 32768 bytes
0x00000000:0x00000000 mem @0x00000000, 0 bytes
  ......
  ......
```

## 3. 产看固件版本信息

```
PMON> vers
PMON: PMON 5.0.3-Release (loongson) #233: Wed Oct 18 15:09:40 CST 2023 commit d044be8f495e97082c8905b131d525ef31ade0b9 Author: Xiangdong Meng <mengxiangdong@loongson.cn> Date:   Wed Sep 6 15:15:31 2023 +0800
```

## 4. 查看寄存器信息

```
PMON> d8 0x800000001fe00020 2
800000001fe00020 : 0000303030364133 0000000000000000 3A6000..........
```

## 5. 查看磁盘信息

这里`fdisk`命令后面的设备名是在第一节中`devls`命令列出来的.

`PMON`支持`GPT`和`MBR`分区

`PMON`暂不支持设备热插拔.

`MBR`:

```
PMON> fdisk usb0

Device    Boot  Start       End         Sectors     Id        System
usb0a           2048        122880000   122877952   83        Linux
```

`GPT`:

```
PMON> fdisk usb0

Device    Boot  Start       End         Sectors     Id        System
usb0a           2048        122877951   122875904   0FC63DAF  Linux filesystem
```

## 6. 查看磁盘中的文件

`/dev/fs/`后的字符是`fdisk usb0`命令中, `Device`一列中显示的内容.

`PMON`只支持`Fat`, `Ext2/3/4`, `ISO9660`等分区

`PMON`在查看文件时, 通常不用指定文件系统类型.

比如加载一个`fat`分区的内容: `load /dev/fs/usb0/`和`load /dev/fs/fat@usb0/`的效果是一样的

`Fat`分区:

```
PMON> load /dev/fs/usb0/
gz.mxd                                  <FILE>         993222
boot.cfg                                <FILE>         403
vm.mxd                                  <FILE>         95024056

/dev/fs/fat@usb0/: Is a directory
```

`ext2`/`ext3`/`ext4`分区:

```
PMON> load /dev/fs/usb1a/
|./ ../ lost+found/ gz.mxd boot.cfg
/dev/fs/ext4@usb1a/: Undefined error: 0
```

![load MBR](/images/pmon/1.png)

## 7. 加载内核

```
PMON> load /dev/fs/usb0a/vm.mxd
\Loading file: /dev/fs/fat@usb0a/vm.mxd (elf)
(elf)
0x9000000000200000/20053784 + 0x151ff18/922672(z) + 31926 syms|
Entry address is 00c01000
```

## 8. 加载initrd

```
PMON> initrd /dev/fs/usb0a/initrd.img-4.19.0-19-loongson-3
Loading initrd image /dev/fs/usb0a/initrd.img-4.19.0-19-loongson--dl_offset 9000000090000000 addr 9000000090000000
(bin)
```

## 9. 启动内核

必须要在加载内核之后执行:

```
PMON> g console=ttyS0,115200 earlycon=uart,mmio,0x1fe001e0 root=/dev/sda3
Warning! NVRAM checksum fail. Reset!
Reached finished_ap_limit=7 in a5 microseconds
BootCore ID: 0 Collect AP: 7 Total Core: 8
ACPI: ACPI tables init.
VBIOS crc check is wrong,use default setting!
GMEM: Get vbios from ls3a spi done!
Init acpi table OK!
set coherent
[    0.000000] Linux version 4.19.190+ (mengxiangdong@5.5) (gcc version 8.3.0 (GCC)) #9 SMP Tue Oct 17 11:14:31 CST 2023
[    0.000000] 64-bit Loongson Processor probed (LA664 Core)
[    0.000000] CPU0 revision is: 0014d000 (Loongson-64bit)
[    0.000000] FPU0 revision is: 00000001
[    0.000000] efi:  SMBIOS=0xfffe000  ACPI 2.0=0xfefe000  NEWMEM=0xb036800
[    0.000000] earlycon: uart0 at MMIO 0x000000001fe001e0 (options '')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000000FEFE000 000024 (v02 LOONGS)
......
......
```

## 10. 加载引导文件

`UEFI`通过找到`grub.efi`, 接着找到`grub.cfg`, 进而引导内核

而`PMON`只需要找到`boot.cfg`文件即可. `PMON`默认会从`/`和`/boot`目录中找`boot.cfg`

倘若没有找到, 可以手动加载:

```
PMON> bl /dev/fs/fat@usb0a/boot.cfg

������������������������������������������������Ŀ
�                 Boot Menu List                 �
������������������������������������������������Ĵ
� -> 1 Loongnix 20 GNU/Linux 4.19.0-19-loongson-3�
�                                                �
�                                                �
�                                                �
�                                                �
�                                                �
�                                                �
�                                                �
�                                                �
� Please Select Boot Menu [1]                    �
��������������������������������������������������
Use the UP and DOWN keys to select the entry.
Press ENTER to boot selected OS.
Press 'c' to command-line.
                                                 Booting system in [2] second(s)

```

## 11. 查看文件

```
PMON> devcp /dev/fs/fat@usb0a/boot.cfg /dev/tty0

default 0
timeout 3
showmenu 0

title Loongnix 20 GNU/Linux 4.19.0-19-loongson-3
    kernel /dev/fs/fat@usb0a/vmlinuz-4.19.0-19-loongson-3
    initrd /dev/fs/fat@usb0a/initrd.img-4.19.0-19-loongson-3
    args   root=/dev/sda3 console=ttyS0,115200 loglevel=8
```

## 12. 配置网络

```
PMON> devls
Device name  Type
syn0         IFNET
usb0         DISK
PMON> ifconfig syn0 192.168.1.13
synopGMAC_linux_open called
Version = 0xd137
MacAddr = 0x3e  0xd0    0x62    0xf5    0x46    0x94

===phy HALFDUPLEX MODE
DMA status reg = 0x0 before cleared!
DMA status reg = 0x0 after cleared!
register poll interrupt: gmac 0
==arp_ifinit done
===phy FULLDUPLEX MODE
Link is with 1000M Speed

PMON> 

```

## 13. 加载网络文件

`PMON`支持从网络加载内核, 支持的协议有`http`和`tftp`

`http`:

```
PMON> load http://192.168.1.4/vm.mxd
\Loading file: http://192.168.1.4/vm.mxd (elf)
(elf)
0x9000000000200000/20053784 + 0x151ff18/922672(z) + 31926 syms|
Entry address is 00c01000
```

`tftp`:

```
PMON> load tftp://192.168.1.4/vm.mxd
\Loading file: tftp://192.168.1.4/vm.mxd (elf)
(elf)
0x9000000000200000/20053784 + 0x151ff18/922672(z) + 31926 syms|
Entry address is 00c01000

```

## 14. 更新固件

`PMON`更新固件的命令为`fload`

与加载内核类似, 可以从硬盘加载, 也可以从网络加载

从硬盘加载:

```
PMON> fload /dev/fs/usb0a/gz.mxd
Loading file: /dev/fs/fat@usb0a/gz.mxd dl_offset 900000000f800000 addr 900000000f800000
(bin)
-
Loaded 993222 bytes

Programming flash 900000000f800000:f27c6 into 800000001c000000
Erase end!
-Programming end!
```

从`tftp`服务器加载:

```
PMON> fload tftp://192.168.1.4/gz.mxd
Loading file: tftp://192.168.1.4/gz.mxd dl_offset 900000000f800000 addr 900000000f800000
(bin)
-
Loaded 993222 bytes

Programming flash 900000000f800000:f27c6 into 800000001c000000
Erase end!
-Programming end!
```

从`http`服务器加载:

```
PMON> fload http://192.168.1.4/gz.mxd
Loading file: http://192.168.1.4/gz.mxd dl_offset 900000000f800000 addr 900000000f800000
(bin)
-
Loaded 993222 bytes

Programming flash 900000000f800000:f27c6 into 800000001c000000
Erase end!
-Programming end!
```
