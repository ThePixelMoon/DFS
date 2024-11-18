# Distro-From-Scratch (Second Edition)
This project allows you to create **your own** distribution of *[Linux](https://www.linux.org/)*.

### Contents
1. [Dependencies](#dependencies)

    1.1. Explanation

2. [Cloning](#cloning)
3. [Editing](#editing)

    3.1. Explanation

4. [Building](#building)
5. [bZimage](#bzimage)
6. [BusyBox](#busybox)
7. [Initramfs](#initramfs)

    7.1. Explanation

8. [Bootfile](#bootfile)
9. [Booting](#booting)

## Dependencies
In order to start, make sure you have any *[Linux](https://www.linux.org/)* distribution (preferably [Debian](https://www.debian.org/)) installed. Then, in the *terminal*, type this command:
```
sudo apt get install bzip2 git make gcc libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux dosfstools
```

### Explanation
`sudo` - requires administrator permission

`apt get` - package manager

`install` - pretty self-explanatory


## Cloning
Now, *we* have to clone the Linux source code. To do it, write this command in your *terminal*:
```
git clone --depth 1 https://github.com/torvalds/linux.git
```
After that, go to the *`linux`* directory by writing in `cd linux`.

## Editing
Now, *we* have to edit the **kernel** by editing the **options**. Type this in your *terminal*:
```
make menuconfig
```

### Explanation
This command (*`make menuconfig`*) opens a *interactive menu* to edit the options. **MAKE SURE `64 bit kernel (NEW)` IS SELECTED!!**

## Building

After doing the `menuconfig`, if you have more than *6 cores* on your *CPU* you can make it build with more than *6 cores* by writing this command in your *terminal*.

*`make -j (AMOUNT OF CPU CORES YOU HAVE AS A INTEGER)`*

## bZimage

After the *kernel* finished compiling, you'll see a message about *`bZimage`*. You should create a directory called `boot-files`. Type this in your *terminal*:

`mkdir /boot-files`

After you created the directory, copy the *`bZimage`* directory into the *`boot-files`* directory. Enter this command in your *terminal* in order to do that:

`cp arch/x86/boot/bzImage /boot-files`

After you did it, go one directory back with this command:

`cd ..`

## BusyBox
> BusyBox: The Swiss Army Knife of Embedded Linux

After you've done all that, you should clone BusyBox. Do it with this command:

`git clone --depth 1 https://git.busybox.net/busybox`

..and then enter the *`busybox`* directory with: `cd busybox`

----

When you are in the *BusyBox* directory, do *`menuconfig`* again. (*`make menuconfig`*, in case you forgot)

After that, you should be in the *interactive menu*. Go to *`Settings > Build Static Binary (no shared libs) (NEW)`*, select it and save.

The reason *we* picked *`static`* is because *we* do **not** want external binaries.

After *you* did all that, type in: *`make -j (AMOUNT OF CPU CORES YOU HAVE AS A INTEGER)`*, the same thing we did when building the kernel.

## Initramfs

After *BusyBox* finished compiling, make a *directory* called *`Initramfs`* in *boot-files*. (*`mkdir /boot-files/initramfs`*)

After *you've* created the directory, run this command:

`make CONFIG_PREFIX=/boot-files/initramfs install`

### Explanation

**Initramfs** is the *initial file-system* the kernel loads after booting. We will move *BusyBox* over there.

Now move to the *`initramfs`* directory (*`cd /boot-files/initramfs/`*), *and* create a new *file* called *`init`*. (*`nano init`*)

When you're in the `nano` editor (inside the *file*, of course), write this in the file:
```
#!/bin/sh

/bin/sh
```
, and save it. *Now*, delete the *`linuxrc`* file, there is absolutely **no need** for it. (*`rm linuxrc`*)

After you did that, add *execution* permissions to the *`init`* file. (*`chmod +x init`*)

Now do *`find`*, and pack it into a *`.cpio`* archive. (*`find . | cpio -o -H newc > ../init.cpio`*)

### Explanation

*`-o`* means creating a new archive

----

Now go 1 directory back (*`cd ..`*). The file is created, you can use *`ls`* to see it, but *we* will use a *bootloader* called *`syslinux`*.

## Bootfile

Now, make the bootfile. *`dd if=/dev/zero of=boot bs=1M count=50`*

### Explanation

This *command* will create a file that is around *50-100 MB*, and it will be filled with zeros. (*/dev/zero*)

----

After you typed in the command, use the *`FAT`* filesystem (*`mkfs -t fat boot`*), and then run *`syslinux boot`* .

Now make a directory (*no matter the name, but we will use `m` for safety*) called *`m`*, and then *mount* the *boot* to *`m`*.
```
mkdir m
mount boot m
```

After you created the *`m`* directory, copy the *kernel* and *initramfs* to the *`boot`* filesystem. (*`cp bzImage init.cpio m`*)

Then, *unmount* it. (*`unmount m`*)

## Booting

Now, the *boot image* is ready, so *we* will boot it up. (*`qemu-system-x86_64 boot`*)

After you wrote the command, *`syslinux`* will boot up and ask which *bootfile* to use. (*`/bzImage -initrd=init.cpio`*)

**Thanks for reading!**

----

Links

[`DFS GUI`](https://github.com/GuestSneezeOSDev/DFS/tree/main/GUI)

[`DFS For Embedded Devices`](https://github.com/GuestSneezeOSDev/DFS/tree/main/embedded)
