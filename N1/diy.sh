#!/bin/bash

# Remove packages
rm -rf feeds/luci/applications/luci-app-passwall

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}


# Add packages
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-pushbot

echo "
# 插件
CONFIG_PACKAGE_luci-app-homeproxy=y
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-pushbot=y
" >> .config

# 修改默认IP
sed -i 's/192.168.1.1/192.168.10.200/g' package/base-files/files/bin/config_generate
