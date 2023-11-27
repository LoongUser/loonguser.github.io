---
title: Qemu使用
author: Ayden Meng
categories: 3. 应用
toc: true
---

```
pacman -S qemu-system-loongarch64
wget https://github.com/loongson/Firmware/raw/main/LoongArchVirtMachine/edk2-loongarch64-code.fd -O edk2-loongarch64-code.fd
qemu-system-loongarch64 -m 4G -smp 1 --cpu la464 --machine virt -bios edk2-loongarch64-code.fd  --serial stdi
```

