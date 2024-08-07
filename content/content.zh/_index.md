# 龙芯玩机指南

## 摘要

本仓库旨在完成一份龙芯机器的使用指南, 鉴于龙芯用户常常使用Linux, 也希望此仓库能够成为Linux用户可以借鉴的好仓库.

## 投稿及反馈

如果你有想投稿或者想知道的内容(龙芯相关), 可以给我们发邮件, 也可以直接给本仓库贡献代码:

- <aydenmeng@yeah.net>
- <dongyan0314@gmail.com>
- [https://github.com/LoongUser/loonguser.github.io.git](https://github.com/LoongUser/loonguser.github.io.git)

## 下载地址
### 手册
| 手册 | 地址 |
|-- | -- |
| 龙芯官网发布芯片文档、手册下载地址| [https://www.loongson.cn/product/channel](https://www.loongson.cn/product/channel)<br>[https://www.loongson.cn/download/index](https://www.loongson.cn/download/index) |
|龙芯社区发布架构手册下载地址|[https://loongson.github.io/LoongArch-Documentation/](https://loongson.github.io/LoongArch-Documentation/)|
 

### 固件

| 固件 | 地址 |
|-- | -- |
|社区发布固件下载地址|[https://github.com/loongson/Firmware](https://github.com/loongson/Firmware)|

### 系统

| 系统 | 地址 |
|-- | -- |
|国产镜像合集|[https://wiki.whlug.cn/project-9/](https://wiki.whlug.cn/project-9/)|
|loongnix|[http://pkg.loongnix.cn](http://pkg.loongnix.cn)|
|archlinux|[https://mirrors.wsyu.edu.cn/](https://mirrors.wsyu.edu.cn/)<br>[https://github.com/loongarchlinux/](https://github.com/loongarchlinux/)|
|龙芯软件发布|[http://www.loongnix.cn/zh/loongnix/](http://www.loongnix.cn/zh/loongnix/)|
|安同 OS (AOSC OS)|[https://aosc.io/zh-cn/](https://aosc.io/zh-cn/)|
|deepin深度系统预览版|[https://ci.deepin.com/repo/deepin/deepin-ports/cdimage/](https://ci.deepin.com/repo/deepin/deepin-ports/cdimage/)|
|内网ftp源(旧)|[http://ftp.loongnix.org/](http://ftp.loongnix.org/)|

### 代码

| 代码 | 地址 |
|-- | -- |
|github开源仓库|[https://github.com/loongson](https://github.com/loongson)|
|龙芯教育开源仓库(包含32位内核, 编译器, 固件等)|[https://gitee.com/loongson-edu](https://gitee.com/loongson-edu)|

### 社区

| 社区 | 地址 |
|-- | -- |
|LAUOSC|[https://bbs.loongarch.org/](https://bbs.loongarch.org/)|
|贴吧|[https://jump2.bdimg.com/f?kw=%E9%BE%99%E8%8A%AF&ie=utf-8](https://jump2.bdimg.com/f?kw=%E9%BE%99%E8%8A%AF&ie=utf-8)|
|龙芯问答社区|[http://ask.loongnix.org/](http://ask.loongnix.org/)|
|北京龙芯&debian 俱乐部|[https://www.bjlx.org.cn/](https://www.bjlx.org.cn/)|
|龙梦开源社区|[https://bbs.lemote.com/](https://bbs.lemote.com/)|
|龙芯俱乐部:|[http://www.openloongson.org/kl/](http://www.openloongson.org/kl/)|
|LoongArch开放社区(武老师作品)|[https://loongarch.dev/zh-cn/](https://loongarch.dev/zh-cn/)|
|loonguser(本站)|[https://loonguser.github.io/](https://loonguser.github.io/)<br>[https://loonguser.gitee.io/](https://loonguser.gitee.io/)|

### 其他

| 站点 | 地址 |
|-- | -- |
|龙芯实验室|[https://loongsonlab.github.io/](https://loongsonlab.github.io/)|
|芯创实验室文件分发站点|[https://files.loonglab.cn/](https://files.loonglab.cn/)|

## 贡献本仓库

文档目录在:`content/content.zh/`下, 按`1. 固件`, `2. 系统`, `3. 应用`分为三类, 文章`header`模板如下:

> ```markdown
> ---
> title: Grub编译与调试
> author: Ayden Meng
> categories: 1. 固件
> toc: true
> ---
> ```

`Tips`:

1. 完成后可以执行根目录下的:`./genmenu.sh`生成目录信息.
2. 想要转载的文章可以通过`https://markdown.devtool.tech/app`右上角的采集功能, 将相应网页指定的`html`元素复制后转换成`markdown`语言.
