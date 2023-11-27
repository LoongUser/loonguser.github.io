---
title: 如何更新固件
author: Ayden Meng
categories: 1. 固件
toc: true
---


## 在PMON下更新固件

详情[PMON使用方法](../pmon)

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

从tftp服务器加载:

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

从http服务器加载:

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

## 在UEFI下更新固件

详情[uefi使用方法](../uefi)

```
UEFI Interactive Shell v2.2
EDK II
UEFI v2.70 (EDK II, 0x00010000)
Mapping table
      FS0: Alias(s):HD0c0:;BLK0:
          PciRoot(0x0)/Pci(0x19,0x0)/USB(0x2,0x0)
Press ESC in 5 seconds to skip startup.nsh or any other key to continue.
Shell> FS0:
FSOpen: Open '\' Success
FS0:\> ls
Directory of: FS0:\
10/17/2023  07:47           4,194,304  uefi.mxd
          1 File(s)   4,194,304 bytes
          0 Dir(s)
FSOpen: Open '\' Success
FS0:\> spi -u uefi.mxd
Erase   : ******************************************************************************************
****************************************************************************************************
******************************************************************   Erase OK.
Program : ******************************************************************************************
****************************************************************************************************
******************************************************************   Program OK.
FS0:\>
```

![UEFI Shell下烧写固件](/images/firmware/1.png)

## 在系统下更新固件

```
root@loongson-pc:/home/loongson# git clone https://github.com/MarsDoge/OsTools.git
root@loongson-pc:/home/loongson# cd OsTools
root@loongson-pc:/home/loongson# ./build.sh
root@loongson-pc:/home/loongson/OsTools# ./OsTools spi -u -f uefi.mxd
mmap addr start : 0xfff78bc1f0
------------Read Buf Get Success!-----------
Erase   :
[========================================================================] 100%
Program :
[========================================================================] 100%
--------------Release mem Map----------------
root@loongson-pc:/home/loongson/OsTools# reboot
```

## 在系统下备份当前固件
```
root@loongson-pc:/home/loongson# git clone https://github.com/MarsDoge/OsTools.git
root@loongson-pc:/home/loongson# cd OsTools
root@loongson-pc:/home/loongson# ./build.sh
root@loongson-pc:/home/loongson# ./OsTools spi -d -f backup.dump.fd
mmap addr start : 0x7ffff07fc1f0
--------------Release mem Map----------------
root@loongson-pc:/home/loongson# ls backup.dump.fd
backup.dump.fd
```
