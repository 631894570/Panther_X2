#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch


#修改TTYD自动登录
sed -i 's/login/login -f root/g' feeds/packages/utils/ttyd/files/ttyd.config

#替换banner
rm -rf package/base-files/files/etc/banner
curl -o package/base-files/files/etc/banner https://raw.githubusercontent.com/631894570/openwrt/main/banner

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.10/g' package/base-files/files/bin/config_generate

# Clear the login password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings

#4.默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile

#开启netdata sensors
sed -i 's/charts.d = no/charts.d = yes/g' feeds/packages/admin/netdata/files/netdata.conf

./scripts/feeds update -a
./scripts/feeds install -a
