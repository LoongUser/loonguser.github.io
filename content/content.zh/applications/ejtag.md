---
title: 龙芯lajtag常用技巧
author: Ayden Meng
categories: 3. 应用
toc: true
---


```
cd /tmp/ejtag-debug/
./la_ejtag_debug_gpio -t
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

14. gdbserver

15. spi_program_flash
