#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/A
# bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
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


LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8

function show_sysctl_part() {

echo -e "\n${baihongse}            以下是 IPv4 参数            ${normal}\n"
{ for x in `ls /proc/sys/net/ipv4`; do echo -n "net.ipv4.$x = " ; cat /proc/sys/net/ipv4/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bailanse}          以下是 Net Core 参数          ${normal}\n"
{ for x in `ls /proc/sys/net/core`; do echo -n "net.core.$x = " ; cat /proc/sys/net/core/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${bailvse}           以下是 Kernel 参数           ${normal}\n"
{ for x in `ls /proc/sys/kernel`; do echo -n "kernel.$x = " ; cat /proc/sys/kernel/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${baiqingse}             以下是 vm 参数             ${normal}\n"
{ for x in `ls /proc/sys/vm`; do echo -n "vm.$x = " ; cat /proc/sys/vm/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"
echo -e "\n${baizise}             以下是 fs 参数             ${normal}\n"
{ for x in `ls /proc/sys/fs`; do echo -n "fs.$x = " ; cat /proc/sys/fs/$x 2>&1 ; done ; } | grep -Ev "Is a directory|[Pp]ermission"

}

sysctl="/sbin/sysctl"

if [[ ! -x /sbin/sysctl ]]; then

    if [[ ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://
    elif [[ ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://
    elif [[ ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://
    elif [[ ]]; then
        wget --no-check-certificate -qO ./tmpsysctl https://
    else
        echo -e "找不到可用的 sysctl，无法输出 sysctl -a！"
    fi

    chmod +x ./tmpsysctl
    sysctl="./tmpsysctl"

fi

show_sysctl_part 2>&1 | tee sysctl.part.txt
$sysctl -a 2>&1 > sysctl.all.txt
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl
