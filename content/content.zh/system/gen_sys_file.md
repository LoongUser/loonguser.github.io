---
title: 生成系统下的一些文件
author: Ayden Meng
categories: 2. 系统
toc: true
---

## 1. Initrd

通常, `lib/modules/`下的文件夹名称和内核的版本名是一致的, 所以可以通过下列命令生成`Initrd`:

### 1.1 dracut命令

```
ls lib/modules/* | xargs -I N dracut --kver N --force
```

### 1.2 mkinitramfs命令

```
ls lib/modules/* | xargs -I N mkinitramfs /lib/modules/N -o /boot/initrd.img-N 
```

## 2. GRUB


### 2.1 Grub

通常, `Grub`安装在当前启动系统所在的磁盘上, 如下命令可以找到当前磁盘. (希望将`Grub`安装在其他盘的同学, 看明白自己想要的效果)

```
[root@mxd ~]# lsblk -P | grep "$(lsblk -P | grep -w 'MOUNTPOINTS="/"' | sed 's/.*MAJ:MIN="\([^:]*\).*/\1/g'):0" | awk -F '"' '{print "/dev/" $2}'
/dev/nvme0n1
```

再通过`grub-install`或者`grub2-install`命令安装进磁盘:

```
grub-install /dev/nvme0n1
```

### 2.2 grub.cfg

```
grub-mkconfig -o /boot/grub/grub.cfg
```

### 2.3 grub.efi

```
grub-mkimage -c /boot/grub/grub.cfg -o /boot/efi/EFI/BOOT/BOOTLOONGARCH64.EFI -O loongarch64-efi
```

`2.1`节中生成`grub`可以让`bios`找到启动设备, 自动启动.

假如没有执行`2.1`中的内容, 用户可以在`UEFI`下通过手动执行此节命令中生成的`BOOTLOONGARCH64.EFI`加载`grub`程序.

## 3. fstab

系统启动后, 启动参数中的`root=`后面的内容将被挂载为`根文件系统`, 也就是`Linux`目录中的`/`分区, 而其他的目录的挂载依赖`/etc/fstab`中的描述, 倘若重新分区, 通常需要更新`/etc/fstab`中的内容. 里面的内容具体含义详情[https://www.bing.com/](https://www.bing.com/)

### 3.1 自动更新

自动更新的前提是**对应目录已经按照预设想法挂载**, 比如:

```
[root@mxd ~]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 238.5G  0 disk
├─sda1   8:1    0   300M  0 part /boot/efi
├─sda2   8:2    0   300M  0 part /boot
├─sda3   8:3    0  41.3G  0 part /
├─sda4   8:4    0  41.3G  0 part
├─sda5   8:5    0 146.5G  0 part /root
│                                /opt
│                                /home
│                                /var
│                                /data
└─sda6   8:6    0   8.8G  0 part [SWAP]
```

然后使用`github`上开源的`genfstab`工具生成:

```
[root@mxd ~]# git clone https://github.com/glacion/genfstab.git
正克隆到 'genfstab'...
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 14 (delta 0), reused 1 (delta 0), pack-reused 11
接收对象中: 100% (14/14), 29.18 KiB | 281.00 KiB/s, 完成.
处理 delta 中: 100% (2/2), 完成.
[root@mxd ~]# cd genfstab/
[root@mxd ~ genfstab]# ./genfstab -U > /etc/fstab
```

同样, 假如在制作非当前启动系统的`fstab`文件, 例如:

```
[root@mxd ~]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 238.5G  0 disk
├─sda1   8:1    0   300M  0 part /mnt/boot/efi
├─sda2   8:2    0   300M  0 part /mnt/boot
├─sda3   8:3    0  82.6G  0 part /mnt
├─sda4   8:5    0 146.5G  0 part /mnt/home
└─sda5   8:6    0   8.8G  0 part [SWAP]
```

也同样可以使用:

```
[root@mxd ~ genfstab]# ./genfstab -U > /mnt/etc/fstab
```

### 3.2 手动更新

同样, 假如在制作非当前启动系统的`fstab`文件, 例如:

```
[root@mxd ~]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 238.5G  0 disk
├─sda1   8:1    0   300M  0 part /mnt/boot/efi
├─sda2   8:2    0   300M  0 part /mnt/boot
├─sda3   8:3    0  82.6G  0 part /mnt
├─sda4   8:5    0 146.5G  0 part /mnt/home
└─sda5   8:6    0   8.8G  0 part [SWAP]
[root@mxd ~]# blkid
/dev/sda2: LABEL="bootfs" UUID="6a68fa6e-4fa3-4036-91a3-6f0b2e6ff1b4" BLOCK_SIZE="1024" TYPE="ext3" PARTUUID="2215dfd8"
/dev/sda4: LABEL="datafs" UUID="b4e5345f-171e-447c-8b89-52459b29a380" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="0ba0e5ea-a"
/dev/sda3: LABEL="rootfs" UUID="103a31fa-631b-4ec5-8295-0817394b36d6" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="687bdb73-3"
/dev/sda1: UUID="768C-0E8F" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="bbb4bdad-36d3-4300-872c-1c00b15588c2"
/dev/sda5: UUID="e7429117-dba5-4318-8d48-ab34b7919f6d" TYPE="swap" PARTUUID="5bb18f47-7756-4be9-b5c0-59d1f1d36fed"
```

只需要将对应分区的`UUID`填写到`/mnt/etc/fstab`中去.

第一列是`UUID`, 或者理解是挂载的来源

第二列是挂载的目标位置

第三列是挂载的类型

第四列是挂载的参数

```
[root@mxd ~]# cat /mnt/etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a device; this may
# be used with UUID= as a more robust way to name devices that works even if
# disks are added and removed. See fstab(5).
#
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
UUID=768C-0E8F                            /boot/efi      vfat    defaults,noatime 0 2
UUID=6a68fa6e-4fa3-4036-91a3-6f0b2e6ff1b4 /boot          ext3    defaults,noatime 0 2
UUID=103a31fa-631b-4ec5-8295-0817394b36d6 /              xfs     defaults,noatime,discard 0 1
UUID=b4e5345f-171e-447c-8b89-52459b29a380 /home          xfs     defaults,noatime,discard 0 2
UUID=e7429117-dba5-4318-8d48-ab34b7919f6d swap           swap    defaults,noatime 0 2
tmpfs                                     /tmp           tmpfs   defaults,noatime,mode=1777 0 0
```

其中第四列挂载的参数可以参考`mount -v`的输出, 不清楚的抄一抄上述内容, 基本是可用的.

## 4. 生成用户

其实是创建用户, 任何系统都需要一个可登录的用户来操作, 那么则必须配置一个用户作为登录选项.

开发中常用`root`帐号通常是自带的, 但是我们需要对其设定密码, 通过`passwd root`命令.

如果我们需要普通用户, 则需要通过`useradd`命令创建:

```
[root@mxd ~]# useradd -m -s /bin/bash username
[root@mxd ~]# passwd username
新的密码：
重新输入新的密码：
passwd：已成功更新密码
```

> 通常, 上述内容是制作一个操作系统最基本的内容(个人理解, 非专业说明).
