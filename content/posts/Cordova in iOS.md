---
 title: Cordova in iOS
 date: 2016/09/08
 tags: ["Cordova"]
 toc: true
 type: post
 permalink: Cordova
---

Cordova 的前身是 PhoneGap，是一个 Hybrid 框架，可以让开发者使用HTML、Javascript、CSS开发跨平台的App。

<!--more-->

# 环境搭建
安装Cordova:


```ObjectiveC
sudo npm install -g cordova
```

如果提示错误，检查是否安装 Node.js

# 创建项目

**创建工程项目：**


```ObjectiveC
cordova create Cordova com.example.CordovaTest CordovaTest
```
第一个参数为工程文件夹
第二个参数为应用的的 id 名，和 Xcode 中的 bundle Id 类似
第三个参数为工程名字

**添加 iOS 平台支持**

进入刚刚创建的工程目录下，执行：


```ObjectiveC
cordova platform add ios
```

执行这个命令只出现光标没有反应的话，是因为网络原因。由于国内的网络环境，虽然的 npm 官方站点 http://www.npmjs.org/ 并没有被墙，但是下载第三方依赖包的速度有时还是不理想，我们可以改用淘宝的 NPM 镜像。

打开 ~/.npmrc 文件：


```ObjectiveC
vim ~/.npmrc
```

添加以下内容：


```ObjectiveC
registry = https://registry.npm.taobao.org
```

保存退出，再执行命令就会发现很快就配置好了。

打开 platforms/ios 目录，就可以运行我们的创建的工程了。













