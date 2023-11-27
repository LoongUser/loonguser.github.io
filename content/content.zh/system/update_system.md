---
title: 如何更新系统
author: Ayden Meng
categories: 2. 系统
toc: true
---

## 1 全系统更新:

`Debian`系:

```
apt update && apt upgrade
```

`Redhat`系:

```
yum update
```

`Arch`系:

```
pacman -Syu
```

## 2. 单独更新内核

### 2.1 更新自己编译的内核

将内核放置`/boot`下即可(通常`/boot`是`grub.cfg`默认指定的根目录)

更新完记得更新`grub.cfg`, 见第四节.

### 2.2 更新软件源上的内核

以`Debian`系为例, 其余不做演示:

```
root@loongson-pc:/home/loongson# apt-cache search linux-header
aufs-dkms - DKMS files to build and install aufs
linux-headers-4.19.0-17-common - Common header files for Linux 4.19
linux-headers-4.19.0-17-loongson-3 - Linux kernel headers for 4.19 on loongson-3
linux-headers-4.19.0-18-common - Common header files for Linux 4.19
linux-headers-4.19.0-18-loongson-3 - Linux kernel headers for 4.19 on loongson-3
linux-headers-4.19.0-19-common - Common header files for Linux 4.19
linux-headers-4.19.0-19-loongson-3 - Linux kernel headers for 4.19 on loongson-3
linux-headers-loongson-3 - Linux kernel headers for 4.19 on loongson-3 (meta-package)
root@loongson-pc:/home/loongson#
root@loongson-pc:/home/loongson# apt install linux-headers-4.19.0-19-loongson-3
正在读取软件包列表... 完成正在分析软件包的依赖关系树       
正在读取状态信息... 完成       
......
......
```

## 3. 单独更新initrd

### 3.1 更新自己编译的modules并生成initrd

将从内核源码编译的模块文件拷贝至`/lib/modules/`, 比如`4.19.190+.tgz`是模块文件的压缩包:

```
root@loongson-pc:/lib/modules# tar -zxf 4.19.190+.tgz -C /lib/modules/
root@loongson-pc:/lib/modules# ls
4.19.0-19-loongson-3  4.19.190+
```

在`/lib/modules/`下生成的`4.19.190+`文件夹即为新的模块文件目录, 然后手动生成`initrd`即可. (通常, 模块文件夹名与内核版本名称一致, 倘若不一致, 需要进入`/lib/modules/`目录, 相当于指定文件夹)

```
root@loongson-pc:/lib/modules# cd /lib/modules/
root@loongson-pc:/lib/modules# dracut --force --kver 4.19.190+
dracut: Executing: /usr/bin/dracut --force --kver 4.19.190+
Mode:                     real
Method:                   sha256
Files:                    1034
Linked:                   188 files
Compared:                 0 xattrs
Compared:                 2322 files
Saved:                    7.64 MiB
Duration:                 0.088150 seconds
dracut: *** Hardlinking files done ***
dracut: *** Stripping files ***
dracut: *** Stripping files done ***
dracut: *** Generating early-microcode cpio image ***
dracut: *** Store current command line parameters ***
dracut: Stored kernel commandline:
dracut:  resume=UUID=e7429117-dba5-4318-8d48-ab34b7919f6d
dracut:  root=UUID=103a31fa-631b-4ec5-8295-0817394b36d6 rootfstype=xfs rootflags=rw,noatime,attr2,inode64,noquota
dracut: *** Creating image file '/boot/initramfs-4.19.190+.img' ***
dracut: *** Creating initramfs image file '/boot/initramfs-4.19.190+.img' done ***
```

`/boot/initramfs-4.19.190+.img`即为生成的`initrd`

`mkinitramfs`等其他命令不再介绍, 可参考: [生成系统下的一些文件](../gen_sys_file)

### 3.2 更新软件源上的initrd

以`Debian`系为例, 其余不做演示:

```
root@loongson-pc:/lib/modules# apt-cache search linux-image
linux-image-4.19.0-17-loongson-3 - Linux kernel, version 4.19 for loongson 3
linux-image-4.19.0-17-loongson-3-dbg - Debug symbols for linux-image-4.19.0-17-loongson-3
linux-image-4.19.0-17-loongson-3-kdump - kdump package
linux-image-4.19.0-18-loongson-3 - Linux kernel, version 4.19 for loongson 3
linux-image-4.19.0-18-loongson-3-dbg - Debug symbols for linux-image-4.19.0-18-loongson-3
linux-image-4.19.0-18-loongson-3-kdump - kdump package
linux-image-4.19.0-19-loongson-3 - Linux kernel, version 4.19 for loongson 3
linux-image-4.19.0-19-loongson-3-dbg - Debug symbols for linux-image-4.19.0-19-loongson-3
linux-image-4.19.0-19-loongson-3-kdump - kdump package
linux-image-loongson-3 - Linux for Loongson 3 (meta-package)
linux-image-loongson-3-dbg - Debugging symbols for Linux loongson-3 configuration (meta-package)
root@loongson-pc:/lib/modules# apt install linux-image-4.19.0-19-loongson-3
正在读取软件包列表... 完成正在分析软件包的依赖关系树       
正在读取状态信息... 完成       
......
......
```

## 4. 更新grub.cfg

内核和`initrd`准备完毕后, 可以增加或修改相应的启动项. 例如`vm.mxd`是手动编译生成的内核名称. `initramfs-4.19.190+.img`是根据`modules`生成的`initrd`, 增加或者修改相应内容即可:

```
menuentry 'vm.mxd' --class loongnix_20 --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-103a31fa-631b-4ec5-8295-0817394b36d6' {
        load_video
        gfxmode $linux_gfx_mode
        insmod gzio
        if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
        insmod part_gpt
        insmod ext2
        set root='hd0,gpt2'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-ieee1275='ieee1275//disk@0,gpt2' --hint-bios=hd0,gpt2 --hint-efi=hd0,gpt2 --hint-baremetal=ahci0,gpt2  6a68fa6e-4fa3-4036-91a3-6f0b2e6ff1b4
        else
          search --no-floppy --fs-uuid --set=root 6a68fa6e-4fa3-4036-91a3-6f0b2e6ff1b4
        fi
        echo    'Loading Linux 4.19.0-19-loongson-3 ...'
        linux   /vm.mxd root=UUID=103a31fa-631b-4ec5-8295-0817394b36d6 ro  console=ttyS0,115200 earlycon=uart,mmio,0x1fe001e0 splash resume=PARTUUID=5bb18f47-7756-4be9-b5c0-59d1f1d36fed
        echo    'Loading initial ramdisk ...'
        initrd  /initramfs-4.19.190+.img
}
```
