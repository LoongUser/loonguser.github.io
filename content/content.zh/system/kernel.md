---
title: 内核编译
author: MarsDoge
categories: 2. 系统
toc: true
---

# 龙芯内核编译
目前**龙芯**已经由MIPS架构转战**LoongArch**架构.

- **vmlinux+vmlinuz** 
- **libmodules**
- **RamDisk_initrd**


## 准备阶段
> 下面以LoongArch架构的编译为例.
**编译器采用Gcc交叉编译LoongArch版本**
- 编译器版本 :
loongarch64-linux-gnu-gcc-8.3.0
- 配置文件 采用龙芯默认配置:
cp arch/loongarch/configs/loongson3_defconfig .config

## 开始编译
> vmlinux/vmlinuz
- 执行 make ARCH=loongarch  CROSS_COMPILE=/opt/LoongArch_Toolchains/loongarch64-linux-gnu-2020-11-06/bin/loongarch64-linux-gnu-(此为编译器路径 which gcc)  menuconfig 
![在这里插入图片描述](/images/kernel/1.png)

**进入图形化配置界面,开关相关功能,我们直接Esc退出.**

- 执行 make ARCH=loongarch  CROSS_COMPILE=/opt/LoongArch_Toolchains/loongarch64-linux-gnu-2020-11-06/bin/loongarch64-linux-gnu-  -j 16  //采用16线程进行编译(目前我是在服务器上编译,核数较多). 到此**vmlinux/vmlinuz 非压缩和压缩版内核**就编译完成.![在这里插入图片描述](/images/kernel/2.png)
**System.map** 是符号表

- 执行 make modules_install INSTALL_MOD_PATH=./ ARCH=loongarch  CROSS_COMPILE=/opt/LoongArch_Toolchains/loongarch64-linux-gnu-2020-11-06/bin/loongarch64-linux-gnu- 编译lib/modules/ 驱动模块包,熟悉内核的人都了解,当配置menuconfig的时候,会将M的驱动以modules的形式在内核中加载.![在这里插入图片描述](/images/kernel/3.png)


## 将编译的文件进行使用
> **1.vmlinuz 放在os的/boot/下,并可以修改成自己喜欢的名字 vmlinuz_go**

> **2.将lib/modules/下的文件copy到os根目录/lib/modules/**

> **3.参考Deebian制作Ramdisk为例: 执行** ![在这里插入图片描述](/images/kernel/4.png)
使用draut进行制作,该脚本制作的Ramdisk支持了好几种文件系统,你可以简单制作RamDisk,这里就不详细介绍该命令了.将制作的*.img文件拷贝到/boot下.

dracut 是一个事件驱动的 initramfs 基础设施。dracut(工具)被用来通过拷贝工具和文件，从一个已经安装的系统创建一个 initramfs 镜像，并将镜像与dracut框架结合在一起。

> **4.修改grub引导程序,进行加载相应的内核和RamDisk.**
- 目前 grub在Deebian系统的目录: /boot/efi/boot/grub.cfg
修改linux命令加载的文件名-> vmlinuz_go
 initrd命令加载的文件名-> initrd.live
 
