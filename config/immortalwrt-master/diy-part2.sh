#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

#Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.20.1）
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
# Add luci-app-tailscale
rm -rf package/luci-app-tailscale
git clone https://github.com/asvow/luci-app-tailscale package/luci-app-tailscale
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

PKG_PATH="$GITHUB_WORKSPACE/openwrt/package/"

#修复TailScale配置文件冲突
TS_FILE=$(find ./feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
        sed -i '/\/files/d' $TS_FILE

        cd $PKG_PATH && echo "tailscale has been fixed!"
fi

#修复Coremark编译失败
CM_FILE=$(find ./feeds/packages/ -maxdepth 3 -type f -wholename "*/coremark/Makefile")
if [ -f "$CM_FILE" ]; then
        sed -i 's/mkdir/mkdir -p/g' $CM_FILE

        cd $PKG_PATH && echo "coremark has been fixed!"
fi

#修复libffi编译失败
LF_FILE=$(find ./feeds/packages/ -maxdepth 3 -type f -wholename "*/libffi/Makefile")
if [ -f "$LF_FILE" ]; then
        sed -i '/\/autoreconf/d' $LF_FILE

        cd $PKG_PATH && echo "libffi has been fixed!"
fi
