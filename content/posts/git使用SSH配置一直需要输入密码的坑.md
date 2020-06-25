---
title: git使用SSH配置一直需要输入密码的坑
date: 2019-11-28 10:07:07
tags: ["git ssh"]
premalink: git-ssh-config
slug: git-ssh-config
type: post
---

一般 git 提供了 HTTPS 和 SSH（Secure Shell） 两种认证方式。HTTPS 比较简单，只需要输入对应的 user 和 password 就可以了。SSH 则相对复杂一点，需要使用 ssh 命令生成 RSA 密钥对，将 public key 提交到服务器，本地保留 private key。SSH 还可以允许我们通过 config 来管理多用户，例如：一般我们会有一个自己的 github 账户，通过 SSH 管理；同时，公司可能会有一个另外的源码管理平台，如 gitlab 或 gitee 等，一些公司还会在 gitlab 上搭建自有服务器。*SSH 如何生成密钥对，如何通过 config 管理，这里就不做过多赘述了，网上随便一搜或者 github 中都有详细的说明：）*

SSH 的 config 格式一般如下：

```shell
Host # 登陆主机的别名
HostName # 服务器的真实地址
Identityfile # 私钥目录
```

在前不久，~~上班摸鱼~~逛 v2ex 的时候，看见一个人发了一个帖子：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/2019-12-10-031615.jpg" alt="image-20191128102137393" style="zoom:50%;" />

在上家公司的时候，我也遇到了同样的问题。每次重启 iTerm2 或者电脑，再 pull 或者 push 代码，就提示要输入密码，无论输入什么密码都提示错误。我一度以为是我人品问题，后来一阵摸索~~瞎试~~之后，将 Host 改成 HostName 相同的，就可以解决了。也就是说，如果你公司源码管理平台的地址是 gitlab.xxx.xxx，只需要将 Host 和 HostName 一起改成这个，就可以了。

再回过头来看看，config 中的 Host 和 HostName，Host 是指主机别名，HostName 是指向真实地址。也就是说如果服务器的别名是 test，真实 IP 地址是 0.0.0.0，只需要将 Host 配置成 test，HostName 指向 0.0.0.0，然后再配合本地私钥就可以登陆上去访问了。但在实际中，公司搭建自有主机的时候，其实际主机别名跟其实际地址指向是一样的。如果是搭建在 gitlab 中，如果只在 config 中将 Host 指向 gitlab，那么就会出现一直需要密码的情况，只能重新生成密钥对去进行一次性的访问。

希望这篇文章能解决你在 SSH 使用过程中出现的类似的问题：），Have a good day！