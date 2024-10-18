---
weight: 10
---

# 龙芯固件说明

## 1. UEFI固件名中的信息

如在`github`上发布的固件名:`UDK2018_3A5000-7A2000_Desktop_EVB_V4.0.05429-stable202302_dbg.fd`

`UDK2018`指基于`EDK2018`版本代码开发.

`3A5000-7A2000_Desktop`指适用于`3A6000+7A2000`的桌面级板卡.

`EVB`指是开发板, 通常是龙芯各产品研发早期放出的板卡, 与之相对的有`CRB`, `A2101`等, 通常与板卡厂商强相关.

`V4.0.05429-stable202302`指版本号, `stable202302`指发布日期:年/月, 通常与`edk2`的上游代码的`tag`保持一致. `V4.0.xxxx`是基础版本号，针对普通用户，仅需要关心`tag`内容即可.

`dbg`指`debug`版本, 表示有串口打印信息. 与之相对的是`rel`(`release`版本), 即没有串口打印, 启动会较快. 另外还有`fastboot`等, 表示更快速的启动版本, 而`fastboot`启动也代表着部分驱动不会完全初始化, 所以针对需要调试板卡的用户来说, 不建议使用`fastboot`版本.

## 2. PMON固件名中的信息

如有些用户拿到的初始固件为:`UEFI_3A6000x1-7A2000_C2g_D3g2_N1v15_P1v15_PtwOff_v2.4.1017.4963ab`. 或者`PMON_3A6000x1-7A2000_C2g_D3g2_N1v15_P1v15_PtwOff_v2.4.1017.4963ab`.

`C2g`指`CPU Freq 2g`

`D3g2`指`Ddr Freq 3.2g`

`N1v15`指`Vddn 1.15v`

`P1v15`指`Vddp 1.15v`

`PtwOff`指关闭了`ptw`

`v2.4.1017.4963ab`指当世纪`20`年代, 第`4`年, `10🈷️17日`, `commit`号是`4963ab`

这种通常是用于调试, 或早期非正式版固件.

*注: 自2024年9月后, PMON的版本号修改为`Version202409`等类似字样.*


## 3. 固件更新方法

见[如何更新固件](firmware)

## 4. 找到适合的固件

```bash
dmidecode -t 1
```

根据相关信息查找固件. 不明白的可以找售后咨询.

## 5. Q&A

- `PMON`与`UEFI`有什么区别，分别用在什么场景下？

> `pmon`功能和界面比较简单，方便调试，通常用在嵌入式场景，当然桌面端也支持.
> `uefi`功能和界面比较丰富，但调试比较复杂，所以嵌入式场景通常不用，但是`bmc`等服务器管理软件通常与`uefi`有强配合，所以`uefi`通常用在桌面和服务器领域。


- `PMON`与`UEFI`的烧录方式可以通用吗?

> 烧录`PMON`或者`UEFI`, 都是针对`Flash`的烧写, 即是通用的. 换句话说, 使用`PMON`时, 可以在`PMON`的命令行下执行`fload`命令烧写`UEFI`固件, 使用`UEFI`时, 可以在`UEFI`的`Shell`下执行`spi -u`命令烧录`PMON`固件.
> 值得注意的是, `UEFI`下通常配备交互界面更友好的烧录方式, 比如`更新固件`的选项, 当使用此方式烧录固件时, 会检查目标文件的格式, 所以不能通过此方式烧录`PMON`.
> 另外, 烧写器无视任何软件区别.

## 6. 已知板卡与固件对应关系

### 3A5000

| 板卡名 | dmidecode | 图片样例 |
| --- | --- | --- |
| `3A5000+7A2000产品/开发板v1.4/v1.5` | `dmidecode -t 1` : Loongson-3A5000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A5000-7A2000-EVB | ![](/images/firmware/Image/3A5000-7A2000-EVB.png) |
| `3A5000+7A2000开发板v1.0/v1.2/v1.21` | `dmidecode -t 1` : Loongson-3A5000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A5000-7A2000-EVB | ![](/images/firmware/Image/3A5000-7A2000-v1.0.png) |
| `3A5000+7A1000开发板v1.0/v1.2/v1.21` | `dmidecode -t 1` : Loongson-3A5000-7A1000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A5000-7A1000-EVB | ![](/images/firmware/Image/3A5000-7A1000-v1.21.png) |
| `3A5000+7A1000产品板` | `dmidecode -t 1` : Loongson-3A5000-7A1000-1w-V0.1-CRB<br>新版`dmidecode -t 1` : Loongson-3A5000-7A1000-CRB | ![](/images/firmware/Image/L5BMB01-CRB.jpg) |
| `3A5000+7A2000产品板` | `dmidecode -t 1` : Loongson-3A5000-7A2000-1w-V0.1-CRB<br>新版`dmidecode -t 1` : Loongson-3A5000-7A2000-CRB | ![](/images/firmware/Image/LSA5A2P2.jpeg) |
| `3A5000+7A1000龙梦板卡` | `dmidecode -t 1` : LM-LS3A5000-7A1000-1w-V01-pc_A2101 | ![](/images/firmware/Image/A2101.jpg) |
| `3A5000+7A2000龙梦板卡` | `dmidecode -t 1` : LM-LS3A5000-7A2000-1w-V01-pc_A2201 | ![与A2101类似](/images/firmware/Image/A2101.jpg) |
| `3A5000+7A1000/THTF板卡` | `dmidecode -t 2` : THTF-3A5000-7A1000-ML5A | ![](/images/firmware/Image/ML5A.jpg) |
| `3A5000+7A2000/THTF板卡` | `dmidecode -t 2` : THTF-3A5000-7A1000-ML5C | ![](/images/firmware/Image/ML5C.jpg) |
| `3A5000+7A1000/THTF笔记本` | `dmidecode -t 2` : THTF-3A5000-7A1000-THTF | ![](/images/firmware/Image/L71.jpg) |
| `3A5000+7A2000/LM-A2207笔记本` | `dmidecode -t 2` : LM-LS3A5000-7A2000-1w-V01-pc_A2207 | ![](/images/firmware/Image/) |
| `3A5000+7A2000/航天706所笔记本` | `dmidecode -t 2` : 706-LS3A5000-4-V1.0-B40L-41A1 | ![](/images/firmware/Image/TR41A1.jpg) |

### 3A6000
| 板卡名 | dmidecode | 图片样例 |
| --- | --- | --- |
| `3A6000+7A2000开发板XA61200` | `dmidecode -t 1` : Loongson-3A6000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A6000-7A2000-XA61200 | ![](/images/firmware/Image/XA61200.jpg) |
| `3A6000+7A2000开发板XA612A0` | `dmidecode -t 1` : Loongson-3A6000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A6000-7A2000-XA612A0 | ![](/images/firmware/Image/XA612A0.jpg) |
| `3A6000+7A2000开发板XA612B0` | `dmidecode -t 1` : Loongson-3A6000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A6000-7A2000-XA612B0 | ![](/images/firmware/Image/XA612B0_v1.0.png) |
| `3A6000+7A2000开发板XA61201` | `dmidecode -t 1` : Loongson-3A6000-7A2000-1w-V0.1-EVB<br>新版`dmidecode -t 1` : Loongson-3A6000-7A2000-XA61201 | ![](/images/firmware/Image/XA61201_v1.0.png) |

### 服务器板卡

| 板卡名 | dmidecode | 图片样例 |
| --- | --- | --- |
| `3C5000服务器` | `dmidecode -t 1` : Loongson-LS2C50C2 | ![](/images/firmware/Image/LS2C50C2.png) |
| `3C5000L服务器` | `dmidecode -t 1` : Loongson-LS2C5LE | ![](/images/firmware/Image/LS2C5LE.jpg) |
| `3C5000L+7A1000大别山服务器` | `dmidecode -t 1` : Loongson-3C5000L-7A1000-2w-V0.1-EVB | ![](/images/firmware/Image/LS2C5LE.jpg) |
| `3C5000服务器` | `dmidecode -t 1` : Loongson-LS4C5LG | ![](/images/firmware/Image/LS4C5LG.jpg) |
