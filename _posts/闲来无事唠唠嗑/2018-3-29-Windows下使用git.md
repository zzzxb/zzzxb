---
layout: post
title:  "Git安装和基本使用!"
date:   2018-3-29 20:21:01 +0800
categories: HelloBlog
tag: HelloBlog
---

* content
{:toc}

# 下载并安装git

先去[GitHub官网](https://github.com)注册一账号，这里可以创建仓库帮你托管好多东西.  
[Git下载地址](https://git-scm.com)  
ubuntu:``sudo apt install git``  
centerOS:``sudo yum install git``  
一步步默认安装下来就ok了。
``git --version``使用看看版本ok，基本就ok了。windows中右键菜单中**Git Bash**

# 在本地创建ssh key

``$ ssh-keygen -t rsa -C "your_email@youremail.com"``  
``$ git config --global user.name "your name"``  
``$ git config --global user.email "your_email@youremail.com"``

* 下还是看
[github简明教程](http://www.runoob.com/w3cnote/git-guide.html)吧，已经有很好的教程了，我就不再去赘述了.