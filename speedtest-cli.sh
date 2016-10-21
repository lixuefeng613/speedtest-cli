#!/bin/sh
#安装脚本
install_speedTest_cli(){
yum -y install python
wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py
chmod a+rx speedtest_cli.py
sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli
sudo chown root:root /usr/local/bin/speedtest-cli
usage
}

#卸载脚本
uninstall_speedTest_cli(){
rm -rf /usr/local/bin/speedtest-cli
#判断上一条命令是否成功执行
if [ $? -eq 0 ];then
echo '卸载成功';
else
echo '卸载失败';
fi
usage
}

#测试离vps最近的速度
speedTest_closest(){
if [ ! -f "/usr/local/bin/speedtest-cli" ] 
then
echo "你尚未安装speedtest-cli,请选择1安装再测速！"
usage
fi
speedtest-cli
usage
}

tmp_city=''
tmp_number=''

#测试你所在测试到vps的速度
speedTest_city(){
if [ ! -f "/usr/local/bin/speedtest-cli" ] 
then
echo "你尚未安装speedtest-cli,请选择1安装再测速！"
usage
else
echo "请输入你所在的城市：例如广州就对应输入Guangzhou："
read city
tmp_city=$city
speedtest-cli speedtest-cli --list |grep -i $city
echo "请输入搜索出对应前面数字：例如6424"
read number
tmp_number=$number
speedtest-cli --server $number
usage
fi
}

#分享测速结果
share_result(){
if [ ! -f "/usr/local/bin/speedtest-cli" ] 
then
echo "你尚未安装speedtest-cli,请选择1安装再测速！"
usage
else
if [[ -n "$1" ]]; then
#不为空
speedtest-cli --share --server=$1 
echo "复制网址可以在网页查看结果！"
else
#为空，如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：例如：speedTest_city > /dev/null
echo "你尚未测试过，无法分享结果，请先选择4测试"
usage
fi
usage	
fi
}

usage(){
echo  -e "\n\n"
echo "请输入下面数字进行选择"
echo "#############################################"
echo "#作者网名：Sanders"
echo "#作者博客：www.lixuefeng.date"
echo "#作者QQ：545684689"
echo "#脚本：centos一键安装speedtest-cli"
echo "#############################################"
echo "------------------------"
echo "1、全新安装"
echo "2、卸载"
echo "3、测试离vps最近的（地理距离），然后显示出测试的网络上/下行速率"
echo "4、测试你所在城市的到vps网速，然后显示出测试的网络上/下行速率"
echo "5、分享测速结果"
echo "6、退出"
echo "------------------------"
echo  -e "\n\n"
read num
case "$num" in
        [1] )
           install_speedTest_cli
        ;;
		[2] )
			uninstall_speedTest_cli
		;;
		[3] )
			speedTest_closest
		;;
		[4] )
			speedTest_city
		;;
		[5] )
            share_result $tmp_number
		;;
		[6] )
           echo "退出";
		   exit;
		;;
		*) echo "选择错误，退出";;
	esac
}

usage
