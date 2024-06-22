---
title: 龙芯2K500先锋派OpenHarmony构建指北
author: Ayden Meng
categories: 2. 系统
toc: true
---

> 文章来源: `https://bbs.loongarch.org/d/435-2k500openharmony`

### 一、系统需求和环境配置

官方推荐系统是ubuntu 20.4，预留60G到80G的磁盘空间，交换分区推荐8G以上，主要环境是python3.9。
也可以使用Debian构建，留意python版本，python3.10及更新版本要改一行代码，才能正常运行hb构建工具。

需要安装的软件包：

```scss
sudo apt update
sudo apt upgrade
sudo apt install   apt-utils binutils bison flex bc build-essential make mtd-utils gcc-arm-linux-gnueabi u-boot-tools python3.9 python3-pip git zip unzip curl wget gcc g++ ruby dosfstools mtools default-jre default-jdk scons python3-distutils perl openssl libssl-dev cpio git-lfs m4 ccache zlib1g-dev tar rsync liblz4-tool genext2fs binutils-dev device-tree-compiler e2fsprogs git-core gnupg gnutls-bin gperf lib32ncurses5-dev libffi-dev zlib* libelf-dev libx11-dev libgl1-mesa-dev lib32z1-dev xsltproc x11proto-core-dev libc6-dev-i386 libxml2-dev lib32z-dev libdwarf-dev grsync xxd libglib2.0-dev libpixman-1-dev kmod jfsutils reiserfsprogs xfsprogs squashfs-tools  pcmciautils quota ppp libtinfo-dev libtinfo5 libncurses5 libncurses5-dev libncursesw5 libstdc++6  gcc-arm-none-eabi vim ssh locales doxygen libxinerama-dev libxcursor-dev libxrandr-dev libxi-dev npm libfl-dev
```

### 二、注册gitee账号和代码下载前的准备

源码下载推荐使用gitee的repo工具，从OpenHarmony gitee仓库下载代码，也可以使用OpenHarmony全量代码包。
参见资源链接1。使用repo工具需要gitee账号，并上传ssh公钥到账号的"ssh配置”里面，并且需要对git进行全局配置。大致过程如下：

1、使用电子邮箱注册gitee账号，如 [abc@163.com](mailto:abc@163.com)
2、使用如下命令建立公钥
`ssh-keygen -t ed25519 -C "Gitee SSH Key"`
3、获取公钥内容并复制到gitee的ssh配置里面
`cat ~/.ssh/id_ed25519.pub`
4、获取gitee repo工具并赋予可执行权限
`sudo curl -s https://gitee.com/oschina/repo/raw/fork_flow/repo-py3 > /usr/local/bin/repo`
`sudo chmod a+x /usr/local/bin/repo`
`pip3 install -i https://repo.huaweicloud.com/repository/pypi/simple requests`
5、对git进行全局配置，配置账号和选项并进行测试
`// 配置git，以abc@163.com为例，实际配置以注册账号为准   git config --global user.name "abc"   git config --global user.email "abc@163.com"   git config --global credential.helper store`
`// 测试   ssh -T git@gitee.com`

### 三、开放鸿蒙代码下载和环境配置

```kotlin
// 建立 OpenHarmony 目录
mkdir oh41
cd oh41

// 初始化
repo init -u git@gitee.com:openharmony/manifest.git -b refs/tags/OpenHarmony-v4.1-Release --no-repo-verify
// 获取源码
repo sync -c -j4
// 获取大文件
repo forall -c 'git lfs pull'
// 获取预编译工具链
./build/prebuilts_download.sh
// 安装hb
pip3 install build/hb
// 环境测试，如下命令会输出hb的命令行帮助信息
hb help
```

### 四、应用龙芯2K500先锋派相关补丁和工具链

1、系统适配龙芯部分

```php
// 这部分是2K500先锋派适配代码，处于开发状态，建议进行动态跟踪并变通使用
// dayu400是hihope适配2K500先锋派的内部代号，需要在vendor和device中都有相关的配置
// vendor/hihope/dayu400 对应 hb set 里面的产品列表，定义的内容主要是“架构”和“功能”的定义
// device/board/hihope/dayu400 目录下包括适配OpenHarmony的各种补丁、构建参数的相关定义
// device/board/soc/loongson 目录下是LoongArch架构相关代码和定义
cd vendor
rm -rf hihope  # 删除 OpenHarmony-v4.1-Release 基础代码中的 vendor/hihope 仓库
git clone https://gitee.com/openharmony-sig/vendor_hihope.git hihope
// 变通部分
cd hihope
git checkout 切换至 OpenHarmony-4.1-Release 分支

cd device/board
rm -rf hihope  # 删除 OpenHarmony-v4.1-Release 基础代码中的 device/board/hihope 仓库
git clone https://gitee.com/openharmony-sig/device_board_hihope hihope
// 变通部分
cd hihope
复制dayu210目录到临时目录
git checkout 切换至 OpenHarmony-4.1-Release 分支
粘贴dayu210目录到 hihope 目录下
```

```bash
cd device/soc
# OpenHarmony-v4.1-Release 基础代码中没有 loongson 仓库
git clone https://gitee.com/ohos4la-l1/device_soc_loongson loongson
```

2、内核部分
获取 5.10.97 版本的Linux内核代码（v4.1-Release的内核为 5.10.184版本，当前的内核补丁尚无法完美打入，暂先使用3.2-Release的5.10.97 版本的内核）

```sql
// 回到 openharmony 代码根目录
cd kernel/linux/
cp -r linux-5.10 linux-5.10.97
cd linux-5.10.97
git fetch origin OpenHarmony-3.2-Release:OpenHarmony-3.2-Release
git switch OpenHarmony-3.2-Release
```

3、导入补丁集

```cpp
// 回到openharmony 代码根目录
// 变通部分
// 拷贝device/board/hihope/dayu400/patches 到 device/soc/loongson/ 目录
// 修改 device/board/hihope/dayu400/patch.sh
cd device/board/hihope/dayu400
./patch.sh
```

4、工具链安装和配置

```php
// 回到openharmony 代码根目录
// 下载
git clone https://gitee.com/loongarch_community/loongarch64-linux-gnu.git toolchain
// 建立目录
mkdir -p prebuilts/gcc/linux-x86/loongarch/
// 解压
tar -C prebuilts/gcc/linux-x86/loongarch/ -xvf toolchain/toolchain-loongarch64-linux-gnu-gcc8-host-x86_64-2022-07-18.tar.xz
// 重命名，符合dayu400交叉编译工具链配置
mv prebuilts/gcc/linux-x86/loongarch/toolchain-loongarch64-linux-gnu-gcc8-host-x86_64-2022-07-18 prebuilts/gcc/linux-x86/loongarch/loongarch64-linux-gnu/
// 标准库的临时变通使用
cp prebuilts/gcc/linux-x86/loongarch/loongarch64-linux-gnu/sysroot/usr/lib64/libstdc++.so prebuilts/gcc/linux-x86/loongarch/loongarch64-linux-gnu/sysroot/usr/lib64/libc++.so
```

### 五、构建环境配置和编译

```rust
// 回到 openharmony 目录
hb set
选择 small -> hihope -> dayu400
// 如果没有报错信息，表示前述配置基本正确
hb build
// 所有构建都存放在 out 目录下
// 若遇到报错，可删除out目录，重新运行 set & build
```

### 六、相关资源链接

+   [https://gitee.com/openharmony/docs/blob/master/zh-cn/release-notes/OpenHarmony-v4.1-release.md](https://gitee.com/openharmony/docs/blob/master/zh-cn/release-notes/OpenHarmony-v4.1-release.md)
+   [https://gitee.com/openharmony-sig/device\_board\_hihope/tree/OpenHarmony-4.1-Release/dayu400](https://gitee.com/openharmony-sig/device_board_hihope/tree/OpenHarmony-4.1-Release/dayu400)
+   [https://gitee.com/openharmony-sig/device\_board\_hihope/blob/OpenHarmony-4.1-Release/dayu400/LS2K0500-DevGuide.md](https://gitee.com/openharmony-sig/device_board_hihope/blob/OpenHarmony-4.1-Release/dayu400/LS2K0500-DevGuide.md)
+   [http://docs.openharmony.cn/pages/v4.1/zh-cn/device-dev/subsystems/subsys-build-all.md](http://docs.openharmony.cn/pages/v4.1/zh-cn/device-dev/subsystems/subsys-build-all.md)

### 七、补充资源

构建内核所需的支持LoongArch架构的mkimage，是个u-boot工具程序

[mkimage.zip](https://bbs.loongarch.org/api/fof/download/d221fad5-8876-4235-97e0-5664644cf17e/3328/kAVs06MUPHPpp9r8BDdLNnVONXg8QGIlIGYJBP3G)
