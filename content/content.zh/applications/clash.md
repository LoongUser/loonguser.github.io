---
title: 龙芯平台使用clash
author: Ayden Meng
categories: 3. 应用
toc: true
---

## 旧世界(Loongnix)

> 来源: `https://bbs.loongarch.org/d/177-loongnixclash`

下载后:
```bash
unzip -x clash1130-loong64.zip
./clash -d dir_include_config.yaml
```

其中`dir_include_config.yaml`是`config.yaml`所在的文件夹路径.

然后在设置中, 在首选项中设置代理服务器, 或者配置环境变量:

```
http:               port:
    127.0.0.1           7890
https:              port:
    127.0.0.1           7890
socks:              port:
    127.0.0.1           7891
```

具体端口号信息在`config.yaml`中查看.

## 新世界

### Archlinux

```bash
pacman -S clash
clash -d dir_include_config.yaml
```

其中`dir_include_config.yaml`是`config.yaml`所在的文件夹路径.

然后在设置中, 在首选项中设置代理服务器, 或者配置环境变量:

```
http:               port:
    127.0.0.1           7890
https:              port:
    127.0.0.1           7890
socks:              port:
    127.0.0.1           7891
```

具体端口号信息在`config.yaml`中查看.

## Country.mmdb

```
wget https://gitee.com/mirrors/Pingtunnel/raw/master/GeoLite2-Country.mmdb -O Country.mmdb
```
