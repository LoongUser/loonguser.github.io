---
title: Loongnix_FAQ
author: Ayden Meng
categories: 2. 系统
toc: true
---

> 文章来源: `http://docs.loongnix.cn/loongnix/faq/%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/%E6%A1%8C%E9%9D%A2%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F.html`

> 自2022/11/16日起桌面版软件源的key到期，如本地遇到key的问题，可依照下列方法对Key授权进行升级即可：
>
> wget http://pkg.loongnix.cn/loongnix/pool/main/d/debian-archive-keyring//debian-archive-keyring_2019.1.lnd.2_all.deb
>
> dpkg -i debian-archive-keyring_2019.1.lnd.2_all.deb
>
> apt-key add /usr/share/keyrings/debian-archive-buster-loongarch64-stable.gpg

## 1. loongnix桌面系统源

```auto
http://pkg.loongnix.cn/loongnix/
```

## 2. 开启sshd服务

Loongnixi桌面系统默认关闭sshd服务，开启方法:

```auto
loongson@loongson-pc:~$ sudo apt install openssh-server
loongson@loongson-pc:~$ systemctl start ssh
loongson@loongson-pc:~$ systemctl status ssh
```

## 3. 安装auditd软件包

Loongnix系统默认不集成auditd软件包，若使用过程中用到审计功能，需手动安装auditd软件包:

```auto
loongson@loongson-pc:~$ sudo apt install auditd && systemctl start auditd && systemctl status auditd
```

## 4. 制作rootfs文件系统

已安装debootstrap的前提下，使用以下方法制作rootfs文件系统：

```auto
debootstrap --no-check-gpg --variant=minbase --components=main,non-free,contrib --arch=loongarch64 --foreign DaoXiangHu-stable iso http://pkg.loongnix.cn/loongnix/
chroot iso debootstrap/debootstrap --second-stage
cd iso
chroot .
```

执行debootstrap操作时，如果遇到下述错误现象：

```auto
root@loongson-pc:/home# debootstrap --no-check-gpg --variant=minbase --components=main,non-free,contrib --arch=loongarch64 --foreign DaoXiangHu iso http://10.2.5.28/os/loongnix-desktop-la64-20/debian
E: No such script: /usr/share/debootstrap/scripts/DaoXiangHu
```

解决方法是：

```auto
ln -s /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/DaoXiangHu
```

## 5. 锁定屏幕界面无法点击功能按键

锁定屏幕界面无法点击"切换用户、解锁、留言等"功能按键,此时,可以按一下ESC键，留言、解锁、取消等按键即可点击。

## 6. 密码复杂度要求

修改普通用户密码或者root密码时，若密码复杂度较低，会报告“无效的密码： 没有足够的字符分类”、“无效的密码： 太短了”等提示。 出于安全考虑，Loongnix系统中提高了密码设置规则的复杂度，用户在设置密码时需包含四类字符(数字，小写字母，大写字母，特殊符号)且密码长度不低于8位。

## 7. home键不能调用开始菜单

Loongnix系统使用mate桌面，如果要打开开始菜单可以使用Alt+F1的快捷键。

## 8. 运行命令vulkaninfo会报错

vulkan的使用需要显卡的支持，amd显卡vulkaninfo输出正常。

## 9. 使用npm安装软件包

先配置软件源再安装all架构的npm软件包，版本是7.5.2+ds-2。 需配置的软件源是：

```auto
deb [arch=amd64] https://mirrors.ustc.edu.cn/debian/ bullseye main non-free contrib
```

## 10. 图形环境下修改系统语言

安装lightdm-gtk-greeter-settings软件包。

## 11. unit-firewalldservice-could-not-be-found

需安装firewalld软件包。

## 12. 配置软件包仓库

```auto
loongson@loongson-pc:~$ sudo vim /etc/apt/sources.list    //参考已有的格式，增加deb * deb-src *，保存退出
loongson@loongson-pc:~$ sudo apt-get update
```

## 13. 查看系统版本信息

查看系统及版本信息：

```auto
  cat /etc/os-release
```

## 14. 查看系统已安装软件包

查看系统上所有已安装的软件包：

```auto
loongson@loongson-pc:~$ dpkg -list
```

## 15. 查询软件包文件列表

查询某个软件包打包的所有文件：

```auto
loongson@loongson-pc:~$ dpkg --listfiles 包名
```

## 16. 编译安装非loongnix程序

/usr/local/目录不受Loongnix软件包管理系统的控制。 用户可以将程序的源代码放在/usr/local/src /中，将二进制文件放入/usr/local/bin/，将库放入 /usr/local/lib/，将配置文件放入 /usr/local/etc/。 如果您的程序或文件确实必须放置在其他目录中，仍可以将它们存储在中/usr/local/目录，但需创建符号链接。

## 17. loongnix-20loongarch64镜像默认密码

```auto
Loongnix-20.loongarch64镜像的默认密码是：
Loongson20
```

## 18. 升级最新系统版本

举例：若操作系统是loongnix-20.loongarch64.rc1版本，系统需升级至龙芯外网源的最新系统版本。

（1）操作方法

```auto
loongson@loongson-pc:~$ sudo apt update
loongson@loongson-pc:~$ sudo apt install linux-image-loongson-3 linux-headers-loongson-3
loongson@loongson-pc:~$ apt upgrade
```

（2）重启后查询系统版本和内核版本

```auto
loongson@loongson-pc:~$ uname -a
输出：
Linux loongson-pc 4.19.0-13-loongson-3 #1 SMP Tue Aug 17 01:55:23 UTC 2021 loongarch64 loongarch64 loongarch64 GNU/Linux
loongson@loongson-pc:~$ cat /etc/issue
输出：Loongnix GNU/Linux 20 RC3 \n \l
```

## 19. 切换xfce主题

（1）安装xfce桌面

```auto
loongson@loongson-pc:~$ sudo apt-get install xorg xfce4
```

（2）安装桌面主题和图标主题

```auto
loongson@loongson-pc:~$ sudo apt-get install whitesur-gtk-theme tela-circle-icon-theme
```

（3）切换xfce桌面

```auto
loongson@loongson-pc:~$ sudo update-alternatives --config x-session-manager
```

输入3，启动xfce桌面。回显如下：

```auto
loongson@loongson-pc:~$ sudo update-alternatives --config x-session-manager
有 3 个候选项可用于替换 x-session-manager (提供 /usr/bin/x-session-manager)。

  选择       路径                  优先级  状态
------------------------------------------------------------
* 0            /usr/bin/mate-session    50        自动模式
  1            /usr/bin/mate-session    50        手动模式
  2            /usr/bin/startxfce4      50        手动模式
  3            /usr/bin/xfce4-session   40        手动模式

要维持当前值[*]请按<回车键>，或者键入选择的编号：3
```

(4) 重启系统

## 20. 使用init3或telinit-3黑屏

目前systemd 分配的虚拟终端为tty1～6为字符终端，tty7为gui终端。init 3后，显示仍在tty7终端，但图形界面已经关掉，因此出现黑屏现象，出现此现象为正常现象。 如果想使用init 3 后，出现字符界面，可以提供两种实现的方法：

```auto
方法一：将gui终端显示在tty1
修改/etc/lightdm/lightdm.conf文件，minimum-vt =1
重启lightdm服务，systemctl restart lightdm
```

```auto
方法二：初始化tty7的字符终端
修改/etc/systemd/logind.conf文件，NAutoVTs=7
重启系统
```

## 21. u盘格式化为ext4后宿主为root而当前用户

解决方法：

```auto
chown -R loongson:loongson u盘设备名
```

## 22. 命令行模式中文显示乱码

解决方法：

```auto
loongson@loongson-pc:~$ dpkg -l |grep zhcon //判断是否安装zhcon软件包
loongson@loongson-pc:~$ sudo apt install zhcon
loongson@loongson-pc:~$ zhcon --utf8  //字符界面执行
```

## 23. 软件光标切换成硬件光标

目前loongnix系统中默认使能的是软件光标。 将软件光标切换成硬件光标的方法：

```auto
loongson@loongson-pc:~$ sudo vim /usr/share/X11/xorg.conf.d/20-loongson.conf
Option          "SWcursor"      "true"
修改为
Option          "SWcursor"      "false"
```

## 24. 桌面系统手动分区注意事项

| 分区 | 介绍 | 分区挂载点 | 分区文件系统格式 | 推荐大小（仅供参考，可自行修改） | 备注 |
| --- | --- | --- | --- | --- | --- |
| efi分区 | efi系统分区是一个FAT16或FAT32格式的物理分区，支持EFI模式的电脑需要从 ESP 启动系统，ESP是系统引导分区。 | /boot/efi | fat32 | 300MB | pmon固件可不分，uefi固件必须分，同时需要勾选esp标识 |
| boot分区 | boot分区是操作系统的内核及在引导过程中使用的文件存放的分区。 | /boot | ext2/3/4 | 300MB | 可以不分，如想在PMON固件下分boot分区时，必须将boot分区分为ext2/3/4或fat32/16格式的文件系统 |
| 根分区 | 根分区就是root分区，用于存放系统数据的分区 | / | 均支持,推荐xfs | \>= 20G | 必须要分，最小10G |
| data分区 | data分区用于存放用户数据、应用数据的分区 | /data | 均支持,推荐xfs | 除去其余分区之外的所有磁盘大小 | 可以不分，但会影响后续使用新版系统升级功能时，数据丢失的情况。最小分5G可以安装系统，但是后续新建用户和安装应用软件可能会出现磁盘不足的情况。 |
| restore分区 | restore分区用于系统备份功能使用的分区，该分区为隐藏状态 | /restore | 均支持推荐xfs | \>= 20G | 可以不分，但会影响后续使用新版系统升级功能时，数据丢失的情况。最小分区大小和根分区一致 |
| swap分区 | swap分区，即交换区，系统在物理内存（运行内存）不够时，与Swap分区进行交换 | 无挂载点 | linuxswap | \>=8G | 可以不分，但是当内存不够用时，系统可能会卡死;最小分2G |

## 25. igbuioko模块的编译方法

igb\_uio.ko模块是独立于dpdk提供的。 编译igb\_uio.ko模块对应的代码获取位置是：[http://git.dpdk.org/dpdk-kmods/](http://git.dpdk.org/dpdk-kmods/) 编译方法：

```auto
loongson@loongson-pc:~$git clone http://dpdk.org/git/dpdk-kmods
loongson@loongson-pc:~$cd dpdk-kmods
loongson@loongson-pc:~$make
loongson@loongson-pc:~/dpdk-kmods/linux/igb_uio$ ls igb_uio.ko
igb_uio.ko
```

如果在编译igb\_uio.ko时报错，需要内核中默认支持CONFIG\_UIO=m

## 26. 查看内存页大小

```auto
loongson@loongson-pc:~$ getconf PAGESIZE
16384
loongson@loongson-pc:~$ arch
loongarch64
```

## 27. 默认软件源仓库

（1）Loongnix-20版本mate主题默认集成的软件源

```auto
root@loongson-pc:/home/loongson# cat /etc/apt/sources.list
deb http://pkg.loongnix.cn/loongnix DaoXiangHu-stable main contrib non-free
```

（2）Loongnix-20版本cartoons主题默认集成的软件源

```auto
root@loongson-pc:/home/loongson# cat /etc/apt/sources.list
deb http://pkg.loongnix.cn/loongnix DaoXiangHu-stable main contrib non-free
deb http://pkg.loongnix.cn/loongnix DaoXiangHu-cartoons main contrib non-free
```

## 28. 查看内核和编译器版本

（1）内核版本

```auto
loongson@loongson-pc:~$ dpkg -l |grep linux-libc-dev
ii  linux-libc-dev                               4.19.190-rc6.lnd.1                             loongarch64  Linux support headers for userspace development
loongson@loongson-pc:~$ uname -a
Linux loongson-pc 4.19.0-17-loongson-3 #1 SMP 4.19.190-6 Thu Mar 31 01:15:47 UTC 2022 loongarch64 loongarch64 loongarch64 GNU/Linux
```

（2）gcc编译器版本

```auto
loongson@loongson-pc:~$ gcc --version
gcc (Loongnix 8.3.0-6.lnd.vec.30) 8.3.0
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## 29. 取消密码复杂度设置

安装Loongnix系统时对设置的密码无复杂度要求。 修改密码时，密码复杂度遵循的规则是:密码长度最短为8，大写、小写、数字、字符这4类中，应至少满足3类。 在Loongnix-20.2.loongarch64系统中，修改密码时取消密码复杂度规则。 以用户名为“loongson”举例：

```auto
loongson@loongson-pc:~$ cat /etc/issue
Loongnix GNU/Linux 20 Release 2 \n \l
loongson@loongson-pc:~$ sudo su
[sudo] loongson 的密码：
root@loongson-pc:/home/loongson# passwd loongson   //设置新的密码为loongson，不再有复杂度要求
新的 密码：
重新输入新的 密码：
passwd：已成功更新密码
```

## 30. 在mate-terminal终端配置软件包源代码的源地址

软件包源代码的源地址配置方法,以Loongnix-20.2.loongarch64版本mate主题的系统为例：

```auto
loongson@loongson-pc:~$ sudo echo "deb-src http://pkg.loongnix.cn/loongnix DaoXiangHu-stable main contrib non-free" >>/etc/apt/sources.list
loongson@loongson-pc:~$ sudo apt update
```

## 31. loongnix桌面系统获取源代码

Loongnix桌面系统如何获取源代码? 以mate-panel为例：

（1）mate-terminal终端获取mate-panel源代码

```auto
root@loongson-pc:/home/loongson# cat /etc/apt/sources.list
deb http://pkg.loongnix.cn/loongnix DaoXiangHu-stable main contrib non-free
deb-src http://pkg.loongnix.cn/loongnix DaoXiangHu-stable main contrib non-free
root@loongson-pc:/home/loongson# apt source mate-panel
Reading package lists... Done
NOTICE: 'mate-panel' packaging is maintained in the 'Git' version control system at:
https://salsa.debian.org/debian-mate-team/mate-panel.git
......省略......
dpkg-source: info: extracting mate-panel in mate-panel-1.20.5
dpkg-source: info: unpacking mate-panel_1.20.5.orig.tar.xz
dpkg-source: info: unpacking mate-panel_1.20.5-1.1.lnd.4.debian.tar.xz
dpkg-source: info: using patch list from debian/patches/series
dpkg-source: info: applying 0001_RDA-support-Make-MATE-panel-aware-of-being-run-insid.patch
dpkg-source: info: applying 0002_mate-panel-panel-menu-items.c-Only-offer-Shutdown-bu.patch
dpkg-source: info: applying 0003_configure.ac-Report-RDA-support-status-in-configurat.patch
dpkg-source: info: applying 0004_configure.ac-Explicitly-require-in-RDA-0.0.3.patch
dpkg-source: info: applying 0005_change_default_layout.patch
dpkg-source: info: applying 0006_add_loongnix_layout.patch
dpkg-source: info: applying 0007_add_switch_loongnix_layout.patch
dpkg-source: info: applying 0008_add_def_weather_temperature.patch
dpkg-source: info: applying 0009_add_restrictions_to_loongnix_layout.patch
```

（2）网页获取mate-panel源代码

```auto
http://pkg.loongnix.cn/loongnix/pool/main/m/mate-panel/
```

## 32. loongnix-201livecdcartoon系统升级后桌面无图标显示

解决办法:

```auto
loongson@loongson-pc:~$ sudo apt update
loongson@loongson-pc:~$ sudo apt upgrade
loongson@loongson-pc:~$ sudo apt install cartoon-desktop-environment
```

## 33. kpatch-升级到097后生成的模块文件运行时报错

解决办法： 升级内核到4.19.190-7以上版本

©龙芯开源社区 all right reserved，powered by Gitbook文档更新时间： 2023-12-21 12:36:52
