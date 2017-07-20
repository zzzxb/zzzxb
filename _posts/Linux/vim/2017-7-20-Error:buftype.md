---
layout: post
tile: "Vim保存报错"
date: 2017-7-20 21:47:00 +0800
categoried: Linux
tag: Vim
---

* content
{:toc}

E382:Vannontwite,'buftype' option is set
解决方法如下:
可用下面的命名查看buftype的设置，当buftype=cofile时，不能保存文件，只有当buftype=null时，才可以保存

	:verbose set buftype

修改buftype的方法： vim切换至ex模式，输入

	:setlocal buftype=

如果想改回原设置，可以用下面命令：

	:setlocal buftype=nofile

