---
layout: post
title:  "Ubuntu锁屏后出现Dock"
date:   2018-7-12 9:50:00 +0800
categories: Linux
tag: Linux
---

* content
{:toc}


前天装完ubuntu后又装了一个dash to dock插件，锁屏后一直出现Dock找不到哪里出现的毛病.

经查找Lock后的Dock是Ubuntu自带的，与我下载的那个有冲突。



解决办法就是删除**usr/share/gnome-shell/extensions**下的**ubuntu-dock**就ｏｋ了！



* 记得备份，不然想还原的的时候找不到了。