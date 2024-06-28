sudo apt-get update
sudo apt-get install bzip2 git vim make gcc libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux dosfstools
git clone --depth 1 https://github.com/torvalds/linux.git
cd linux
make menuconfig
make -j 1
mkdir /boot-files
cp arch/x86/boot/BzImage /boot-files
cd ..
git clone --depth 1 https://git.busybox.net/busybox
cd busybox
make menuconfig
make -j 1
mkdir /boot-files/initramfs
make CONFIG_PREFIX=/boot-files/initramfs install
cd /boot-files/initramfs/
ls
nano init
rm linuxrc
chmod +x init
find .
find . | cpio -o -H newc > ../init.cpio
cd ..
ls
sudo apt install syslinux
dd if=/dev/zero of=boot bs=1M count=50
ls
sudo apt install dosfstools
mkfs -t fat boot
syslinux boot
ls
mkdir m
mount boot m
cp bzImage init.cpio m
umount m
qemu-system-x86_64 boot


