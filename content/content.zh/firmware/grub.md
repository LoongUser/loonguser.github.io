---
title: Grub编译与调试
author: Ayden Meng
categories: 1. 固件
toc: true
---

## 1. Grub编译

```
git clone https://github.com/loongarch64/grub.git
cd grub
./bootstrap
./configure --with-platform=efi --target=loongarch64 --prefix=$(pwd) --disable-werror
```

## 2. Grub文件生成

### 2.1 grub.efi

```
./grub-mkimage -p . -c /boot/mxd.cfg -d ./grub-core/ -O loongarch64-efi -o /boot/mxd.efi $(ls grub-core/ | grep -E "\.mod$" | cut -d "." -f 1 | uniq)
```

各参数可在`help`信息中查看.

### 2.2 grub.cfg

```
./grub-mkconfig -o /boot/mxd.cfg
```

除了生成`grub.cfg`外, 系统下还有一些用于参考的`grub`默认配置选项, 如: `/etc/default/grub`, `/etc/grub.d`等. 倘若修改这些文件, 还需要更新`/boot/grub/grub.cfg`, 有命令可以做到:

```
update-grub
```

### 2.3 将grub安装至UEFI引导界面

```
grub-install --boot-directory=/boot --efi-directory=/boot/efi --bootload-id=mxd /dev/sda
```

`--boot-directory`指定在`/boot`作为根目录, 下寻找`grub.cfg`和模块.

`--efi-directory`指定在`/boot/efi`下寻找`grub`的`efi`文件.

`--bootload-id`指定生成的`efi`选项在`UEFI`下显示的名称.

`/dev/sda`是安装`grubloongarch64.efi`的目标路径.

`grub-install`会调用`grub-mkimage`生成`grub.efi`文件, 同时会调用`efibootmgr`命令, 将`grub.efi`的路径通过`UEFI`运行时服务的接口写入到`Flash`中, 比如我这里举例是`--bootload-id=mxd`, 那在`UEFI`启动界面下将显示一个启动项, 名叫`mxd`, 指向`/boot/efi/EFI/mxd/grubloongarch64.efi`.

## 3. GRUB界面

![GRUB主界面](/images/uefi/7.png)

如图, GRUB界面下列出了几个选项, 其中第一项`vm.mxd`是我自己加的内核, 第二项`Loongnix GNU/Linux`是系统自带内核, 第三项`Advanced options for Loongnix GNU/Linux`是高级选项, 通常包含一些恢复模式的选项, 第四项是`System Setup`--系统设置, 其实就是进入`UEFI Setup`界面.

然后在界面的最下方:

> Use the ^ and v keys to select which entry is highlighted.   
> Press enter to boot the selected OS, `e` to edit the commands
> before booting or `c` for a command-line.                    

翻译一下:

> 通过按上下键选择选项, 按执行进入选项, 按`e`去编辑选项, 按`c`进入`GRUB`的命令行.

## 4. 编辑GRUB选项

通常我们通过`UEFI`执行`GRUB`的`efi`文件即可进入`GRUB`界面, 然后回车便可以启动内核, 但是倘若内核无法正常启动, 我们需要加串口调试, 就需要我们按`e`去编辑选项, 比如增加串口或者进入单用户模式等.

按`e`后进入下图, 我们可以将光标通过上下左右按键, 移动至`linux`开头的那一行, 并在行末加入想要的参数比如串口`console=ttyS0,115200 earlycon=uart,mmio,0x1fe001e0`.

![GRUB编辑](/images/uefi/8.png)

可以看到, 界面最下面仍然有一些文字, 告诉我们按下`Ctrl-X`组合键或者`F10`可以直接启动, 按下`Ctrl-c`或`F2`进入到`GRUB`命令行, 按下`ESC`可以退回上一步.

## 5. 手动找grub.cfg

当我们在`UEFI`下执行`GRUB`的`efi`文件后, 加入`grub.cfg`的路径有问题, 则需要我们手动找到`grub.cfg`并且加载:

![GRUB命令行操作](/images/uefi/9.png)

逐个说明上述命令: 首先`ls`命令能够看到当前能够识别的设别, 其中`hd0`表示一块硬盘(Hard Disk0), 如果有多个硬盘将以`hdx`的形式显示. 

但是`hd0`并不具有文件系统, `(hd0,msdos2)`这种形式才表示有文件系统, `msdos`指MBR的分区格式, `msdos2`也就表示`MBR`硬盘上第二个分区.

然后逐级用`ls`命令找到`grub.cfg`的路径:`(hd0,msdos2)/boot/grub/grub.cfg`.

最后通过`configfile`命令, 解析`grub.cfg`文件, 即可重新回到GRUB的主界面.

## 6. 没有grub.cfg的情况下引导内核

有时候, 我们会遇到有`grub`, 但是没有`grub.cfg`的情况, 这时, 我们可以稍微背下来两条命令, 这两条也就是`grub.cfg`中加载内核和加载`initrd`的命令: `linux`命令和`initrd`命令

`linux`命令后面加内核的路径, 以及内核启动参数

`initrd`命令后面加initrd的路径即可.

然后执行boot即可启动. 如下图:

![grub命令启动内核](/images/uefi/10.png)

## 7. Grub增加串口

### 7.1 使能串口

```
grub> serial --unit=0 --speed=115200
```

或:

```
grub> serial --speed=115200 com0
```

`--unit`后指定`com0`到`comN`用作串口, 通常默认使用`com0`.

但比如`loongarch`机器, 串口可能注册为了别的名字, 比如`efi0`, 所以真正执行的命令是:

```
grub> serial --speed=115200 efi0
```

### 7.2 使能串口输入

使能串口后, `terminal_input`和`terminal_output`命令分别查看可用的输入输出选项如下:

```
grub> terminal_input
Active input terminals:
console
Available input terminals:
serial_efi0
grub>
grub> terminal_output
Active output terminals:
console gfxterm
Available output terminals:
serial_efi0
```

可见输入和输出选项中各自增加了一个可用选项:`serial_efi0`

所以使用`terminal_input`和`terminal_output`命令分别设定可用的选项作为输入输出.

```
grub> terminal_input console serial_efi0
grub> terminal_output console gfxterm serial_efi0
```

串口下即可显示`grub`的一举一动了.

## 8. Grub打开debug

```
grub> set pager=1
grub> set debug=all
```

打开后打印会从`terminal_output`中可用的选项中输出. 所以建议增加串口后使用, 否则屏幕不支持回翻也挺麻烦的.
