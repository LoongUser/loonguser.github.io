---
title: 新世界Archlinux系统安装
author: Ayden Meng
categories: 2. 系统
toc: true
---


> 转载文章来源：[https://bbs.loongarch.org/d/88-archlinux/28](https://bbs.loongarch.org/d/88-archlinux/28)

#### 本主题多人协作，版主权限可编辑，开源爱好者若要参与协作，可回复中申请权限，或者在QQ群里申请。

#### 为了协调一致，本指南基于[@yetist](https://bbs.loongarch.org/u/79)制作的可引导安装镜像，指南覆盖系统引导、安装和具体应用配置。安装配置中遇到的问题，可以在回复中提出。本主题多人协作持续更新，勿催，谢谢！

## 一、龙芯新固件环境下引导盘的制作

### 安装镜像及软件仓库动态，可在如下主题中找到

[https://bbs.loongarch.org/d/67-loongarchlinux-202203/30](https://bbs.loongarch.org/d/67-loongarchlinux-202203/30)

### 最新镜像下载，随时更新

[https://mirrors.wsyu.edu.cn/loongarch/2022.03/iso/2022.06/loongarchlinux-2022.06.16.1-loongarch64.iso](https://mirrors.wsyu.edu.cn/loongarch/2022.03/iso/2022.06/loongarchlinux-2022.06.16.1-loongarch64.iso)  
[https://mirrors.wsyu.edu.cn/loongarch/2022.03/iso/2022.06/loongarchlinux-2022.06.22.1-loongarch64.iso](https://mirrors.wsyu.edu.cn/loongarch/2022.03/iso/2022.06/loongarchlinux-2022.06.22.1-loongarch64.iso)

[https://mirrors.wsyu.edu.cn/loongarch/archlinux/iso/latest/archlinux-loong64.iso](https://mirrors.wsyu.edu.cn/loongarch/archlinux/iso/latest/archlinux-loong64.iso)

### 引导盘制作

准备工作：一块确定状态良好的U盘，容量4G以上即可，制作引导U盘会擦除盘内原始数据，注意备份。  
Linux环境下，插入U盘，系统会识别，不要做任何打开，加载等操作，具体设备名，可使用如下命令

```bash
ls -la /dev/sd*      ##  U盘一般会识别成硬盘设备，*表示系统动态赋予的一个字符，用以区分不同硬盘
```

#### Linux环境下，使用dd这个工具软件

```perl
注意：x是个字符，用实际内容替换，命令执行需要root用户权限
sudo dd if=loongarchlinux-xxx.iso of=/dev/sdx  bs=1M status=progress oflag=direct 

# 命令执行完成后，建议运行下如下命令，确保U盘写入完整
sudo sync 
```

## 二、系统引导和安装前的检查

使用新固件引导，有两个快捷键会经常用到：

```lua
F2 ----- 激活固件配置界面，可在配置界面的选择引导设备
F12 ----- 激活引导管理菜单，暂时不推荐使用这个方式选择引导设备
```

![](https://bbs.loongarch.org/assets/files/2022-06-18/1655528601-696633-boot.jpg)

**使用新固件引导系统，包括引导本主题中制作好的U盘和之前使用grub有区别，具体流程是：**

1、开机前把**制作好的U盘**插入机器USB接口，建议插入到**主板提供的接口**上，不建议使用前置接口，躲坑。  
2、开机后出现龙芯logo，**快速按F2**，直到进入**固件配置界面**  
3、按如下图示操作：  
...  
TODO: 需要补充英文界面操作，或说明修改语言方法。

移动光标到 **启动管理** 项，回车：  
![](https://bbs.loongarch.org/assets/files/2022-06-18/1655534559-721436-dbd7f34c6e4fa17c59420e5fe2852376.jpg)

进入 **启动管理** 菜单之后，将会看到一系列可选择的启动项，请在列表中找到 **EFI System Partition** 或 **EFI System Partition 2**，并选择此项启动：  
![](https://bbs.loongarch.org/assets/files/2022-06-18/1655534991-6743-9d13303388461bb11beb2e2ae202d27b.jpg)

4.  如果在 **启动管理** 界面选择对了正确的启动项，电脑将会从U盘启动，如果看到显示器上出现了以下黑色背景的菜单项，则说明从 U 盘引导成功。  
    ![](https://bbs.loongarch.org/assets/files/2022-06-18/1655533619-356520-2022-06-18-13-00.png)

在这个界面出现后，请选择带有 **LoongArchLinux** 的菜单项，一般使用第1个就可以，电脑将开始从U 盘上启动系统。

5.  当看到如下界面出现时，说明已经进入了 ArchLinux 安装环境，可以开始安装系统了。  
    ![](https://bbs.loongarch.org/assets/files/2022-06-18/1655535657-243475-1d0feaab65ec1e6fce482435d488a229.jpg)

## 三、安装到机内硬盘

### 分区和格式化

分区和挂载也可以参考[凌莞的分区方案](https://lwqwq.com/posts/arch-linux-install-notes#:~:text=%E7%9A%84%E5%89%8D%E5%90%8E%E5%AF%B9%E6%AF%94-,%E5%88%86%E5%8C%BA%EF%BC%8C%E5%88%9B%E5%BB%BA%E5%AD%90%E5%8D%B7%EF%BC%8C%E6%88%96%E6%98%AF%E6%B8%85%E9%99%A4%E7%8E%B0%E6%9C%89%E7%9A%84%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F,-%E6%A0%B9%E6%8D%AE%E5%AE%89%E8%A3%85%E7%B3%BB%E7%BB%9F)

#### 1、磁盘分区操作

安装引导盘提供的分区工具比较多，常用的**fdisk,cfdisk,gpart**都有提供，推荐使用**cfdisk**，文本图形界面。

**重要**：分区和格式化后，磁盘（机械硬盘、固态硬盘和U盘）原有信息会被清除，友情提示谨慎操作，一定要确定好使用哪块硬盘，要记住它的设备名，如果是sata接口，或者U盘，设备名一般是sda、sdb、sdc，固态情况要复杂些，但也很好辨认。本指南预设目标磁盘是 **sdx** ，**x** 字符根据实际需要选择！

**预备知识**：sdx磁盘分区后，会生成 sdx1、sdx2 ... sdxn，数字表示的是第几个分区。分区操作执行完成后，可执行如下命令：

```bash
ls -la /dev/sd*     # 命令会列出所有识别出来的硬盘设备，也可以验证分区是否成功
```

**分区的具体操作**：

```undefined
cfdisk  /dev/sdx     
```

输入命令回车后，会出现一个全屏界面，里面显示的是**分区列表**，屏幕下面是几个**按钮**  
**具体操作**，选择分区用上下箭头，用tab键和左右键可选择屏幕下面的按钮，回车确定  
**提示**：所有操作都会在 write 后生效，所以要再次检查下分区布局

![](https://bbs.loongarch.org/assets/files/2022-06-18/1655538879-594777-cfdisk.jpg)

##### 如果原来的分区都要放弃，全盘切入到新固件新环境，有个便捷的方法

```undefined
cfdisk -z /dev/sdx
```

**它会清空你选定的设备的所有分区，一切从头来过**

分**区的结果：**  
一个EFI分区，多个linux分区  
建议：EFI分区容量200M不少，1G也不多，创建这个分区时，在cfdisk里，可以指定分区类型，选第一个EFI即可  
可以考虑建一个8G或16G的分区，后续把这个分区当交换分区用

#### 2、分区格式化操作

本例中使用的磁盘是sata接口的固态硬盘，所以系统识别为sdb，配置了6个分区，sdb1是efi分区，sdb3是要准备使用的root分区，sdb5准备当成交换分区，具体的格式化操作是：

```bash
mkfs.fat /dev/sdb1       # 将 ESP 分区格式化成 fat 文件格式，这是EFI分区的要求
mkfs.ext4 /dev/sdb3   # 将根分区格式化成 ext4 文件格式，这样更加稳定简单
mkswap /dev/sdb5      # 制作交换分区
swapon /dev/sdb5       # 交换分区使能
```

### 安装必要的基础组件

#### 1、分区挂载

进行到这个步骤，算是完成了前期的准备工作，后续是要真正安装archlinux了，建议确认如下事项：

```bash
pacman -Syy             # 检测下网络，并确认所需工具能正常使用
lsblk                            # 检查下磁盘分区，是否有效
```

接下来要做的是把准备好的分区进行挂载，以便往磁盘里安装组件，一般情况下建议使用 /mnt 这个挂载点

```bash
cd  /                                         # 到根目录
mount /dev/sdb3  /mnt          # 把准备好的根分区，挂载到 /mnt 上  
mkdir  /mnt/boot                    # 在/mnt目录下，建立一个boot目录，用于挂载efi分区
mount  /dev/sdb1  /mnt/boot     # 挂载efi分区到 /mnt/boot上
```

可以运行如下命令确认下挂载情况

```bash
df         # 如果能看到   /mnt 对应 sdb3  以及  /mnt/boot 对应sdb1，说明挂载成功
```

#### 2、使用pacstrap安装必须组件

```csharp
pacstrap   /mnt   base base-devel  linux  linux-headers  linux-firmware vi nano dhcpcd networkmanager

这个命令会启动下载安装到硬盘过程，时间长短受网络状况影响，需要等待，这个时间可以边休憩边看下载和安装这两个过程是否出错中止，整个过程结束后，可输入如下命令，进入安装系统的配置阶段
```

#### 3、生成新系统的fstab

```javascript
genfstab -U /mnt > /mnt/etc/fstab
```

#### 4、进入新系统

```perl
arch-chroot   /mnt
```

## 四、重启前要做的系统配置

### 设置时区和语言

```perl
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

hwclock --systohc

nano  /etc/locale.gen
# 如下两行前面的#号删除
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
# 保存退出

# 这个命令会根据/etc/locale.gen的配置，生成需要的locale数据
locale-gen
```

下一步是设置整个系统的首选语言。如果你的设备是服务器之类，只会以 SSH 连接，那么可以设置一个全局中文语言

```javascript
echo 'LANG=zh_CN.UTF-8' > /etc/locale.conf
```

如果这台机器一般接键盘鼠标，那么这里就设置英文 locale，不然 tty 会显示口口。进了图形界面（比如说 KDE）之后是可以在设置里把用户级别的语言设置成中文的

```javascript
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

### 设置 hostname

请把 `myarchlinux` 换成任何你喜欢的 hostname

```bash
echo 'myarchlinux' > /etc/hostname

nano  /etc/hosts
# 输入如下三行信息

127.0.0.1	localhost
::1		localhost
127.0.1.1	myarchlinux.localdomain myarchlinux

# 保存退出
```

### 设置root用户密码（超级管理员密码）

```bash
passwd 

# 因为当前用户为root，所以设置的是root用户密码，命令运行会提示输入两次密码，两次密码要保持一致。
# 因为系统当前并未设置密码规则，所以无相关限制，确保两次一样即可，此密码权限最高，注意保密。
# 设置好这个密码后，可以在任何用户环境下，通过如下命令进入超级管理员权限，比如安装软件，调整配置等

su 

# 输入正确的root密码后，可使用超级管理员权限。
```

### 建立一个普通用户

这个用户用于日常登陆，无管理员权限，确保日常操作不会对系统文件和配置进行更改，组名这里建议使用 `wheel`

```bash
# 添加新用户

useradd 用户名 -m -G 组名

例如： 
useradd   xyz -m -G wheel
```

```bash
# 设置用户登录密码

passwd 用户名

例如：
 passwd xyz
```

### 安装并配置 sudo

```undefined
pacman -S sudo vi
```

然后执行 `visudo` 并将 `%wheel` 前面的 `#` 去掉 (可按 x), 去掉之后按 `[esc]` (ESC 按键） 然后输入 `:wq` 保存退出。

现在所有在 wheel 组里面的用户就可以执行 `sudo` 命令了。

```sql
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

### 网络配置

#### 有线连接，自动获取ip的配置，两种方案任选其一，推荐方案2，进入桌面环境，可以直接管理网络连接

```bash
方案1：
systemctl enable dhcpcd

方案2：
systemctl enable NetworkManager
```

### 引导配置

这一步的配置影响到是否可以正确引导安装完成的基本系统，所以每一步都需要仔细确认：

系统引导有多个方案配置，根据需要进行选择！

#### systemd-boot 方案

龙芯推出的新固件新内核，一个突出的特性是内核支持EFI引导，这让固件直接加载linux内核成为可能。和Grub加载内核相比，系统引导所需要的时间有所缩短，改善了用户体验。具体信息详见：  
[如何把你的系统从旧世界迁移到新世界](https://bbs.loongarch.org/d/89)

指南推荐使用 systemd 内置的 systemd-boot 方案，具体配置方法如下：

在配置之前，可以使用如下命令确认下分区方案以及挂载情况

```bash
df         # 如果能看到   /mnt 对应 sdb3  以及  /mnt/boot 对应sdb1，说明挂载成功

# 需要说明的是，接下来的操作主要影响 /mnt/boot，也就是EFI分区
```

1、 安装引导管理程序

```bash
# 如下两个命令，把固件引导系统所需二进制文件和配置文件拷贝到/boot，也就是EFI分区
# 之前安装内核时，内核文件也安装在这个分区上
bootctl --path=/boot install
bootctl update
```

2、配置引导时传递给内核的参数

```bash
# 进入引导配置入口目录
cd  /boot/loader/entries

# 新建一个引导配置文件
nano arch.conf

# 把如下内容输入到arch.conf文件中

title	ArchLinux
linux	/vmlinuz-linux
initrd	/initramfs-linux-fallback.img
options	root=/dev/sdb3 rw loglevel=3 
```

**注意：root=/dev/sdb3 是指定根分区的设备名，根据实际情况进行更改，也可以使用uuid名**

3、仔细校对后保存，重启计算机

#### grub 方案

```bash
# pacman -S grub
# grub-install /dev/sda   (把sda换成你安装archlinux的硬盘名）
# grub-mkconfig /boot/grub/grub.cfg
```

重启电脑后，在EFI启动选项里面选择arch即可。

## 五、本机硬盘引导，确认archlinux基本系统安装成功

经过上述步骤设置，重启计算机后，可自动加载内核进入archlinux命令行界面  
为了便于后续的图形界面安装，使用root用户，登陆进命令行界面，需要做如下检查：

1、检查网络连接情况，运行如下命令

```undefined
pacman -Syy
```

此命令可测试网络连通情况，也可进一步确认系统的pacman配置是否正确。

2、安装一些工具软件，对系统信息进行基础检测

```bash
# 安装辅助工具软件包
pacman -S neofetch efivar 

# 查看系统信息，注意查看gpu是否正确识别
neofetch

# 查看efi固件的基本变量
efivar
```

3、添加仓库

建议添加下面所有仓库，不要为了省事只添加一部分。

```csharp
# 编辑文件
nano /etc/pacman.conf

# 查看如下内容，可根据需要进行修改定制
# 行首加#号，表示不使用这个库

[testing]
Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

[aur]
Include = /etc/pacman.d/mirrorlist
```

编辑完成后，再次运行如下命令

```undefined
pacman -Syy
```

可以使用最新的库设置，下载所有生效库的软件包数据库

## 六、图形界面组件和程序安装配置

**1、基本图形环境**

```bash
# 安装基本图形系统 xorg
pacman -S --needed xorg 

# 建议确认下如下软件包是否安装
xorg-server xf86-video-amdgpu xf86-video-ati xf86-video-loongson

# 安装 gnome 桌面环境
pacman -S --needed gnome gdm 

# gdm是 gnome 的图形登陆管理器，若准备系统引导直接进入gdm登陆，输入如下命令：

systemctl enable gdm

# 也可以不重启系统测试下gdm是否正常，可执行如下命令：

systemctl start gdm
```

```bash
**2、图形登录管理器的配置**

# 使用lightdm替换gdm，可以进行如下操作：

pacman -S --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lightdm-webkit2-greeter

systemctl disable gdm    # 取消gdm
systemctl enable lightdm
```

**3、安装更多的桌面环境**

```bash
# 安装 mate 桌面环境
pacman -S --needed mate

# 安装 xfce4 桌面环境
pacman -S --needed xfce4  xfce4-goodies
```

**4、中文输入和显示**

```shell
# 添加中文字体
pacman -S wqy-bitmapfont wqy-microhei wqy-microhei-lite wqy-zenhei
# 重建字体缓存，安装字体即刻生效
fc-cache -fv

# 安装输入法，使用拼音输入
# 方案1：使用ibus输入法引擎
pacman -S ibus ibus-libpinyin pinyin-data

# 方案2：使用fcitx输入法引擎
pacman -S --needed fcitx5 fcitx5-chinese-addons 
## fcitx 的一些词库
pacman -S fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki

# 中文处理的一些配置
# 在桌面环境启用输入法，最直观的办法是启动对应的配置界面
# 这样输入法引擎和输入法都可以进行自由切换
# 方法是双击对应的图标即可，按界面内容添加拼音即刻使用
```

**已xfce桌面环境，启动 ibus 输入法引擎为例：**

**5、常用的应用软件**

```bash
# 媒体播放，桌面环境已有播放软件，但一些解码组件需要单独安装
pacman -S  parole  gst-libav  x264 libva-vdpau-driver mesa-vdpau libvdpau-va-gl vdpauinfo ffmpeg
pacman -S libva-utils libva libva-mesa-driver libva1

# 可使用下面两个工具，查看下解码器支持信息
vainfo
vdpauinfo

# 浏览器
pacman -S firefox
pacman -S chromium

# 虚拟机软件
pacman -S qemu-full virt-manager
# 文本编辑器
pacman -S --needed kate
```
