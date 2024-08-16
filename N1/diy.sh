#!/bin/bash

# Default IP
sed -i 's/192.168.1.1/192.168.10.200/g' package/base-files/files/bin/config_generate

# Remove packages
rm -rf feeds/luci/applications/luci-app-passwall

# Add packages
git clone https://github.com/nantayo/My-Pkg package/my-pkg
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-pushbot

echo "
# 插件
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-pushbot=y
" >> .config
