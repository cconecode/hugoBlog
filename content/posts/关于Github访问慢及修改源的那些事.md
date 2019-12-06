---
title: "关于Github访问慢及修改源的那些事"
date: 2019-12-06T16:13:07+08:00
draft: true
type: post
---

## Github 访问慢

由于一些特殊原因，国内访问 Github 一般会比较慢，可以通过修改 DNS 来提高访问速速

### 1. 获取 github 及 github global 的 DNS

用浏览器访问 https://www.ipaddress.com/，分别获取 github 和 github.global.ssl.fastly.net 对应的 IP：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-093146.png" alt="image-20191206173139048" style="zoom:50%;" />

### 2. 修改 hosts 文件

```shell
sudo vi /etc/hosts

获取到的IP github.com
获取到的IP github.global.ssl.fastly.net
```

Windows 系统请自行搜索如何修改 hosts

### 3. 更新 DNS 缓存

```shell
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

## Homebrew 慢

通过将 homebrew 的源修改为国内的，可以加快 brew install 及 update 速度：

### 1. 替换阿里云 homebrew 镜像：

```bash
# 替换 brew.git
cd "$(brew --repo)"
git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git

# 替换 homebrew-core.git
cd "$(brew --repo)"/Library/Taps/homebrew-homebrew/homebrew-core
git remote set-url origin ttps://mirrors.aliyun.com/homebrew/homebrew-core.git

# 替换 homebrew-bottles，bash 用户将 ~/.zshrc 更为 ~/.bash_profile
echo 'export HOMEBREW_BOTTLE_DOMAIN='https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
```

### 2.  替换 homebrew-cask 

```bash
cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
```

## CocoaPods 慢

对于 cocoapods 慢的问题，也是采用换镜像的方式，采用清华大学的镜像：

```bash
cd ~/.cocoapods/repos
pod repo remove master
git clone https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git master
```

换成清华镜像后，需要在项目的 podFile 第一行加上：

```bash
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
```

## 访问 developer.apple.com 慢

访问 developer.apple.com 时，默认会走日本的服务器，这就会导致访问特别慢，其实苹果在香港也是有服务器的，访问香港的服务器速度则会快很多，首先在 http://ping.chinaz.com 中查找 developer.apple.com，然后找到香港服务器的 IP，如：

![image-20191206175541658](https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-095629.png)

获取到 IP 后，也是通过修改 hosts 文件，将 developer.apple.com 映射成刚刚获取的 IP：

```shell
17.253.87.206  developer.apple.com
```

