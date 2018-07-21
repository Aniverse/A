#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/A
# bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
# bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/b)
#
# Ver.1.0.2.uname
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

# tcp_control_all=` cat /proc/sys/net/ipv4/tcp_allowed_congestion_control `






echo -e "
1. 获取 sysctl 参数
2. 获取 sysctl 参数（特定）
输入其他数字或者五秒钟内无回应一律退出脚本
"
echo -ne "${bold}${yellow}你想做什么？${normal} " ; read -t 5 -e answer

case $answer in
    1) answer=1 ;;
    2) answer=2 ;;
    10000) answer=10000 ;;
    10010) answer=10010 ;;
    10086) answer=10086 ;;
    "" | *) unset answer ;;
esac





function get_uname() {

uname=$(which uname)

if [[ ! $(which uname) ]]; then
if [[ $arch == x86_64 ]]; then

    if [[ $(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/') == 6 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_6.10_amd64
    elif [[ $(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/') == 7 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_7.5_amd64
    elif [[ $CODENAME == wheezy ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/debian_7.11_amd64
    elif [[ $CODENAME == jessie ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/debian_8.10_amd64
    elif [[ $CODENAME == stretch ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/debian_9.4_amd64
    elif [[ $CODENAME == trusty ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/ubuntu_14.04.5_amd64
    elif [[ $CODENAME == xenial ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/ubuntu_16.04.4_amd64
    elif [[ $CODENAME == bionic ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/ubuntu_18.04_amd64
    else
        echo -e "找不到可用的 uname，无法检查内核！"
    fi

    chmod +x ./tmpuname
    uname="./tmpuname"

else

    echo -e "找不到可用的 uname，无法检查内核！"

fi ; fi ; }





function show_system_info() {

echo -e "\n${bold}"
echo -e "  当前 操作系统              ${green}$DISTRO $osversion $CODENAME ($arch)${jiacu}"
echo -e "  当前 系统内核              ${green}` $uname -r `${jiacu}"
echo -e "  当前 TCP 拥塞控制算法      ${green}` cat /proc/sys/net/ipv4/tcp_congestion_control `${jiacu}"
echo -e "  可用 TCP 拥塞控制算法      ${green}` cat /proc/sys/net/ipv4/tcp_available_congestion_control `${jiacu}"
echo -e "  当前 CPU  调度方式         ${green}` cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | head -1  `${jiacu}"
echo -e "  当前 硬盘 调度算法         ${green}` cat /sys/block/sda/queue/scheduler 2>/dev/null | cut -d '[' -f2|cut -d ']'  -f1  `${jiacu}"
echo -e "  当前 可用 调度算法         ${green}` cat /sys/block/sda/queue/scheduler 2>/dev/null                                   `${jiacu}"
echo -e "  当前 硬盘 文件系统         ${green}` cat /etc/fstab 2>/dev/null | grep -v ^# | grep -P " / |/home" | awk '{print $3}' `${jiacu}" 
echo -e "  当前 硬盘 挂载方式         ${green}` cat /etc/fstab 2>/dev/null | grep -v ^# | grep -P " / |/home" | awk '{print $4}' `${jiacu}"
echo -e "  ${normal}"

}




function show_sysctl_part() {

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





function get_sysctl() {

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

fi ; fi ; }





function save_sysctl_all() {
get_sysctl
$sysctl -a 2>&1 > sysctl.all.txt 2>&1
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl ; }





function sysctl_p() {
get_sysctl
cp -f /etc/sysctl.conf sysctl.conf.script
cp -f /etc/sysctl.d/99-sysctl.conf 99-sysctl.conf.script
$sysctl -p 2>&1 > sysctl.p.txt 2>&1
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl ; }





function show_sysctl_specific() {

# 原句：for x in /proc/sys/fs/file-max; do echo -e "$x "`cat $x`""; done
# 改进：for x in /proc/sys/fs/file-max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
# 20180721：今天我才知道原来直接 sysctl net.ipv4.tcp_window_scaling 这样就行了……

echo -e "\n${bold}${baiqingse}     以下是 文件系统 与 虚拟内存 参数     ${normal}\n"

for x in /proc/sys/fs/file-max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/fs/nr_open; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/swappiness; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/dirty_ratio; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/dirty_background_ratio; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/dirty_writeback_centisecs; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/dirty_expire_centisecs; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/min_free_kbytes; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/vm/overcommit_memory; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailanse}      以下是 TCP 拥塞控制算法 参数      ${normal}\n"

for x in /proc/sys/net/core/default_qdisc; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_available_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_allowed_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（布尔型）        ${normal}\n"

for x in /proc/sys/net/ipv4/tcp_dsack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_sack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_fack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_rfc1337; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_mtu_probing; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/ip_no_pmtu_disc; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_no_metrics_save; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_timestamps; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_tw_reuse; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_tw_recycle; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_window_scaling; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_workaround_signed_windows; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_syncookies; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_slow_start_after_idle; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（数值型）        ${normal}\n"

for x in /proc/sys/net/ipv4/max_orphans; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/ip_local_port_range; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_adv_win_scale; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_retries1; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_retries2; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_syn_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_orphan_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_synack_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_keepalive_probes; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_keepalive_intvl; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_keepalive_time; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_fin_timeout; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_fastopen; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/optmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/netdev_max_backlog; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/somaxconn; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}           以下是  网络缓存 参数           ${normal}\n"

for x in /proc/sys/net/ipv4/tcp_mem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_rmem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/tcp_wmem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/udp_mem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/udp_rmem_min; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/udp_wmem_min; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/rmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/wmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/rmem_default; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/core/wmem_default; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（什么鬼）        ${normal}\n"

for x in /proc/sys/net/ipv4/tcp_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/ip_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/udp_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/xfrm4_gc_thresh; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/igmp_max_memberships; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/route.gc_timeout; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/conf/all/conf.all.send_redirects; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/conf/all/accept_redirects; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/ipv4/conf/all/accept_source_route; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/net/netfilter/nf_conntrack_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${baizise}             以下是  内核 参数             ${normal}\n"

for x in /proc/sys/kernel/pid_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/kernel/sem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/kernel/sched_migration_cost_ns; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in /proc/sys/kernel/sched_autogroup_enabled; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

# for x in /proc/sys/; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
# 白红色还没用

}





function show_deluge_libtorrent_info() { 

echo;cat -A ~/.config/deluge/session.state|sed "s/\(listen_interfaces\)[0-9][0-9]:/\1 = /"|sed "s/user_agent[0-9][0-9]:/user_agent = /"|sed "s/.*settingsd[0-9][0-9]:/TMPP\r\nPMT\r\n/g"|sed "s/[0-9][0-9]:/\r\n/g"|sed '1,/PMT/d'|sed -e 's/\([0-9]\)e.*/\1/'|sed -e 's/\(.*\)i/\1 = /'|sed "s/listen_ = /listen_i/"|sed "s/\(peer_fingerprint\)[0-9]:\(-.*-\)[0-9]:/\1 = \2\r\n/";echo;echo

}














if [[ $answer == 1 ]]; then
    show_system_info
    show_sysctl_part 2>&1 | tee sysctl.part.txt
elif [[ $answer == 2 ]]; then
    show_system_info
    show_sysctl_specific 2>&1 | tee sysctl.specific.txt
elif [[ $answer == 10010 ]]; then
    show_system_info
    show_sysctl_specific 2>&1 | tee sysctl.specific.txt
    save_sysctl_all
    sysctl_p
elif [[ $answer == 10086 ]]; then
    show_deluge_libtorrent_info | tee deluge.libtorrent.txt
else
    echo -e "\n${bold}无事可做，告辞~${normal}"
fi

echo -e "\n\n"



# sz sysctl.part.txt
# sz sysctl.all.txt
# sz sysctl.p.txt
# sz sysctl.specific.txt
