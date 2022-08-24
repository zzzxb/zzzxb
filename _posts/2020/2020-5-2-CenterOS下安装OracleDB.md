---
layout: post
title:  "CenterOS 下安装Oracle数据库"
date:   2020-5-2 00:03:01 +0800
categories:  Database
tag: Oracle
---

* content
{:toc}

今天安装数据库的时候发现只会安装Windows上的，不会安装Linux上的数据库，大概流程记录一下，做个笔记

**本例子使用的 CenterOS , Ubuntu 下的可以照葫芦画瓢**

[官网 Linux 下安装 Oracle指南](https://docs.oracle.com/en/database/oracle/oracle-database/18/xeinl/)

## 下载安装包

[Oracle 数据库下载](https://www.oracle.com/cn/database/technologies/oracle-database-software-downloads.html)


## 下载依赖

`yum install -y bc compat-libcap1 compat-libstdc++-33 glibc-devel ksh \libaio-devel libstdc++-devel xorg-x11-utils xorg-x11-xauth`

`yum install net-tools bind-utils nfs-utils psmisc unzip sysstat smartmontools`

除此只外只要看见缺少什么依赖就执行 `yum install 依赖1 [依赖2] [依赖3]`...等等

## 配置

执行这条命令 `/etc/init.d/oracle-xe-18c configure`后会出现

```text
Specify a password to be used for database accounts. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9]. Note that the same password will be used for SYS, SYSTEM and PDBADMIN accounts:

指定用于数据库帐户的密码。Oracle建议输入的密码长度至少为8个字符，包含至少1个大写字符、1个小写字符和1位数字[0-9]。请注意，SYS、SYSTEM和PDBADMIN帐户将使用相同的密码:
```

输入完密码后就会自动执行一系列配置，执行数据库操作，这里会比较慢，静静等待即可.

切换到 oracle 用户 `su - oracle`
添加路径 `vim ~/.bash_profile`

```text
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/18c/dbhomeXE
export PATH=$PATH:$ORACLE_HOME/bin
```

这是我的路径，这个路径不同用户可能路径不同

`source ~/.bash_profile`

## 开始使用

`sqlplus sys/password /as sysdba`