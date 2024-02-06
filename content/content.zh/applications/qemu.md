---
title: Qemu使用
author: Ayden Meng
categories: 3. 应用
toc: true
---


## 部分环境准备:

qemu: [https://gitlab.com/qemu-project/qemu.git](https://gitlab.com/qemu-project/qemu.git)

固件: [https://github.com/loongson/Firmware/raw/main/LoongArchVirtMachine/edk2-loongarch64-code.fd](https://github.com/loongson/Firmware/raw/main/LoongArchVirtMachine/edk2-loongarch64-code.fd)

系统: [http://pkg.loongnix.cn/loongnix/isos/Loongnix-20.5/](http://pkg.loongnix.cn/loongnix/isos/Loongnix-20.5/)


## qemu安装

```
# Arch系
pacman -S qemu-system-loongarch64

# Debian系
apt install qemu-system-loongarch64

# Fedora系
yum install qemu-system-loongarch64
```

自己编译安装:

```
git clone https://gitlab.com/qemu-project/qemu.git
cd qemu
mkdir build4la
cd build4la
../configure --target-list=loongarch64-softmmu --enable-kvm --disable-werror --enable-vnc --enable-debug --enable-gdb
make -j 8
```

## qemu使用

### qemu启动固件:

```
./qemu-system-loongarch64 -m 4G -smp 1 --cpu la464 --machine virt -bios edk2-loongarch64-code.fd -display none --serial stdio
```

参数说明:

`./qemu-system-loongarch64`: 这是QEMU模拟器的可执行文件，用于模拟LoongArch64架构的系统。

`-m 4G`: 指定为虚拟机分配4GB内存（4096MB）。

`-smp 1`: 设置虚拟机的CPU核心数为1个。

`--cpu la464`: 指定要使用的虚拟CPU类型为la464，这是Loongson公司基于LoongArch架构的CPU型号或特性标识。

`--machine virt`: 指定虚拟机的机器类型为“virt”，这是一个通用的、基于QEMU内部模型的虚拟机平台。

`-bios edk2-loongarch64-code.fd`: 使用名为edk2-loongarch64-code.fd的固件镜像作为UEFI BIOS。这通常是一个包含UEFI固件实现的文件，用于在虚拟机启动时加载和执行。

`-display none`: 关闭图形显示输出，意味着虚拟机不会打开一个窗口来显示图形界面。

`--serial stdio`: 将虚拟机的串行端口连接到主机的标准输入/输出。这样，虚拟机的控制台输出将通过主机的终端进行显示，可以与虚拟机进行交互。

综上所述，该命令是在QEMU中启动一个具有1个CPU核心、4GB内存的LoongArch64架构虚拟机，并使用特定的UEFI固件镜像引导，同时将虚拟机的控制台输出重定向到主机终端。

### qemu通过固件启动系统

```
./qemu-system-loongarch64 -m 4G -smp 1 --cpu la464 --machine virt -bios ../../qemu-kernel-debug/edk2-loongarch64-code.fd -display none  --serial stdio -device virtio-gpu-pci -device nec-usb-xhci,id=xhci,addr=0x1b -device usb-tablet,id=tablet,bus=xhci.0,port=1 -device usb-kbd,id=keyboard,bus=xhci.0,port=2 -net nic,model=virtio -net user,hostfwd=tcp::10021-:22 -hda ../../qemu-kernel-debug/Loongnix-20.5.mate.mini.loongarch64.cn.qcow2 --accel kvm
```

基于上节, 其余的参数说明:

`-device virtio-gpu-pci`: 添加一个virtio GPU设备（PCI总线上的图形卡）以支持图形加速。

`-device nec-usb-xhci,id=xhci,addr=0x1b`: 添加USB 3.0控制器（nec-usb-xhci），并赋予ID为xhci，地址为0x1b。

`-device usb-tablet,id=tablet,bus=xhci.0,port=1`: 添加一个USB触摸板设备，并将其连接到之前定义的USB控制器上，端口号为1。

`-device usb-kbd,id=keyboard,bus=xhci.0,port=2`: 添加一个USB键盘设备，并同样连接到前述USB控制器上，端口号为2。

`-net nic,model=virtio`: 添加一个virtio类型的网络接口卡（NIC）。

`-net user,hostfwd=tcp::10021-:22`: 启用用户模式网络堆栈，同时设置端口转发规则，将主机的10021端口转发到虚拟机的22端口（通常这是SSH服务端口）。

`-hda Loongnix-20.5.mate.mini.loongarch64.cn.qcow2`: 指定虚拟机硬盘映像路径，这里是一个名为“Loongnix-20.5.mate.mini.loongarch64.cn”的qcow2格式磁盘镜像。

`--accel kvm`: 如果宿主机支持KVM硬件虚拟化技术，则启用加速功能以提高虚拟机性能。

总结：这个命令是启动了一个带有特定硬件设备配置的LoongArch64虚拟机，包括内存、CPU、显卡、USB控制器、USB外设、网络适配器以及硬盘驱动，并使用KVM加速功能，还设置了端口转发规则以便从主机访问虚拟机中的服务。


<!--
### qemu直接启动系统

```

```
-->

### qemu文件系统挂载与卸载

```
modprobe nbd max_part=16
qemu-nbd -c /dev/nbd0 ./Loongnix-20.5.mate.mini.loongarch64.cn.qcow2
fdisk -l /dev/nbd0
mount /dev/nbd0p2  /mnt/
umount /mnt
```

在mount之后可以进行文件操作.

<!--
## qemu+gdb调试

```
./qemu-system-loongarch64 -m 4G -smp 1 --cpu la464 --machine virt -bios ../../qemu-kernel-debug/edk2-loongarch64-code.fd -display none  --serial stdio -device virtio-gpu-pci -device nec-usb-xhci,id=xhci,addr=0x1b -device usb-tablet,id=tablet,bus=xhci.0,port=1 -device usb-kbd,id=keyboard,bus=xhci.0,port=2 -net nic,model=virtio -net user,hostfwd=tcp::10021-:22 -hda ../../qemu-kernel-debug/Loongnix-20.5.mate.mini.loongarch64.cn.qcow2 -s -gdb tcp::1234
```
-->
