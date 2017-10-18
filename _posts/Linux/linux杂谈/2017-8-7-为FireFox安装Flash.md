---
layout: post
title:  "为FireFox安装Flash"
date:   2017-8-7 11:18:00 +0800
categories: Linux
tag: Linux
---

* content
{:toc}


1. 查看/usr/lib目录下是否有mozilla目录(没有了就创建) 
	* `sudo mkdir -p /usr/lib/mozilla/plugins`
2. 把下载的的flash.gar.gz的找个地方解压一下
	* `tar -zxvf flash_player_npapi_linux.x86_64.tar.gz`
3. 把解压后的libflashplayer.so复制到刚才创建的目录下
	* `sudo cp ./libflashplayer /usr/lib/mozilla/plugins`  

然后查看FireFox的附加插件-插件中就会多出一个Shockwave Flash.
后边调成永久启用就行了
