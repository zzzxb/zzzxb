---
layout: post
title:  "Windows安装pip!"
date:   2018-1-5 16:06:01 +0800
categories: python
tag: python
---

* content
{:toc}

 pip和easy_install.py是一款python包的管理工具,easy_install.py在python2.7中是默认安装的。<br>

#### [Download] ####
下载pip的安装包 下载地址:https://pypi.python.org/pypi/pip#downloads<br>
注意选择tar.压缩包

#### [解压安装] ####
下载后解压,进入目录cmd中输入<code>python setup.py install</code><br>

#### [添加环境变量] ####
在系统环境变量中添加python的根目录和python/Scripts

#### [pip常用命令] ####
* 安装包<br>

<code>pip install xxx</code></br>

* 升级包,可使用-U或者--upgrade<br>

<code>pip install -U xxx</code><br>

* 卸载包

<code>pip uninstall xxx</code><br> 

* 列出已安装的包

<code>pip list</code><br>

#### [常见问题] ####
1. AttributeError:'module' object has no attribute 'wraps'<br>
	pip版本安装错误,更新最新版本pip

