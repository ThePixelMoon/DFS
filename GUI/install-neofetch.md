### IMPORTANT
#### this script part of the script is still in beta
install packages to your host system
```
apt install bash curl git
```
clone the repo
```
git clone https://github.com/dylanaraps/neofetch.git
```
copy neofetch script and related files to the DFS (GUI FS)
```
cd neofetch
mkdir -p /distro/mnt/usr/local/bin
cp neofetch /distro/mnt/usr/local/bin/
chmod +x /distro/mnt/usr/local/bin/neofetch
mkdir -p /distro/mnt/usr/local/share/neofetch
cp -r ascii art config functions /distro/usr/local/share/neofetch/
```
make sure neofetches dependencies are installed
```
ls /distro/bin | grep -E 'bash|awk|grep|sed'
```
If any utilities are missing, you can add them by copying from your host system:
```
cp /bin/bash /distro/mnt/bin/
cp /bin/awk /distro/mnt/bin/
cp /bin/grep /distro/mnt/bin/
cp /bin/sed /distro/mnt/bin/
echo 'export PATH=$PATH:/usr/local/bin' >> /distro/etc/profile
```
now open your vm and type 
```
source /etc/profile
neofetch
```
