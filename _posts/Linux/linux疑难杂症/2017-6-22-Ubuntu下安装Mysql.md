---
layout: post
title:  "Ubuntu下安装MySQL!"
date:   2017-6-22 10:54:00 +0800
categories: Linux
tag: Linux
---

* content
{:toc}

安装Mysql
--------------------------------

今天安装MySQL只会下载WorkBench不会下载Mysql数据库,所以记录一下安装过程方便下次忘记了使用.

CTRL+ALT+T打开终端,输入 sudo apt-get update 不然那可能会出现无法下载的错误

+ 然后输入 sudo apt-get install mysql-server mysql-client 下载mysql服务器和客户端 
+ 安装时都会问你希望继续执行吗，输入Y就行.
![2017-06-22 10-48-31屏幕截图]({{ '/styles/images/2017-06-22 10-48-31屏幕截图.png' | prepend: site.baseurl  }})
+ 安装过程中会出现让设置MySQL的root密码的框框,输入你的密码确认即可.
![2017-06-22 10-47-08屏幕截图]({{ '/styles/images/2017-06-22 10-47-08屏幕截图.png' | prepend: site.baseurl  }})
+ 安装完成之后终端输入 mysql -uroot -p你的密码 看是否能进入MySQL
![2017-06-22 10-49-31屏幕截图]({{ '/styles/images/2017-06-22 10-49-31屏幕截图.png' | prepend: site.baseurl  }})

WorkBench
---------------------------------
安装mysql workbench

+ sudo dpkg -i mysql-workbench-community-6.3.5-1ubu1504-amd64.deb 如果安装不成功: 

+  apt-get-f install 

 然后重新输入命令 

+ sudo dpkg -i mysql-workbench-community-6.3.5-1ubu1504-amd64.deb

直接打开：
![2017-06-22 10-51-01屏幕截图]({{ '/styles/images/2017-06-22 10-51-01屏幕截图.png' | prepend: site.baseurl  }})
![2017-06-22 10-51-17屏幕截图]({{ '/styles/images/2017-06-22 10-51-17屏幕截图.png' | prepend: site.baseurl  }})



