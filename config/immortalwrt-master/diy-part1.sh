#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# other
# rm -rf package/emortal/{autosamba,ipv6-helper}

PKG_PATH="/builder/openwrt/package/"

#修复TailScale配置文件冲突
TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
        sed -i '/\/files/d' $TS_FILE

        cd $PKG_PATH && echo "tailscale has been fixed!"
fi

#修复Coremark编译失败
CM_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/coremark/Makefile")
if [ -f "$CM_FILE" ]; then
        sed -i 's/mkdir/mkdir -p/g' $CM_FILE

        cd $PKG_PATH && echo "coremark has been fixed!"
fi

#修复libffi编译失败
LF_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/libffi/Makefile")
if [ -f "$LF_FILE" ]; then
        sed -i '/\/autoreconf/d' $LF_FILE

        cd $PKG_PATH && echo "libffi has been fixed!"
fi