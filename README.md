# Distro-From-Scratch (Second Edition)
This project allows you to create **your own** distro of *[Linux](https://www.linux.org/)*.

## Parts
1. [Dependencies](#dependencies)
2. [Cloning](#cloning)
3. [Editing](#editing)
4. [Building](#building)

## Dependencies
In order to start, make sure you have any *[Linux](https://www.linux.org/)* distro installed. Then, in the terminal, type this command:
```
sudo apt get install bzip2 git vim make gcc libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux dosfstools
```

### Explanation
`sudo` - requires administrator permission

`apt get` - package manager

`install` - pretty self-explanatory


## Cloning
Now, *we* have to clone the Linux source code. To do it, write this command in your terminal:
```
git clone --depth 1 https://github.com/torvalds/linux.git
```
After that, go to the *`linux`* directory by writing in `cd linux`.

## Editing
Now, *we* have to edit the **kernel** by editing the **options**. Type this in your terminal:
```
make menuconfig
```

### Explanation
This command (`make menuconfig`) opens a *interactive menu* to edit the options. **MAKE SURE `64 bit kernel (NEW)` IS SELECTED!!**

## Building

After doing the `menuconfig`, if you have more than *6 cores* on your *CPU* you can make it build with more than *6 cores* by writing this command in your terminal.

`make -j (AMOUNT OF CPU CORES YOU HAVE AS A INTEGER)`

After the kenel finished compiling (GENTOO MOMENT) you will see a message with `bZimage`, make a directory named `boot-files`
```
mkdir /boot-files
```
then copy the `bZimage` to the `boot-files` directory
```
cp arch/x86/boot/bzImage /boot-files
```
`bzImage` is a file for booting the system
cd back
```
cd ..
```
now clone busybox
```
git clone --depth 1 https://git.busybox.net/busybox
```
then enter `busybox` directory
```
cd busybox
```
then make the `menuconfig`
```
make menuconfig
```
go to `settings > Build static binary (no shared libs) (NEW)` select it now save, the reason we made `static` build is because we do not want external binaries now with the amount of cores you have run `make -j <cores>` like for example
```
make -j 8
```
after busybox finished compiling make an `initramds`
```
mkdir /boot-files/initramfs
```
now run 
```
make CONFIG_PREFIX=/boot-files/initramfs install
```
initramfs is the initial file system the kernel loads after booting we will put busybox over there
now move to that folder
```
cd /boot-files/initramfs/
```
now create a file called `init`
```
nano init
```
now add these commands to `init`
```
#!/bin/sh

/bin/sh
```
now save it
now delete `linuxrc` no need for that file
```
rm linuxrc
```
now add exec permessions to init
```
chmod +x init
```
now find then pack it to a `.cpio` archive
```
find . | cpio -o -H newc > ../init.cpio
```
`-o` means create a new archive now go 1 dir back
```
cd ..
```
now the file has been created use `ls` to see it, but we will use a bootloader called `syslinux` 
make the bootfile
```
dd if=/dev/zero of=boot bs=1M count=50
```
this will make a file that is 50-100 megabytes and it will filled with zeros
we will use the `fat` filesystem
```
mkfs -t fat boot 
```
then run
```
syslinux boot
```
now make a directory called anything but for safety we will use `m` then mount boot to m
```
mkdir m
mount boot m
```
then copy the kernel and initramfs to the `boot` fs
```
cp bzImage init.cpio m
```
now unmount it
```
unmount m
```
now the boot image is ready so we will boot it up
```
qemu-system-x86_64 boot
```
syslinux will boot up and will ask what file to boot use 
```
/bzImage -initrd=init.cpio
```

Links
[`DFS GUI`](https://github.com/GuestSneezeOSDev/DFS/tree/main/GUI)
[`DFS For Embedded Devices`](https://github.com/GuestSneezeOSDev/DFS/tree/main/embedded)
