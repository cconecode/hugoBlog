---
title: 如何用V2Ray科学上网
date: 2019-11-29 14:06:21
tags: ["科学上网"]
permalink: how-to-freedom
type: post
draft: true
---

## 什么是 V2Ray

想要通过 V2Ray 科学上网，先得了解 V2Ray 是什么。根据 V2Ray 指南比较官方的描述：

> V2Ray 是 Project V 下的一个工具。Project V 是一个包含一系列构建特定网络环境工具的项目，而 V2Ray 属于最核心的一个。 官方中介绍Project V 提供了单一的内核和多种界面操作方式。内核（V2Ray）用于实际的网络交互、路由等针对网络数据的处理，而外围的用户界面程序提供了方便直接的操作流程。

简单点说，V2Ray 就是一个跟 Shadowsocks 差不多的代理软件，可以让我们科学上网。只不过相对来说，V2Ray 功能更强大一点，同时配置也更复杂一点。而且鉴于现在走 SS 协议的代理基本都会受到干扰，科学上网起来也没那么流畅，这时候就需要了解及配置一套自己的 V2Ray了。V2Ray 更加稳定，而且传输速度相对 SS 也更快一点。

## 搭建 V2Ray 需要什么

首先，简单的 V2Ray 只需要一台墙外的 VPS 就可以了，同时也需要一点 Linux 系统的知识。VPS 的话香港、日本、新加坡、美国的都行。只不过是延迟的差异而已，地理位置越靠近国内的延迟越低。在搬瓦工、Vlutr、DigitOcean 都可以买到对应的 VPS，其中搬瓦工是最出名的，也是最多人购买的，比较推荐。只不过如果你的 IP 不幸被封，需要 8 美刀更换一个 IP，而且搬瓦工一般都是按年付费的。Vlutr 则是我之前用的比较多的一家平台，可以免费更换 IP，被封了随时可以新建实例，而且是按时按月收费的，如果大环境不太爽畅，可以用 Vlutr 过度一下。它的缺点就是比较不稳定，配置相对也没有那么好。DigitOcean 我没有用过，所以就不做评价了。

但是，如果你很幸运的拥有一个 Google 账号，则可以通过 GoogleCloud 新用户的规则白嫖一年 VPS（~~我现在就白嫖着～~~）。GoogleCloud 会赠送新用户 300 美刀，可以使用其下面的云产品，300 美刀在一年之内需用完，过期作废。但国内用户开通 GoogleCloud 会比较麻烦，首先你得已经番羽墙了，然后要拥有一个境外的双币卡，才能完成新用户的认证。不过，有一个解决办法就是通过 P 卡去开通（P 卡：[Payoneer](http://payoneer.com)，一个虚拟信用卡网站），在知乎上有一篇文章，[新用户申请谷歌云300美金失败，怎么办？](https://zhuanlan.zhihu.com/p/58747135)，我就是通过这个方法申请开通成功的。然后就是注册实例之类的，就不再赘述了，网上都有许多相关的文章，随便找篇看看就知道怎么回事了。

当然，上面只是最简单的需要的东西。如果想更安全更稳定更快速的科学上网，就还需要一个域名，域名的作用是解析 VPS 主机，并通过它进行再次代理转发的。域名是个很便宜的东西，随便申请一个就好了，越便宜越好的那种。

> **个人建议：VPS 最好选择 Ubuntu 或者 Debain 系统的**

## 前期准备

到了这一步，就默认上面所说的东西你都已经准备好了。现在开始前期的准备工作：

1. 将申请下来的 VPS 解析到申请好的域名
2. 为域名申请 SSL 证书
3. 安装 Nginx

将 VPS 解析到申请好的域名就不做过多描述了，通过 DNSPod 或者申请域名的平台应该都可以进行解析。首先，登入到申请好的 VPS 上：

### 为域名申请 SSL 证书

我们可以通过 [cerbot](https://certbot.eff.org) 给域名生成对应的 SSL 证书：

#### 1. 下载并给 cerbot 赋予可执行权限

首先，选择保存 cerbot 的目录，我们可以选择 `/usr/local/src`，cd 到想保存的目录。然后用 wget 命令下载 cerbot：

```shell
wget https://dl.eff.org/cerbot-auto
```

然后再给 cerbot 赋予可执行权限：

```shell
chmod +x cerbot-auto
```

#### 2. 利用 cerbot 申请 Let's Encry 证书

申请 Let's Encry 证书需要以下几个条件：

1. 系统的 root 权限
2. 443 端口未被占用，防火墙放行 443 端口，且外网能够直接访问本机的 443 端口
3. 域名解析到了当前主机

如果申请失败了，确认一下以上几点是否都满足。现在可以申请 SSL 证书了：

```shell
./certbot-auto certonly
```

第一次安装需要输入一些必要的信息，主要如下：

```shell
How would  you like to authenticate with the ACME CA? 
--------------------------------------------------
1: Spin up a temporary webserver (standalone)
2: Place files in webroot directory (webroot)
一般选择 1


Enter email address (used for urgent renewal and security notices) (Enter 'c' to cancel): # 输入想使用的邮箱，用于接收证书到期等信息


Please enter in your domain name(s) (comma and/or space separated) (Enter 'c' to cancel): #输入想申请的域名
```

申请成功之后，会有一个证书保存的路径显示，可以记录下来，后面需要用到。如果忘记了也没关系，证书一般都保存在 `/etc/letsencrypt/live/xxx`下面，在这里你可以找到申请好的证书，有你的域名的那两个文件就是对应的证书。

在证书快到期时，也可以通过下面的命令更新证书信息：

```shell
./certbot-auto renrew
```

### 安装 Nginx

#### CentOS 系统添加 Nginx 官方源

CentOS 系统官方源仓库文件在 `/etc/yum.repos.d`，只需要在下面新建一个文件保存 Nginx 的源就可以了，例如新建一个叫 `nginx.repo` 的文件，然后复制以下内容进去：

```shell
[nginx]
		
name=nginx repo
# 下面的 OS 用实际发行版替换，如 centos 或 rhel，OSRELEASE 用具体发行版本号代替，如 6 或者 7。也就是说如果是 CentOS6，则需要将 OS/OSRELEASE 替换成 centos/6
baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
gpgcheck=0
enabled=1
```

保存文件后，就可以直接安装 Nginx 了：

```shell
yum install nginx
```

#### Ubuntu 及 Debain 系统添加官方源

用编辑器打开 `/etc/apt/sources.list`，Debain 添加以下内容：

```shell
deb http://nginx.org/packages/debian/ codename nginx
deb-src http://nginx.org/packages/debian/ codename nginx
```

Ubuntu 添加以下内容：

```shell
deb http://nginx.org/packages/ubuntu codename nginx
deb-src http://nginx.org/packages/ubuntu codename nginx
```

用命令 `cat/etc/os-release` 查询到实际发行版本号，替换上面内容中的 `codename`。

添加完上面内容后，还需要添加 Nginx 官方的 Key，不然会提示 Key 错误：

```shell
wget https://nginx.org/keys/nginx_signing.key -O /tmp/nginx_signing.key
apt-key add /tmp/nginx_signing.key
```

最后先更新仓库源信息再安装 Nginx：

```shell
apt-get update
apt-get install nginx
```

到了这里，前期的准备工作基本完成了，下面则需要进入配置环节了。

## 安装 V2Ray

用官方提供的命令一键安装 V2Ray：

```shell
bash <(curl -L -s https://install.direct/go.sh)
```

## 配置 V2Ray

V2Ray 的配置文件放在 `/etc/V2Ray/config.json`，修改之前先备份一下：

```shell
cp /etc/V2Ray/config.json /etc/V2Ray/config.json.bak
```

在原先的默认配置中，修改或者添加下面的配置：

```json
{
	"inbound":[{
   	"port": 1000, # 设置 websocket 的端口号，用于和 Nginx 通信
    "protocol": "vmess", # 选择 vmess 协议
    "streamSettings":{
    	"network":"ws",
    	"wsSettings":{
    		"connectionReuse": false,
    		"path": "/ws", # Nginx 监听路径，后面 Nginx 设置及 V2Ray 客户端配置需要
    		"headers": {
    			"Host": "申请的域名"
  			}
  		}
  	}
  }],
}
```

修改配置之后，可以用 V2Ray 自带的测试工具检测一下配置是否正确：

```shell
/usr/bin/V2Ray/V2Ray -test -config /etc/V2Ray/config.json
```

## 配置 Nginx 转发 websocket

在 `/etc/nginx/conf.d` 新建一个虚拟主机配置文件，内容如下：

```json
server {
			listen 443 ssl;
			listen [::]:443 ssl;
			
			ssl_certificate       # 第一步生成的 SSL 证书目录
			ssl_certificate_key  # 第一步生成的 SSL key 目录
			ssl_protocols   TLSv1 TLSv1.1 TLSv1.2
			ssl_ciphers    HIGH:!aNull:!MD5;

			# 域名
			server_name   xxxxx;
			
			location /ws {
				proxy_redirect  off;
				proxy_pass  http://127.0.0.1:22125;  # V2Ray 配置的 websocket 端口
				proxy_http_version 1.1;
				proxy_set_header  Upgrade $http_upgrade;
				proxy_set_header  Connection “upgrade”;
				proxy_set_header  Host $http_host;
			}
			
			location / {
				root  /var/www/html;
				index  index.html index.htm;
			}
		}	
	
		server {
			listen 80;
			listen [::]:80;
			server_name  xxxx; # 域名
			return 301 https://域名$request_uri;
		}

```

保存之后用 Nginx 自带的配置文件检测功能检查下是否有问题：`nginx -t`

没问题的话重启一下 V2Ray 和 Nginx 就可以了：

```shell
systemctl restart V2Ray
systemctl restart nginx
```

## 客户端的配置

其实 V2Ray 并没有所谓的客户端，它只是个配置而已，客户端的功能主要是保持和服务器的配置一样。Windows 上推荐的客户端是 V2RayW，Mac 上推荐的是 V2RayX，iOS 客户端推荐 Kitsunebi（需要在美区下载），Android 客户端推荐 V2RayNG。这里主要介绍一下 Mac 上 V2RayX 的配置，其他配置基本雷同。

V2RayX 的配置界面长这样：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-092019.png" alt="2019-11-29-074008" style="zoom:50%;" />

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-10-032252.png" alt="2019-11-29-074008" style="zoom:50%;" />

下面对各个功能及配置进行详细说明：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-092045.png" alt="2019-11-29-074002" style="zoom:50%;" />

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-10-032346.png" alt="2019-11-29-073955" style="zoom:50%;" />

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-092435.png" alt="2019-11-29-073949" style="zoom:50%;" />

到这里基本配置就完成了，接下来配置 websocket 和 TLS，点击配置中的 `transport settings...`，进入到：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-092503.png" alt="2019-11-29-074227" style="zoom:50%;" />

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-06-092621.png" alt="2019-11-29-074344" style="zoom:50%;" />

到这里，客户端的配置也就已经完成了，可以愉快的科学上网了：)

如果，你并不想做那么复杂的配置，只想简单的科学上网，则只需要使用 V2Ray 默认生成的配置文件，将客户端的 id 及传输类型，配置成跟服务器中的一样就可以了。初次配置 V2Ray 会有点懵圈，因为它并不像 SS 一样，有严格的客户端功能配置，它只是一系列的配置文件而已，inbound 和 outbound 只是出站跟入站的配置，客户端也就是我们上网是 inbound，服务器则是 outbound。理清这些概念，就可以解决 V2Ray 中大部分的问题。