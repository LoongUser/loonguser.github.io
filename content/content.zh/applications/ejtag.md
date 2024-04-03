---
title: 龙芯lajtag常用技巧
author: Ayden Meng
categories: 3. 应用
toc: true
---


使用串口时:

```
cd /tmp/ejtag-debug/
./la_ejtag_debug_gpio -t
source configs/configs.ls3a5000
```

在本机上运行时:
```
cd /path/ejtag-debug/
./la_ejtag_debug_usb -t
source configs/configs.ls3a5000
```

1. `cpus` 查看`pc`

2. `set` 查看通用寄存器及部分`csr`寄存器, 此时`pc`停在`set`时运行的地址.

3. `cont` 从`set`处继续运行

4. `hb` `addr`; `cont` 断点到`addr`处, 等待触发断点.

5. `hbls` 查看断点

6. `watch` `data`; `cont` 检测通用寄存器, 当通用寄存器中和`data`一致时, 断点此处.

7. `watchls` 查看数据检测点.

8. `watch` `data` `mask`; `cont` 检测通用寄存器, 当通用寄存器中和`data`一致时, 断点此处. `mask`可以设置掩码.

9. `d1`/`d4`/`d8` `addr` `length` 按照`1`字节, `4`字节, `8`字节, 依次`dump` `length`个`addr`寄存器中的值.

10. `m1`/`m4`/`m8` `addr` `data1` `data2`... 按照`1`字节, `4`字节, `8`字节, 依次将`dataX` 写入`addr`地址.

11. `disas` `addr` `length` 反汇编`addr`处开始`length`长的内容.

12. `csrs` `d8` `num` `length` 从第`num`个`csr`寄存器连续读出`length`个值.

13. `csrs` `m8` `num` `data` 向第`num`个`csr`寄存器写入`data`.

14. `gdbserver` 远程调试

15. `spi_program_flash file` 烧录flash, 注意需要配合`./la_ejtag_debug_usb`程序使用.
  ![烧录flash](/images/ejtag/ejtag.gif)

> 以下内容来源于：[https://zhuanlan.zhihu.com/p/368080970](https://zhuanlan.zhihu.com/p/368080970)

## **引言**

Ejtag分两个版本，Window版本、Linux版本。此处主要以Linux版本为例进行介绍。

## **Ejtag下载**

下载地址：**[http://ftp.loongnix.org/embedd/ls1b/ejtag/](https://link.zhihu.com/?target=http%3A//ftp.loongnix.org/embedd/ls1b/ejtag/)** Linux版本分为龙芯版和X86版本，找到自己使用的版本压缩包如下：

![](https://pic3.zhimg.com/v2-5d405c5dae750f65599b6421fbc6e982_b.jpg)

![](https://pic3.zhimg.com/80/v2-5d405c5dae750f65599b6421fbc6e982_720w.webp)

点击下载到本地。

## **Ejtag运行**

1、下载Ejtag压缩包，解压到指定目录

```text
# tar  xf  ejtag-debug-mips64-v3.25.19.tar.gz    ./
```

2、使用linux主机root用户权限(必须root或者普通用户sudo)

```text
# cd ejtag-debug/
# ./ejtag_debug_usb
```

3、检查连接状态及驱动是否正常的方法如下 a) 将Ejtag的USB口插入主机，出现红蓝灯同时亮，一秒钟之后绿灯熄灭说明硬件连接正常。 b) 输入如下命令测试Ejtag硬件状态是否正常，如jtagled 0绿灯闪烁则正常，jtagled 1绿灯长亮则正常。如下：

```text
cpu0 -jtagled 0  #绿灯进行闪烁
cpu0 -jtagled 1  #绿灯长亮
```

c) 输入usblooptest测试Ejtag硬件能及连接状态是否正常，返回“jtag loop test ok”则正常。如下：

```text
cpu0 -usblooptest 
jtag loop test ok  #连接状态正常
```

d) 输入usbver命令返回日期，则说明Ejtag硬件及连接状态正常。如下：

```text
cpu0 -usbver 
0x20150105   #连接状态正常
```

4、Ejtag端连接板卡 a) 将USB端拔下， b) 板卡为断电模式； c) 将Ejtag接口端的三角号对准板卡上的1脚进行插入。(注意：此步骤一定要插正确，此步插错执行下面的步骤有可能烧坏CPU或者Ejtag调试器) d) 检查连接无误，将USB端口插入主机，板卡上电。连接如下图：

![](https://pic1.zhimg.com/v2-16fa8e9edb55c79551a86d23a274dc74_b.jpg)

![](https://pic1.zhimg.com/80/v2-16fa8e9edb55c79551a86d23a274dc74_720w.webp)

5、进入Ejtag加载指定的平台配置文件，根据要调试板卡的平台选择不同的配置文件

```text
 #在3A4000平台上使用的配置文件
cpu0 -source configs/config.ls3a4000
 #在3A3000平台上使用的配置文件
cpu0 -source configs/config.ls3a3000
 #在3A2000平台上使用的配置文件
cpu0 -source configs/config.ls3a2000
```

## **Ejtag使用**

1、加载配置文件之后可以，采用如下方法确保板卡与主机之间连接正常。 a) 采用cpus命令读取CPU各个核的PC值。正常如下：

```text
cpu0 -cpus
#说明主机通过Ejtag能够抓到目前板卡上CPU的运行到的地址。
#cpus
[00] 0xffffffff9fc06030 [00] 0xffffffffbfc06600 [00] 0xffffffffbfc06600 [00] 0xffffffffbfc06600
```

异常如下：

```text
cpu0 -cpus
#cpus
[00] 0x00000000 [00] 0x00000000 [00] 0x00000000 [00] 0x00000000   #说明无法访问到板卡上CPU的运行状态。
```

出现异常，请检查前面步骤是否正确或者确认板卡上电启动是否正常。 b)采用set命令读取核上的通用寄存器。正常如下：

```text
cpu0 -set
#set

zero:0x0 at:0x10c80 v0:0xffffffffbfe001e0 v1:0xffffffffbfe001e0 
a0:0x0 a1:0x40 a2:0xffffffffbfc022b8 a3:0xffffffffffffffff 
t0:0x900010001fe001c0 t1:0x84000000c84 t2:0xffffffffbbd0020c t3:0x400000 
t4:0x0 t5:0x0 t6:0x2c24848100888010 t7:0x81000200008c8c40 
s0:0x30300000 s1:0x0 s2:0x48a0a03812a04408 s3:0x800010a03c80000c 
s4:0xffffffffbfe00000 s5:0x2200804020400908 s6:0x303400905c601904 s7:0x4830092800248640 
t8:0x8060840014aa2620 t9:0xa08828186e9706 k0:0x1c42408808405808 k1:0x4288ca184404101 
gp:0xffffffff8f998000 sp:0xffffffff8f8fc000 s8:0x372002504000604 ra:0xffffffffbfc022b8 
status:0x4000e0 lo:0x0 hi:0x0 badvaddr:0x1634e0124cd64658 
cause:0x40008000 pc:0xffffffffbfc022e8 epc:0x8884c964c0020b4c
```

能够看到通用寄存器目前的状态。 异常如下：

```text
cpu0 -set
#set
```

会出现set命令卡住的现象，请检查前面步骤是否正确或者确认板卡上电启动是否正常。 通常使用这两种方法来判断调试过程中的板卡是否能正常上电运行。 2、常用命令 ①　h 查看帮助 格式：

```text
h [cmd]
```

②　cpus 读取当前CPU各个核运行的地址。通常结合代码反汇编来寻找CPU卡在哪个地方，方便进一步定位问题。 格式：

```text
cpus [count[,cpubitmap]]
```

③　set 读写CPU的通用寄存器。通过用来判断CPU核是否处于运行状态；从sp/ra/status/cause/pc/epc等寄存器信息来定位板卡异常。 格式：

```text
set [regname|regno] [value]
```

例子：

```text
cpu0 -set    #读出所有通用寄存器
cpu0 -set pc #读pc寄存器
cpu0 -set at #读at寄存器
#设置pc的数值是0xffffffffbfc00000
cpu0 -set pc 0xffffffffbfc00000 
```

④　cont 是continue的意思，退出Ejtag状态继续运行。一般常用于set命令停住CPU之后让CPU继续运行。 格式：

```text
cont
```

⑤　d1/d4/d8 是dump的意思，读取CPU、设备相关寄存器或者内存地址。 格式：

```text
d1 [addr] [count]             :dump memory (byte)
d4 [addr] [count]             :dump memory (word)
d8 [addr] [count]             :dump memory (double word)
```

例子：

```text
cpu0 -d1 0xffffffffbfe00180 0x1 
#d1 0xffffffffbfe00180 0x1
ffffffffbfe00180: 80                                              .
cpu0 -d4 0xffffffffbfe00180 0x1
#d4 0xffffffffbfe00180 0x1
ffffffffbfe00180: ff003180                            .1..
cpu0 -d8 0xffffffffbfe00180 0x1
#d8 0xffffffffbfe00180 0x1
ffffffffbfe00180: 3700ff00ff003180                  .1.....7
```

⑥　m1/m4/m8是modify的意思，改变写入寄存器或者内存地址新的数据。 格式：

```text
m1 [addr]  [value]            :modify memory (byte)
m4 [addr]  [value]            :modify memory (word)
m8 [addr]  [value]            :modify memory (double word)
```

例子：

```text
cpu1 -m1 0xffffffffbfe001e0 0x18
#m1 0xffffffffbfe001e0 0x18
cpu1 -d1 0xffffffffbfe001e0 0x1 
#d1 0xffffffffbfe001e0 0x1
ffffffffbfe001e0: 18 
```

m4/m8操作类似。 ⑦　setconfig 设置CPU调试相关的一些配置等。 格式：

```text
setconfig [configname] [val]  :setconfig for command
```

常用参数：

```text
core.cpucount  #设置cpu数目
core.cpuno     #设置当前调试的cpu号
core.cpuwidth  #设置cpu的数据宽度
```

例子：

```text
cpu0 -setconfig core.cpuno 3
#切换到CPU3上进行调试 
#setconfig core.cpuno 3  
cpu3-
#该设置的快捷指令
cpu3 -cpu 2 
#cpu 2 
#setconfig core.cpuno 2 
cpu2 -
```

⑧　disas 反汇编addr开始的count条指令。 格式：

```text
disas [addr] [count]          :disas memory
```

例子：

```text
cpu3 -disas 0xffffffffbfe00180 0x4
#disas 0xffffffffbfe00180 0x10
0xffffffffbfe00180: ff003180 sd zero,12672(t8)
0xffffffffbfe00184: 3700ff00 ori zero,t8,0xff00
0xffffffffbfe00188: 00000780 sll zero,zero,0x1e
0xffffffffbfe0018c: 00000101 0x101
```

⑨　put/fput/sput 上传文件到板卡。 格式：

```text
put filename address [len] [offset], env: put_speed
```

例子：

```text
cpu0 -put gzrom.bin 0xffffffff84000000 
#put gzrom.bin 0xffffffff84000000 
pack: 0,time : 2, download_size : 0xac010, download rate=352264 B/S
cpu0 -
```

该命令常用于定位PMON启动过程中拷贝gzrom.bin二进制到内存出现异常时，是由于内存不稳定导致还是flash有问题导致。同时也用于定位内核加载过程中卡死，来确定存储介质接口问题还是内存问题的的判断。 get/fget/sget 从addr开始的内存地址下载size大小内容存在file中。 格式：

```text
get filename address size
```

例子：

```text
cpu0 -get gzrom.bin.new 0xffffffff84000000  0xac010
#get gzrom.bin.new 0xffffffff84000000  0xac010
time : 7, size : 0xac010, upload rate=100646 B/S
cpu0 -
```

该命令常用于定位系统卡死时，导出log\_buf中未存入到硬盘上的dmesg内核日志，便于排查系统卡死之前有没有异常现象记录在内核日志中。 3、Ejtag的应用实例 a) 烧写PMON固件

```text
cpu0 -source configs/config.ls3a2000
cpu0 -call program_cachelock #烧写3A1000/3A2000 LPC接口的flash
或者：
cpu0 -source configs/config.ls3a4000
cpu0 -call program_cachelock_spi #烧写3A3000/3A4000 SPI接口的flash
```

烧写过程中可能会出现，烧写不成功卡住的情况。通过如下方法进行尝试： ①　在“cpu0 -call program\_cachelock”之前关闭看门狗cpu0 -wdt\_close，然后进行烧写操作。 ②　在“cpu0 -call program\_cachelock”之前先使用set命令停住CPU然后进行烧写操作。 ③　多次尝试均无效果可以更新以下Ejtag的驱动版本试一试。 b)连接gdb定位系统卡死的问题 如果CPU某个核出现卡死的现象 这种情况时无法运行gdbserver的，因此需要屏蔽掉卡死的核。就可以进入gdbserver了。 命令如下：

```text
cpu1 -setconfig core.cpuno 0  #切换到核0
cpu0 -setconfig gdbserver.cpubitmap 0xd  #屏蔽掉核1
cpu0 -gdb #启动gdb
```

使用Ejtag中的gdbserver与开发机gdb连接方法：

```text
cpu0 -gdbserver  #port 50010
```

开发机端： 进入gdb

```text
#gdb
```

链接gdbserver

```text
gdb) target remote :50010
Remote debugging using :50010
```

接下来就可以使用gdbserver进行问题定位了。

**想了解更多相关知识请关注公众号。**
