#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/A
# bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
#
# Ver.0.0.3
#
########################################################################################################
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue}; bailvse=${white}${on_green};
baiqingse=${white}${on_cyan}; baihongse=${white}${on_red}; baizise=${white}${on_magenta};
heibaise=${black}${on_white}; heihuangse=${on_yellow}${black}
jiacu=${normal}${bold}
shanshuo=$(tput blink); wuguangbiao=$(tput civis); guangbiao=$(tput cnorm)
########################################################################################################
# CentOS 7 /sbin/sysctl 和 /usr/sbin/sysctl 都有
########################################################################################################
########################################################################################################
########################################################################################################
[ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
[ -f /etc/os-release     ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
[ -f /etc/lsb-release    ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)

get_opsy() {
[ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
[ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
[ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return ; }

running_kernel=` uname -r `
arch=$( uname -m )
DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
[[ $DISTRO =~ (Ubuntu|Debian) ]]  && CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}' | head -n1  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep -oE  "[0-9.]+" /etc/issue  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
[[ $KNA == CentOS ]] && DISTRO=$( get_opsy )
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `
########################################################################################################



LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8

running_kernel=` uname -r `
tcp_control=` cat /proc/sys/net/ipv4/tcp_congestion_control `

function show_sysctl_part() {

echo -e "\n${bold}"
echo -e "  当前 操作系统              ${green}$DISTRO $osversion $CODENAME ($arch)${jiacu}"
echo -e "  当前 系统内核              ${green}$running_kernel${jiacu}"
echo -e "  当前 TCP 拥塞控制算法      ${green}$tcp_control${jiacu}"
echo -e "  当前 CPU  调度方式         ${green}` cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | head -1  `${jiacu}"
echo -e "  当前 硬盘 调度算法         ${green}` cat /sys/block/sda/queue/scheduler 2>/dev/null | cut -d '[' -f2|cut -d ']'  -f1  `${jiacu}"
echo -e "  当前 硬盘 文件系统         ${green}` cat /etc/fstab 2>/dev/null | grep -v ^# | grep -P " / |/home" | awk '{print $3}' `${jiacu}" 
echo -e "  当前 硬盘 挂载方式         ${green}` cat /etc/fstab 2>/dev/null | grep -v ^# | grep -P " / |/home" | awk '{print $4}' `${jiacu}"
echo -e "  ${normal}"

echo -e "  ${bold}${baihongse}            以下是 IPv4 参数            ${normal}\n"
{ for x in `ls /proc/sys/net/ipv4`; do echo -n "net.ipv4.$x = " ; cat /proc/sys/net/ipv4/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bold}${bailanse}          以下是 Net Core 参数          ${normal}\n"
{ for x in `ls /proc/sys/net/core`; do echo -n "net.core.$x = " ; cat /proc/sys/net/core/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bold}${bailvse}           以下是 Kernel 参数           ${normal}\n"
{ for x in `ls /proc/sys/kernel`; do echo -n "kernel.$x = " ; cat /proc/sys/kernel/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bold}${baiqingse}             以下是 vm 参数             ${normal}\n"
{ for x in `ls /proc/sys/vm`; do echo -n "vm.$x = " ; cat /proc/sys/vm/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bold}${baizise}             以下是 fs 参数             ${normal}\n"
{ for x in `ls /proc/sys/fs`; do echo -n "fs.$x = " ; cat /proc/sys/fs/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"

}

sysctl="/sbin/sysctl"

if [[ ! -x /sbin/sysctl ]]; then
if [[ $arch == x86_64 ]]; then

    if [[ $(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/') == 6 ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/centos_6.10_amd64
    elif [[ $(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/') == 7 ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/centos_7.5_amd64
    elif [[ $CODENAME == wheezy ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/debian_7.11_amd64
    elif [[ $CODENAME == jessie ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/debian_8.10_amd64
    elif [[ $CODENAME == stretch ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/debian_9.4_amd64
    elif [[ $CODENAME == trusty ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/ubuntu_14.04.5_amd64
    elif [[ $CODENAME == xenial ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/ubuntu_16.04.4_amd64
    elif [[ $CODENAME == bionic ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://github.com/Aniverse/A/raw/i/files/sysctl/ubuntu_18.04_amd64
    else
        echo -e "找不到可用的 sysctl，无法输出 sysctl -a！"
    fi

    chmod +x ./tmpsysctl
    sysctl="./tmpsysctl"

else

    echo -e "找不到可用的 sysctl，无法输出 sysctl -a！"

fi ; fi

show_sysctl_part 2>&1 | tee sysctl.part.txt
$sysctl -a 2>&1 > sysctl.all.txt
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl

echo -e "\n\n"

# sz sysctl.part.txt
# sz sysctl.all.txt
