---
layout: post
title:  "Ubuntu下配置Maven"
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

# maven存储库使用

    现在大部分ide上都有maven的相关插件使用也是相当方便，但是用外部扩展的时候总找不到是否有这个存储库等，线面就是maven的存储库搜索网站和在pos.xml中的用法

    [maven存储库](https://mvnrepository.com)

    ```xml
    <!-- 例如使用mybatis 存储库搜索到的是 org.mybatis >> mybatis -->
    <dependencies>
    <!-- 外部存储库 -->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <!-- 查看过后选择使用版本 -->
            <version>3.4.6</version>
        </dependency>
    <!-- 内部存储库 -->
        <dependency>
            <groupId>com.xxx</groupId>
            <artifactId>xxx</artifactId>
            <version>1.0</version>
            <scoper>system</scoper>
            <!-- 自己创建一个lib包来存放本地存储库 -->
            <systemPath>${project.basedir}/lib/xxx.jar</systemPath>
        </dependency>
    </dependencies>
    ```