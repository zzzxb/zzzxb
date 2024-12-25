---
layout: post
title:  "使用aliyun服务器的ubuntu系统部署java web项目遇到的问题"
date:   2019-11-11 8:14:42 +0800
categories: troublesome
tag: troublesome
---

* content
{:toc}

## 部署流程

1. 下载`JDK`, `TOMCAT`, `MYSQL`
2. 上传到`/usr` 或 `/opt` 下并解压
3. 配置JDK路径

    ```txt
        # vim /etc/profile(用vim打开profile 进行配置)
        export JAVA_HOME=/opt/java8
        export JRE_HOME=${JAVA_HOME}/bin
        export PATH=${JAVA_HOME}/bin:${PATH}
        # 配置完毕后关闭 :wq ,然后用下边的更新下配置
        # source /etc/profile
    ```

4. 为root用户设置密码 以及 创建一个新用户并开启权限
5. 导入 sql 文件到服务器数据库
6. 安全组中开启 `8080`端口 和 `3306`端口

## 错误

* 通过我电脑的cmd 和 navcat 去访问服务器上的数据库可以访问到
* Java WEB 访问数据库就会报出

```txt
Access denied for user 'zzzxb'@'localhost' (using password: YES)
```

## 解决办法(DONE)

* 这个问题就如上边显示的我们没有权限,我在创建数据库用户的时候直接通过
`create USER `new UserName`@`localhost` IDENTIFIED BY 'new Password`,这条语句创建的，通过新创建的用户登录mysql我们可以看到，里边查找不到我们创建的数据库，就是因为这个新创建的数据库没有权限，我们赋予新建用户权限就能对数据库进行访问了，关于用户创建和权限管理可以[查看这里](http://zzzxb.xyz/note/MySQL/5.%E5%88%9B%E5%BB%BA%E7%94%A8%E6%88%B7%E5%92%8C%E6%8E%88%E6%9D%83.html).
