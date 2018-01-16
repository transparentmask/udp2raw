#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

[[ $(id -u) != 0 ]] && echo -e " \n哎呀……请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

# 笨笨的检测方法
if [[ -f /usr/bin/apt-get ]] || [[ -f /usr/bin/yum ]]; then

	if [[ -f /usr/bin/yum ]]; then

		cmd="yum"

	fi

else

	echo -e " \n哈哈……这个 ${red}辣鸡脚本${none} 不支持你的系统。 ${yellow}(-_-) ${none}\n" && exit 1

fi

if [[ $sys_bit == "i386" || $sys_bit == "i686" ]]; then
	udp2raw_ver="udp2raw_x86"
elif [[ $sys_bit == "x86_64" ]]; then
	udp2raw_ver="udp2raw_amd64"
else
	echo -e " \n$red毛支持你的系统....$none\n" && exit 1
fi

install() {
	$cmd install wget -y
	ver=$(curl -s https://api.github.com/repos/wangyu-/udp2raw-tunnel/releases/latest | grep 'tag_name' | cut -d\" -f4)
	udp2raw_download_link="https://github.com/wangyu-/udp2raw-tunnel/releases/download/$ver/udp2raw_binaries.tar.gz"
	mkdir -p /tmp/Udp2raw
	if ! wget --no-check-certificate -O "/tmp/udp2raw_binaries.tar.gz" $udp2raw_download_link; then
		echo -e "$red 下载 Udp2raw-tunnel 失败！$none" && exit 1
	fi
	tar zxf /tmp/udp2raw_binaries.tar.gz -C /tmp/Udp2raw
	cp -f /tmp/Udp2raw/$udp2raw_ver /usr/bin/udp2raw
	chmod +x /usr/bin/udp2raw
	if [[ -f /usr/bin/udp2raw ]]; then
		clear
		echo -e " 
		$green Udp2raw-tunnel 安装完成...$none

		输入$yellow udp2raw $none即可使用....

		备注...这个脚本仅负责安装和卸载...
		
		如何配置...后台运行...开鸡启动这些东西嘛...

		大胸弟....你自己解决咯...

		脚本问题反馈: https://github.com/233boy/udp2raw/issues
		
		Udp2raw 帮助或反馈: https://github.com/wangyu-/udp2raw-tunnel
		"
	else
		echo -e " \n$red安装失败...$none\n"
	fi
	rm -rf /tmp/Udp2raw
	rm -rf /tmp/udp2raw_binaries.tar.gz
}
unistall() {
	if [[ -f /usr/bin/udp2raw ]]; then
		udp2raw_pid=$(pgrep "udp2raw")
		[ $udp2raw_pid ] && kill -9 $udp2raw_pid
		rm -rf /usr/bin/udp2raw
		echo -e " \n$green卸载完成...$none\n" && exit 1
	else
		echo -e " \n$red大胸弟...你貌似毛有安装 Udp2raw-tunnel ....卸载个鸡鸡哦...$none\n" && exit 1
	fi
}
error() {

	echo -e "\n$red 输入错误！$none\n"

}
while :; do
	echo
	echo "........... Udp2raw-tunnel 快速一键安装 by 233blog.com .........."
	echo
	echo "帮助说明: https://233blog.com/post/14/"
	echo
	echo " 1. 安装"
	echo
	echo " 2. 卸载"
	echo
	read -p "请选择[1-2]:" choose
	case $choose in
	1)
		install
		break
		;;
	2)
		unistall
		break
		;;
	*)
		error
		;;
	esac
done
