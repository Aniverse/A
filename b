#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/A
# bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
# bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/b)
#
# wget -qO b https://raw.githubusercontent.com/Aniverse/A/i/b && sed -i "s/_proc_sys/_root_sys/" b && bash b
#
Ver=1.2.2
ScriptDate=2018.12.16
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

DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
[[ $DISTRO =~ (Ubuntu|Debian) ]]  && CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}' | head -n1  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep Ubuntu /etc/issue | head -1 | grep -oE  "[0-9.]+"  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
[[ $KNA == CentOS ]] && DISTRO=$( get_opsy )
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `

# 硬件信息
calc_disk() {
local total_size=0 ; local array=$@
for size in ${array[@]} ; do
[ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
[ "`echo ${size:(-1)}`" == "K" ] && size=0
[ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
[ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
[ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
done ; echo ${total_size} ; }

disk_num=`  df -lh | grep -P "/home[0-9]+|media|/$" | wc -l  `
disk_size1=($( LANG=C df -hPl | grep -wvP '\-|none|root|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|md[0-9]+/[a-z]*' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvP '\-|none|root|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpucores_single=$( grep 'core id' /proc/cpuinfo | sort -u | wc -l )
freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cpunumbers=$( grep 'physical id' /proc/cpuinfo | sort -u | wc -l )
cpucores=$( expr $cpucores_single \* $cpunumbers )
cputhreads=$( grep 'processor' /proc/cpuinfo | sort -u | wc -l )
[[ $cpunumbers == 2 ]] && CPUNum='双路 ' ; [[ $cpunumbers == 4 ]] && CPUNum='四路 ' ; [[ $cpunumbers == 8 ]] && CPUNum='八路 '

tram=$( free -m | awk '/Mem/ {print $2}' )   ; uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )  ; uswap=$( free -m | awk '/Swap/ {print $3}' )
memory_usage=`free -m |grep -i mem | awk '{printf ("%.2f\n",$3/$2*100)}'`%

users=`users | wc -w` ; processes=`ps aux | wc -l`
date=$( date +%Y-%m-%d" "%H:%M:%S )
uptime1=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime )
uptime2=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )

ETH=$(cat /proc/net/dev | awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  | grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql' | awk 'NR==1 {print $0}')

LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8

########################################################################################################





echo -e "${bold}
当前脚本版本：$Ver
1. 获取 sysctl 参数
2. 获取 系统信息
输入其他数字或者五秒钟内无回应一律退出脚本
"
echo -ne "${yellow}你想做什么？${normal} " ; read -t 5 -e answer

case $answer in
    1) answer=1 ;;
    2) answer=2 ;;
    10000) answer=10000 ;;
    11111) answer=10010 ;;
    10086) answer=10086 ;;
    "" | *) unset answer ;;
esac





function get_uname() {

if [[ ! -x /bin/uname ]]; then

    if [[ $CODENAME == wheezy ]]; then
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
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 6 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_6.10_amd64
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 7 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_7.5_amd64
    else
        echo -e "找不到可用的 uname，无法检查内核！"
    fi

    chmod +x ./tmpuname
    alias uname="./tmpuname"

fi ; }




function get_ifconfig() {

if [[ ! -x /sbin/ifconfig ]]; then

    if [[ $CODENAME == wheezy ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/debian_7.11_amd64
    elif [[ $CODENAME == jessie ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/debian_8.10_amd64
    elif [[ $CODENAME == stretch ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/debian_9.4_amd64
    elif [[ $CODENAME == trusty ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/ubuntu_14.04.5_amd64
    elif [[ $CODENAME == xenial ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/ubuntu_16.04.4_amd64
    elif [[ $CODENAME == bionic ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/ubuntu_18.04_amd64
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 6 ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/centos_6.10_amd64
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 7 ]]; then
        wget --no-check-certificate -qO ./tmpifconfig https://github.com/Aniverse/A/raw/i/files/ifconfig/centos_7.5_amd64
    else
        echo -e "找不到可用的 ifconfig，无法检查网卡！"
    fi

    chmod +x ./tmpifconfig
    alias ifconfig="./tmpifconfig"

fi ; }





function show_system_info() {

get_uname
[[   -x /bin/uname ]] && kernel=` uname      -r `
[[ ! -x /bin/uname ]] && kernel=` ./tmpuname -r `

echo -e "\n${bold}"
echo -e "  CPU 型号                   ${cyan}$CPUNum$cname${jiacu}"
echo -e "  CPU 核心                   ${cyan}合计 ${cpucores} 核心，${cputhreads} 线程${jiacu}"
echo -e "  CPU 状态                   ${cyan}当前主频 ${freq} MHz${jiacu}"
echo -e "  内存大小                   ${cyan}$tram MB ($uram MB 已用)${jiacu}"
[[ ! $swap == 0 ]] &&
echo -e "  交换分区                   ${cyan}$swap MB ($uswap MB 已用)${jiacu}"
echo -e "  硬盘大小                   ${cyan}共 $disk_num 个硬盘分区，合计 $disk_total_size GB ($disk_used_size GB 已用)${jiacu}"
echo
echo -e "  系统时间                   ${cyan}$date${jiacu}"
echo -e "  运行时间                   ${cyan}$uptime1${jiacu}"
echo -e "  系统负载                   ${cyan}$load${jiacu}"
echo
echo -e "  当前 操作系统              ${green}$DISTRO $osversion $CODENAME ($arch)${jiacu}"
echo -e "  当前 系统内核              ${green}$kernel${jiacu}"
echo -e "  当前 TCP 拥塞控制算法      ${green}` cat /proc/sys/net/ipv4/tcp_congestion_control `${jiacu}"
echo -e "  可用 TCP 拥塞控制算法      ${green}` cat /proc/sys/net/ipv4/tcp_available_congestion_control `${jiacu}"
echo -e "  ${normal}"

}




function show_system_info_2() {

get_uname
kernel=$( uname -r ) ; arch=$( uname -m )
# [[   -x /bin/uname ]] && { kernel=$(    uname   -r ) ; arch=$(    uname   -m ) ; }
# [[ ! -x /bin/uname ]] && { kernel=$( ./tmpuname -r ) ; arch=$( ./tmpuname -m ) ; }

echo -e "\n${bold}"
echo -e "  CPU 型号                   ${cyan}$CPUNum$cname${jiacu}"
echo -e "  CPU 核心                   ${cyan}合计 ${cpucores} 核心，${cputhreads} 线程${jiacu}"
echo -e "  CPU 状态                   ${cyan}当前主频 ${freq} MHz${jiacu}"
echo -e "  内存大小                   ${cyan}$tram MB ($uram MB 已用)${jiacu}"
[[ ! $swap == 0 ]] &&
echo -e "  交换分区                   ${cyan}$swap MB ($uswap MB 已用)${jiacu}"
echo -e "  硬盘大小                   ${cyan}共 $disk_num 个硬盘分区，合计 $disk_total_size GB ($disk_used_size GB 已用)${jiacu}"
echo
echo -e "  系统时间                   ${cyan}$date${jiacu}"
echo -e "  运行时间                   ${cyan}$uptime1${jiacu}"
echo -e "  系统负载                   ${cyan}$load${jiacu}"
echo
echo -e "  当前 操作系统              ${green}$DISTRO $osversion $CODENAME ($arch)${jiacu}"
echo -e "  当前 系统内核              ${green}$kernel${jiacu}"
echo -e "  当前 TCP 拥塞控制算法      ${green}$( cat /proc/sys/net/ipv4/tcp_congestion_control )${jiacu}"
echo -e "  可用 TCP 拥塞控制算法      ${green}$( cat /proc/sys/net/ipv4/tcp_available_congestion_control )${jiacu}"
echo -e "  当前 CPU  调度方式         ${green}$( cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | head -1 )${jiacu}"
echo -e "  当前 硬盘 调度算法         ${green}$( cat /sys/block/[svn]d*/queue/scheduler 2>/dev/null | cut -d '[' -f2|cut -d ']'  -f1 | sort -u )${jiacu}"
echo -e "  当前 可用 调度算法         ${green}$( cat /sys/block/[svn]d*/queue/scheduler 2>/dev/null | sort -u )${jiacu}"
echo -e "  当前 硬盘 文件系统         ${green}$( cat /proc/mounts | grep -P "`df -k | sort -rn -k4 | awk '{print $1}' | head -1`\b" | awk '{print $3}' )${jiacu}" 
echo -e "  当前 硬盘 挂载方式         ${green}$( cat /proc/mounts | grep -P "`df -k | sort -rn -k4 | awk '{print $1}' | head -1`\b" | awk '{print $4}' )${jiacu}"
echo -e "  当前 nr_requests           ${green}$( cat /sys/block/[svn]d*/queue/nr_requests  2>/dev/null | sort -u )${jiacu}"
echo -e "  当前 read_ahead_kb         ${green}$( cat /sys/block/[svn]d*/queue/read_ahead_kb   2>/dev/null | sort -u )${jiacu}"
echo -e "  当前 txqueuelen            ${green}$( ifconfig $ETH 2>/dev/null | grep -oE "txqueuelen:[0-9]+" )${jiacu}"
echo -e "  ${normal}"

echo -e "\n${bold}${baiqingse}  ls /lib/modules/$(uname -r)/kernel/net/ipv4  ${normal}\n" ; ls /lib/modules/$(uname -r)/kernel/net/ipv4 ; echo

# tcp_control_all=` cat /proc/sys/net/ipv4/tcp_allowed_congestion_control `

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
# if [[ $arch == x86_64 ]]; then                    # 没有 uname 也没法检查架构，所以去了算了

    if [[ $CODENAME == wheezy ]]; then
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
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 6 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_6.10_amd64
    elif [[ $(cat /etc/redhat-release 2>/dev/null | sed -r 's/.* ([0-9]+)\..*/\1/') == 7 ]]; then
        wget --no-check-certificate -qO ./tmpuname https://github.com/Aniverse/A/raw/i/files/uname/centos_7.5_amd64
    else
        echo -e "找不到可用的 sysctl，无法输出 sysctl -a！"
    fi

    chmod +x ./tmpsysctl
    sysctl="./tmpsysctl"

# else
#
#    echo -e "找不到可用的 sysctl，无法输出 sysctl -a！"

fi ; }
#fi ; fi ; }





function save_sysctl_all() {
get_sysctl
$sysctl -a 2>&1 > sysctl.all.txt # 2>&1
tar zcf sysctl.d.tar.gz /etc/sysctl.d # 2>&1 >/dev/null
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl ; }





function sysctl_p() {
get_sysctl
cp -f /etc/sysctl.conf sysctl.conf.script
$sysctl -p 2>&1 > sysctl.p.txt 2>&1
[[ ! -x /sbin/sysctl ]] && rm -f ./tmpsysctl ; }





function show_sysctl_specific() {

# 原句：for x in /proc/sys/fs/file-max; do echo -e "$x "`cat $x`""; done
# 改进：for x in /proc/sys/fs/file-max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
# 20180721：今天我才知道原来直接 sysctl net.ipv4.tcp_window_scaling 这样就行了……

# 这么写主要是考虑到以后连不上机器，用备份的文件来检查参数的时候，直接改下变量就行了
# 至于 _ 到 / 的转换，纯粹是为了以后 sed 方便一些不用加反斜杠
# 不过下边显示的文字也会被替换掉，不过问题不大，复制下来再在文本编辑器里批量替换就行了
proc_sys_path_tmp="_proc_sys"
proc_sys_path=$( echo $proc_sys_path_tmp | sed "s/_/\//g")

echo -e "\n${bold}${baiqingse}     以下是 文件系统 与 虚拟内存 参数     ${normal}\n"

for x in $proc_sys_path/fs/file-max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/fs/nr_open; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/swappiness; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/dirty_ratio; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/dirty_background_ratio; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/dirty_writeback_centisecs; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/dirty_expire_centisecs; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/min_free_kbytes; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/vm/overcommit_memory; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailanse}      以下是 TCP 拥塞控制算法 参数      ${normal}\n"

for x in $proc_sys_path/net/core/default_qdisc; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_available_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_allowed_congestion_control; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（布尔型）        ${normal}\n"

for x in $proc_sys_path/net/ipv4/tcp_dsack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_sack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_fack; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_rfc1337; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_mtu_probing; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/ip_no_pmtu_disc; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_no_metrics_save; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_timestamps; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_tw_reuse; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_tw_recycle; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_window_scaling; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_workaround_signed_windows; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_syncookies; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_slow_start_after_idle; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（数值型）        ${normal}\n"

for x in $proc_sys_path/net/ipv4/ip_local_port_range; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_max_orphans; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_adv_win_scale; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_retries1; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_retries2; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_syn_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_orphan_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_synack_retries; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_keepalive_probes; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_keepalive_intvl; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_keepalive_time; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_fin_timeout; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_fastopen; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/optmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/netdev_max_backlog; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/somaxconn; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}           以下是  网络缓存 参数           ${normal}\n"

for x in $proc_sys_path/net/ipv4/tcp_mem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_rmem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/tcp_wmem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/udp_mem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/udp_rmem_min; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/udp_wmem_min; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/rmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/wmem_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/rmem_default; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/core/wmem_default; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${bailvse}        以下是  网络 参数（什么鬼）        ${normal}\n"

for x in $proc_sys_path/net/ipv4/tcp_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/ip_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/udp_early_demux; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/xfrm4_gc_thresh; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/igmp_max_memberships; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/route.gc_timeout; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/conf/all/conf.all.send_redirects; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/conf/all/accept_redirects; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/ipv4/conf/all/accept_source_route; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/netfilter/nf_conntrack_tcp_timeout_established; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/net/netfilter/nf_conntrack_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

echo -e "\n${bold}${baizise}             以下是  内核 参数             ${normal}\n"

for x in $proc_sys_path/kernel/pid_max; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/kernel/sem; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/kernel/sched_migration_cost_ns; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
for x in $proc_sys_path/kernel/sched_autogroup_enabled; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done

# for x in /proc/sys/; do echo -n "$x = " | sed "s/\/proc\/sys\///" | sed "s/\//./g" ; cat $x 2>/dev/null || echo "找不到这个值！" ; done
# 白红色还没用

}





function show_deluge_libtorrent_info() { 

echo;cat -A ~/.config/deluge/session.state|sed "s/\(listen_interfaces\)[0-9][0-9]:/\1 = /"|sed "s/user_agent[0-9][0-9]:/user_agent = /"|sed "s/.*settingsd[0-9][0-9]:/TMPP\r\nPMT\r\n/g"|sed "s/[0-9][0-9]:/\r\n/g"|sed '1,/PMT/d'|sed -e 's/\([0-9]\)e.*/\1/'|sed -e 's/\(.*\)i/\1 = /'|sed "s/listen_ = /listen_i/"|sed "s/\(peer_fingerprint\)[0-9]:\(-.*-\)[0-9]:/\1 = \2\r\n/";echo;echo

}





if [[ $answer == 1 ]]; then
    show_sysctl_part 2>&1 | tee sysctl.txt
elif [[ $answer == 2 ]]; then
    show_system_info
elif [[ $answer == 10010 ]]; then
    show_system_info_2 | tee system.info.txt
    show_sysctl_specific 2>&1 | tee sysctl.specific.txt
    save_sysctl_all
    sysctl_p
elif [[ $answer == 11111 ]]; then
    show_system_info_2
    show_sysctl_specific
elif [[ $answer == 10086 ]]; then
    show_deluge_libtorrent_info | tee deluge.libtorrent.txt
else
    echo -e "\n${bold}无事可做，告辞~${normal}"
fi

rm -f tmpifconfig tmpuname

echo -e "\n\n"



# sz sysctl.part.txt
# sz sysctl.all.txt
# sz sysctl.p.txt
# sz sysctl.specific.txt
