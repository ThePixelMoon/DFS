# How to make a DFS GUI OS (Lightweight 600 MB)
# Chapter 1 Building the GUI and Kernel
To make a simple user-friendly graphical linux distro  we will use a couple of components and out them together
we will use the 6.10 kernel but we need wget
```
apt install wget
```
now use wget to get the kernel
```
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.xz
```
now we need a few dependencies to compile the kernel
```
apt install bzip2 libncurses-dev flex bison bc libelf-dev libssl-dev xz-utils autoconf gcc make libtool git vim libpng-dev libfreetype-dev g++ extlinux
```
now we need to extract the kernel
```
tar xf linux-6.10.tar.xz
```
now go to the kernels foldder and make a menuconfig
```
cd linux-6.10.tar.xz
make menuconfig
```
now select `Device Drivers > Graphic support > Cirrus drivers` enable it then enable `Frame buffer devices > support for frame buffer devices` go back to graphic support and select `bootup logo`
then enable mouseedev search with `/`  and select 1 then enable `mouse interface` then exit and save
then run `make -j <amount of cores you hvae>` this allows you to make and compile it like for example
```
make -j 8
```
you will have a compiled kernel called `bzImage` but first make a directory called `/distro` 
```
mkdir /distro
```
then copy the bzimage to the /distro directory
```
cp arch/x86/boot/bzImage /distro
```
then we will use busybox to make the distro it is a userspace
```
wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
```
now extract
```
tar xf busybox-1.36.1.tar.bz2
```
now enter the directory
```
cd busybox-1.36.1
```
then make a menu config
```
make menuconfig
```
now make it compile statically not dynamically `settings > build static library (No shared libs) (NEW) `then exit and save
now compile it with `make -j <amount of cores>` for example
```
make -j 8
```
then make a config prefix to where it should install busybox
```
make CONFIG_PREFIX=/distro install
```
we finsihed busybox now continue with the distro
now we need to use a wm but for this tutorial we will be using Nano-X/Microwindows if you remember we enabled frame buffer support that is why we did that
```
git clone https://github.com/ghaerr/microwindows.git
cd microwindows
```
navigate to the `src/` folder
```
cd src/
```
we will build it with the Linux Hardware buffer config
```
cp Configs/config.linux-fb config
```
we will change somethng in the configuration which will be needed afterwards nano the config and search for NX 11
```
nano config
```
CTRL + W search for NX11 change it from `N` to `Y` After that hit CTRL + S then hit CTRL + X now run make
```
make
```
if you see any errors such as X11/Xlibh.h or similar follow these steps
nano into the nx11 folder
```
nano nx11/Makefile
```
now comment `X11_INCULDE=$(X11HDRLOCATION)` and uncomment the line after it ` X11_INCLUDE=./x11-local` this will allow ityo use it with the folder that comes with project now save and exit
then make it
```
make
```
after it finshed building successfully now type 
```
make install
```
after finishing installing the libraries and headers you can port an existing X11 application
## Chapter 2 Porting apps and Fixing the GUI
port an x11 apps by using there source code the source code is a type of code which allows you to build it with your own modifications for this example
make a directory called `x11`
```
mkdir x11
cd x11
```
then make a `C` file containing the source code of the app we will call it `gui.c` for example
```
nano gui.c
```
place the apps code then save and exit
before we build this modify the apps code with the libraries : `-lNX11` `-lnano-X` now run
```
gcc gui.c -lNX11 -lnano-x
```
again it will not be able to find a header now pass with gcc another include path  `-H` will tell the command where do we find the library and the files
```
gcc gui.c -lNX11 -lnano-x -I /microwindows/src/nx11/X11-local/
```

AFTER it has been compiled run `ls` you will see a `a.out` file or something ending with `.out` now move it to a directory
```
mv a.out /distro/x11app
```
mow enter the microwindows folder
```
cd microwindows/src/bin
```
run the `ldd` program in the nano x binary
```
ldd nano-X
```
you will see all the shared objects it depends on
nano and/or vim into the file and remove `linux-vdso` you need to get something like 
<img width="330" alt="Screenshot 2024-07-24 202245" src="https://github.com/user-attachments/assets/df35f776-a9ab-462f-b7f9-3962749248c3"> note none of them should have any spaces
now change these to copy commands such as for example in a line
```
cp /lib/x86_64-linux-gnu/libpng16.so.16 /distro/lib/x86_64-linux-gnu/libpng16.so.16
```
remove all () and anything inside them
now make the directories 
```
mkdir -p /distro/lib/x86_64-linux-gnu/
mkdir /distro/lib64
```
now run those copy commands now copy the biniaries by copying the whole folder
```
cd ..
cp -r bin /distro/nanox
cp runapp /distro/nanox
```
now we are finished with setting up the WM the final set is to set up the bootloader
## Chapter 3 Bootloader
use the truncate command to pass in the boot image
```
truncate -s 200MB boot.img
```
make a filesystem on the bootimage
```
mkfs boot.img
```
this will make a regular ext2 fs now mount the bootimg
```
mount boot.img mnt
```
if you get any errors it means you are not in root
install the bootloader on the boot.img (extlinux)
```
extlinux -i mnt
```
REMEMBER
we mounted the boot.img in mnt
so move everything to the mnt folder
```
mv bin bZimage lib lib64 nanox/ x11app/ linuxrc usr/ mnt
```
make a couple of standard unix dirs in mnt
```
cd mnt
mkdir var etc root tmp dev proc
```
now unmount
```
unmount mnt
ls
```
now the boot.img is ready now boot this with QEMU
```
qemu-system-x86_64 boot.img -vga cirrus
```
this is the vga we want to emulate
you will get a message from the bootloader asking where should we boot from? put `/bzImage rw root=/dev/sda` now all of this works but we want to run a X11 app so in your vm type
```
cd nanox/
./nanox
```
but its just a blank screen we need apps hit   CTRL ALT F2
```
cd nanox/
ls
```
now start whatever you want for example we can start minesweeper
```
./mwmine
```
you have a functional GUI Linux distro congrats
