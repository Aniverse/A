#!/bin/bash
# Author: Aniverse
# https://github.com/Aniverse/A
# 
# Thanks to superbench.sh    bench.sh   nench.sh    yabs.sh
# https://github.com/masonr/yet-another-bench-script
# https://github.com/n-st/nench
# https://www.oldking.net/599.html
# https://teddysun.com/444.html

ScriptVersion=1.4.1.1
SCRIPTUPDATE=2020.09.15

########################################################################################################

usage_guide() {
    wget -qO- git.io/ceshi | bash
    bash <(wget -qO- git.io/ceshi) -j
    bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/a)"
    bash -c "$(wget -qO- https://git.io/JvTRm)"
    bash <(wget -qO- git.io/ceshi) -abc
    bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/a) -f
    wget -qO a https://github.com/Aniverse/A/raw/i/a && bash a -abc
    bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a) -ac
    s=/usr/local/bin/abench ; rm -f $s ; nano $s ; chmod 755 $s
}

########################################################################################################

debug=0
show_ip=1
show_ipip=1
test_io=1
test_iops=0
full_ip=0

# 运行参数 --------------------------------------------------------------------------------------------------------

OPTS=$(getopt -n "$0" -o abcdfghij --long "debug,no-ip,no-ipip,no-io,full-ip,iops,delete" -- "$@")
eval set -- "$OPTS"

while true; do
  case "$1" in
    -a | --no-ip       ) show_ip=0       ; shift ;;
    -b | --no-ipip     ) show_ipip=0     ; shift ;;
    -c | --no-io       ) test_io=0       ; shift ;;
    -d | --debug       ) debug=1         ; shift ;;
    -f | --full-ip     ) full_ip=1       ; shift ;;
    -j | --iops        ) test_iops=1     ; shift ;;
         --delete      ) delete=1        ; shift ;;
    -- ) shift; break ;;
     * ) break ;;
  esac
done

# 颜色 --------------------------------------------------------------------------------------------------------
black=$(tput setaf 0)   ; red=$(tput setaf 1)          ; green=$(tput setaf 2)   ; yellow=$(tput setaf 3);  bold=$(tput bold)
blue=$(tput setaf 4)    ; magenta=$(tput setaf 5)      ; cyan=$(tput setaf 6)    ; white=$(tput setaf 7) ;  normal=$(tput sgr0)
on_black=$(tput setab 0); on_red=$(tput setab 1)       ; on_green=$(tput setab 2); on_yellow=$(tput setab 3)
on_blue=$(tput setab 4) ; on_magenta=$(tput setab 5)   ; on_cyan=$(tput setab 6) ; on_white=$(tput setab 7)
shanshuo=$(tput blink)  ; wuguangbiao=$(tput civis)    ; guangbiao=$(tput cnorm) ; jiacu=${normal}${bold}
underline=$(tput smul)  ; reset_underline=$(tput rmul) ; dim=$(tput dim)
standout=$(tput smso)   ; reset_standout=$(tput rmso)  ; title=${standout}
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue} ; bailvse=${white}${on_green}
baiqingse=${white}${on_cyan}   ; baihongse=${white}${on_red} ; baizise=${white}${on_magenta}
heibaise=${black}${on_white}   ; heihuangse=${on_yellow}${black}
CW="${bold}${baihongse} ERROR ${jiacu}";ZY="${baihongse}${bold} ATTENTION ${jiacu}";JG="${baihongse}${bold} WARNING ${jiacu}"

# Ctrl+C 时恢复样式，删除无用文件
_cancel() {
    echo -e "\n${jiacu}退出脚本 ...${normal}\n"
    rm -rf $HOME/.abench
    rm -f  test_file_*   1   $HOME/ipapi
    exit
}
trap _cancel INT QUIT TERM

export PATH=$HOME/.abench/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$PATH
mkdir -p $HOME/.abench




##############################################################################################################################
[[ $debug != 1 ]] && clear
##############################################################################################################################
echo -e "${bold}正在获取 check-sys 与 abench ...${normal}"
[[ $EUID = 0 ]] && wget -qO /usr/local/bin/abench https://github.com/Aniverse/A/raw/i/a && chmod 755 /usr/local/bin/abench
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
##############################################################################################################################
check_tcp_acc
echo -e "${bold}正在检查其他硬件信息 ...${normal}" ; hardware_check_1
seedbox_check
##############################################################################################################################
echo -e "${bold}正在检查硬盘信息 ...${normal}"
# 计算总共空间的时候，排除掉 FH SSD 每个用户限额的空间；计算已用空间的时候不排除（因为原先的单个 md 已用空间只有 128k/256k）
disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem|docker|md[0-9]+/[a-z]*' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem|docker|md[0-9]+/[a-z]*' | awk '{print $3}' ))
#shellcheck disable=SC2068
disk_total_size=$( calc_disk ${disk_size1[@]} )
#shellcheck disable=SC2068
disk_used_size=$( calc_disk ${disk_size2[@]} )

# 事实上 VPS 可能也有独立的硬盘，不过我懒得管他了...
rm -f $HOME/.abench/disk.info
if [[ $EUID = 0 ]] && [[ "$virtual" == "No Virtualization Detected" ]]; then
    echo -n "${bold}"
    get_app_static smartctl
    disk_check_raid
else
    disk_check_no_root
fi



function sed_disk_num () {
    while read line ; do echo "$line" | sed -e "s|^disk-|  第 |g" -e "s|text \([0-9]\{1,\}\)|块硬盘           ${cyan}通电 \1 小时，型号|g" -e "s|$|&${jiacu}|g" ; done
}

function _show_disk_info () {
    if [[ $(cat $HOME/.abench/disk.info 2>/dev/null | sed -n '1p' | awk '{print $3}' | grep -Ev [A-Z] | grep -oE "[0-9]+") ]]; then
        disk_num=$( cat $HOME/.abench/disk.info 2>/dev/null | wc -l ) ; [[ $debug == 1 ]] && echo -e "disk_num=$disk_num"
        if [[ $disk_num == 1 ]]; then
            echo -e  "  硬盘信息              ${cyan}通电 $(cat $HOME/.abench/disk.info 2>/dev/null | sed -n '1p' | awk '{print $3}') 小时，型号 $(cat $HOME/.abench/disk.info 2>/dev/null | sed -n '1p' | awk '{print $4,$5,$6,$7}')${jiacu}"
        elif [[ $disk_num -ge 2 ]]; then
        #   echo -e  "  第一块硬盘            ${cyan}通电 $(cat $HOME/.abench/disk.info 2>/dev/null | sed -n '1p' | awk '{print $3}') 小时，型号 $(cat $HOME/.abench/disk.info 2>/dev/null | sed -n '1p' | awk '{print $4,$5,$6,$7}')${jiacu}"
            cat $HOME/.abench/disk.info | sed_disk_num
        fi
    else # 这个写得太矬了，以后再改
        if [[ $disk_model_num == 1 ]]; then
            echo -e  "  硬盘型号              ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '1p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_1_num${jiacu}"
        elif [[ $disk_model_num -ge 2 ]]; then
            echo -e  "  第一种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '1p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_1_num${jiacu}"
            echo -e  "  第二种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '2p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_2_num${jiacu}"
        [[ $disk_model_num -ge 3 ]] &&
            echo -e  "  第三种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '3p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_3_num${jiacu}"
        [[ $disk_model_num -ge 4 ]] &&
            echo -e  "  第四种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '4p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_4_num${jiacu}"
        [[ $disk_model_num -ge 5 ]] &&
            echo -e  "  第五种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '5p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_5_num${jiacu}"
        [[ $disk_model_num -ge 6 ]] &&
            echo -e  "  第六种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '6p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_6_num${jiacu}"
        [[ $disk_model_num -ge 7 ]] &&
            echo -e  "  第七种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '7p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_7_num${jiacu}"
        [[ $disk_model_num -ge 8 ]] &&
            echo -e  "  第八种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '8p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_8_num${jiacu}"
        [[ $disk_model_num -ge 9 ]] &&
            echo -e  "  第九种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '9p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_9_num${jiacu}"
        [[ $disk_model_num -ge 10 ]] &&
            echo -e  "  第十种硬盘            ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '10p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_10_num${jiacu}"
        [[ $disk_model_num -ge 11 ]] &&
            echo -e  "  第十一种硬盘          ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '11p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_11_num${jiacu}"
        [[ $disk_model_num -ge 12 ]] &&
            echo -e  "  第十二种硬盘          ${cyan}$(cat $HOME/.abench/disk.info.2 2>/dev/null | sed -n '12p' | sed 's/$/                  /' | cut -c -27)${cyan} × $disk_model_12_num${jiacu}"
        [[ $disk_model_num -ge 13 ]] &&
            echo -e  "  暂时不支持 12 种以上硬盘的完整显示 …… ${jiacu}"
        fi
    fi
}





io_bench() {
    if [[ $test_iops == 1 ]] || [[ $raidcard == NVMe ]]; then
        [[ $EUID != 0 ]] && echo -e "  ${JG} 建议使用 root 权限来运行本脚本的 fio 测试！${normal}\n"
        [[ $raidcard == NVMe ]] && echo -e "  ${ZY} 检测到你使用的是 NVMe 硬盘，使用 fio 代替 dd 进行测试${normal}\n"
        bash <(wget -qO- https://github.com/amefs/fio-bench/raw/master/fio-bench_zh-cn.sh -o /dev/null) -o /tmp/fio-bench.txt
      # echo -ne "${yellow}${bold}" ; cat /tmp/fio-bench.txt | tail -n +2 | sed "s/Test Item/测试项目 /" | sed -e "s|^|  |"
      # cat /tmp/fio-bench.txt | tail -n +2 | sed -r -e "s/Test Item/${cyan}测试项目${normal} /" -e "s|^|  |" -e "s|(\b[0-9.]+\b)|${yellow}\1${normal}|g" -e "s|([GMK]B/s)|${yellow}\1${normal}|g" -e "s/([读写速IP][取入度OS])/${cyan}\1${normal}/g" -e "s/-Q32T1/${cyan}-Q32T1${normal}/g" -e "s/4K/${cyan}4K${normal}/g" -e "s/Seq/${cyan}Seq${normal}/g"
      # echo -e "${normal}"
        if [[ -f /tmp/fio-bench.txt ]]; then
            _menu
            cat /tmp/fio-bench.txt | tail -n +2 | sed -r -e "s/Test Item/测试项目 /" -e "s|^|  |" \
            -e "s|(\b[0-9.]+\b)|${yellow}\1${normal}|g" -e "s|([GMK]B/s)|${yellow}\1${normal}|g"
        fi
    else
        [[ $SSD == yes ]] && [[ $EUID == 0 ]] && echo -e "  ${ZY} 检测到你服务器里有固态硬盘，建议使用 fio 代替 dd 进行测试${normal}" &&
        echo -e "              ${blue}${bold}bash <(wget -qO- git.io/ceshi) -j${normal}\n"
        echo -n "  顺序写入 (1st)        " ; dd_write_1=$(dd_benchmark) ; echo -e "${yellow}$(echo $dd_write_1 | Bps_to_MBps)${normal}"
        echo -n "  顺序写入 (2nd)        " ; dd_write_2=$(dd_benchmark) ; echo -e "${yellow}$(echo $dd_write_2 | Bps_to_MBps)${normal}"
        echo -n "  顺序写入 (3rd)        " ; dd_write_3=$(dd_benchmark) ; echo -e "${yellow}$(echo $dd_write_3 | Bps_to_MBps)${normal}"
        echo -n "  顺序写入 (4th)        " ; dd_write_4=$(dd_benchmark) ; echo -e "${yellow}$(echo $dd_write_4 | Bps_to_MBps)${normal}"
        echo -n "  顺序写入 (5th)        " ; dd_write_5=$(dd_benchmark) ; echo -e "${yellow}$(echo $dd_write_5 | Bps_to_MBps)${normal}"
        ddsum=$(echo -e "$dd_write_1\\n$dd_write_2\\n$dd_write_3\\n$dd_write_4\\n$dd_write_5" | awk 'BEGIN{max="'$first_num'";min="'first_num'"}{if($1>max){max=$1};if($1<min){min=$1}}END{print '$dd_write_1'+'$dd_write_2'+'$dd_write_3'+'$dd_write_4'+'$dd_write_5'-max-min}')
        ddavg=$(awk 'BEGIN{printf "%.1f", '$ddsum' / 3}')
        # 去掉了最高值和最低值后的平均速度
        echo -n "  顺序写入 (avg)        " ; echo -e "${yellow}$(echo $ddavg | Bps_to_MBps_1f)${normal}"
    fi
    echo
}






# 主界面
function _menu() {
    [[ $debug != 1 ]] && clear ; echo
echo -e  " ${baizise}${bold}                  This is the choice of Steins;Gate                   ${jiacu} "
    echo
echo -e  "  CPU 型号              ${cyan}$CPUNum$cname${jiacu}"
echo -e  "  CPU 核心              ${cyan}合计 ${cpucores} 核心，${cputhreads} 线程${jiacu}"
echo -e  "  CPU 状态              ${cyan}当前主频 ${freq} MHz${jiacu}"
echo -e  "  内存大小              ${cyan}$tram MB ($uram MB 已用)${jiacu}"
    [[ ! $swap == 0 ]] &&
echo -e  "  交换分区              ${cyan}$swap MB ($uswap MB 已用)${jiacu}"
    echo

    _show_disk_info | tee -a $HOME/.abench/_show_disk_info
    if [[ -s $HOME/.abench/_show_disk_info ]]; then
        echo # 增加一行
        [[ $debug != 1 ]] && rm -f $HOME/.abench/_show_disk_info
    fi
    # [[ ! $Seedbox == Unknown ]] && DiskNumDisplay="共 $disk_num 块硬盘，合计 "
    # [[ ! $Seedbox == Unknown ]] && SeedboxDiskTotalFlagOne="总" ; [[ $Seedbox == Unknown ]] && SeedboxDiskTotalFlagTwo="  "
    SeedboxDiskTotalFlagTwo="  "
    [[ $disk_num -ge 2 ]] && DiskNumDisplay="共 $disk_num 块硬盘，合计 " && SeedboxDiskTotalFlagOne="总" && SeedboxDiskTotalFlagTwo=""
echo -e  "  ${SeedboxDiskTotalFlagOne}硬盘大小       ${SeedboxDiskTotalFlagTwo}     ${cyan}${DiskNumDisplay}$disk_total_size GB${jiacu}"
    # 已用容量这个要分类讨论有点麻烦，扔了算了……
    # ($disk_used_size GB 已用)


            if [[ ! $Seedbox == Unknown ]] && [[ ! $EUID = 0 ]] && [[ ! $virtual == Docker ]]; then
echo -e  "  当前硬盘分区大小      ${cyan}${current_disk_size}B (共 ${current_disk_total_used}B 已用，其中你用了 ${current_disk_self_used}B)${jiacu}"
echo -e  "  共享盒子邻居数量      ${cyan}整台机器共 $neighbors_all_num 位邻居，其中同硬盘邻居 $neighbors_same_disk_num 位${jiacu}"
            fi

    echo
echo -e  "  服务器时间            ${cyan}$date${jiacu}"
echo -e  "  运行时间              ${cyan}$uptime1${jiacu}"
echo -e  "  系统负载              ${cyan}$load${jiacu}"
echo -e  "  虚拟化技术            ${cyan}$virtual${jiacu}"
    echo

            if [[ $show_ip == 1 ]]; then
echo -e  "  IPv4 地址             ${green}$serveripv4_show${jiacu}"
                [[ $serveripv6 ]] &&
echo -e  "  IPv6 地址             ${green}$serveripv6_show${jiacu}"
                [[ ! $Seedbox == Unknown ]] &&
echo -e  "  盒子域名              ${green}$serverfqdn${jiacu}"
            fi

            if [[ $show_ipip == 1 ]] && [[ -n $asnnnnn ]]; then
echo -e  "  运营商                ${green}$asnnnnn${jiacu}"
echo -e  "  地理位置              ${green}$country, $regionn, $cityyyy${jiacu}"
            fi

    [[ $show_ip == 1 || $show_ipip == 1 ]] && echo

echo -e  "  操作系统              ${green}$DISTRO $osversion $CODENAME ($arch)${jiacu}"
    [[ $running_kernel ]] &&
echo -e  "  系统内核              ${green}$running_kernel${jiacu}"
    [[ $tcp_c_name ]] &&
echo -e  "  TCP 加速              ${green}$tcp_c_name${jiacu}"
    echo

echo -e  "  ${jiacu}当前脚本版本          $ScriptVersion${normal}"
    echo

    [[ $CODENAME == buster ]] && ls $HOME | grep -q images && echo -e 
}




# 结构 ----------------------------------------------------------------------------------------------

[[ $show_ip   == 1 ]] && { ipv4_check ; ipv6_check ; }
[[ $show_ipip == 1 ]] && echo -e "${bold}正在检查 ASN 等信息 ...${normal}" && ip_ipinfo_aniverse
_menu
[[ $test_io == 1 ]] && io_bench
[[ $delete == 1 ]] && rm -rf $HOME/.abench test_file_* $HOME/ipapi
