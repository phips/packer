#version=RHEL7
auth --enableshadow --passalgo=sha512
cdrom
zerombr
keyboard --vckeymap=uk --xlayouts='gb'
lang en_GB.UTF-8
reboot
network  --bootproto=dhcp --ipv6=auto --activate --hostname=rhel7
firewall --port=22
text
skipx
rootpw --iscrypted $6$hL0adudkuUQ1R..t$f3M4aLth3zWo5LJR9Q3Z17IQ5FOtCv7OgbO.5nxOALUuNmcuoaobhEGL9a9Qfvi6LLSsZQsUvCjtIJivzL7au/
# add a vagrant user
user --name=vagrant --password=$1$z/0vnFRa$3tWM3pKkniA7SuYGpX/T4/ --iscrypted --uid=1000
timezone Europe/London --isUtc
bootloader --location=mbr
clearpart --all --initlabel
part /boot --fstype="xfs" --size=500
part pv.10 --fstype="lvmpv" --size=1 --grow
volgroup vg0 --pesize=4096 pv.10
logvol swap  --fstype="swap" --size=64   --name=swap --vgname=vg0
logvol /     --fstype="xfs"  --size=4096 --name=root --vgname=vg0
logvol /var  --fstype="xfs"  --size=5120 --name=var  --vgname=vg0

%packages --nobase
@core
lsof
bash-completion
bind-utils
bzip2
fuse
fuse-libs
gcc
git
kernel-devel
net-tools
psacct
pykickstart
python-virtualenv
rsync
strace
tcpdump
telnet
traceroute
unzip
vim-enhanced
yum-utils
zip
-*-firmware
-wireless-tools
%end

%post --log=/root/ks-post.log
user=vagrant
mkdir -p /home/${user}/.ssh
cat > /home/${user}/.ssh/authorized_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF
chown -R ${user}:${user} /home/${user}/.ssh
chmod 700 /home/${user}/.ssh
cat > /etc/sudoers.d/${user} <<EOF
${user} ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/${user}
# For Ansible pipelining+sudo support
cat >/etc/sudoers.d/dis-requiretty <<'EOF'
Defaults:vagrant !requiretty
EOF
# Patch
# yum update -y
%end
