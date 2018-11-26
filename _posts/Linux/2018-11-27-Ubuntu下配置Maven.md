---
layout: post
title:  "Ubuntu下安配置Maven"
date:   2018-11-27 02:00:00 +0800
categories: Linux
tag: Linux
---

* content
{:toc}

# 系统要求

[更多请看Maven菜鸟教程](http://www.runoob.com/maven/maven-tutorial.html)

项目|要求
-|:-
JDK|Maven 3.3要求JDK1.7或以上版本(其它不说了)
内存|没有要求
磁盘|文件大约10MB,仓库大小取决于使用情况,预期500MB(学习嘛有20M空间就ok了)

# 检查Java安装

操作系统|任务|命令
:-:|:-:|:-:
Linux|终端|java -version

# Maven下载

[Maven下载地址](http://maven.apache.org/download.cgi)

二进制文件,别下成源码了

# 配置环境变量

    # wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
    # tar -xvf  apache-maven-3.3.9-bin.tar.gz
    # sudo mv -f apache-maven-3.3.9 /usr/local/

* 编辑 **/etc/profile** 文件,末尾添加

```profile
export MAVEN_HOME=/usr/local/apache-maven-3.6.0
export PATH=${PATH}:${MAVEN_HOME}/bin
```

* 保存文件并运行**source /etc/profile**使环境变量生效
* **mvn -v** 查看Maven版本信息