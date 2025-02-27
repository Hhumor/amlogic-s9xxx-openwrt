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


#去除nginx的ssl
cat << EOF > /etc/config/nginx
config main global
        option uci_enable 'true'

config server '_lan'
        list listen '80'
        list listen '[::]:80'
        option server_name '_lan'
        list include 'restrict_locally'
        list include 'conf.d/*.locations'
        option access_log 'off; # logd openwrt'
EOF

