---
layout: post
title:  "使用aliyun的ubuntu系统部署java web项目遇到的问题"
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
        export JAVA_HOME=/opt/java8
        export JRE_HOME=${JAVA_HOME}/bin
        export PATH=${JAVA_HOME}/bin:${PATH}
    ```

4. 为root用户设置密码 以及 创建一个新用户并开启权限
5. 导入 sql 文件到服务器数据库
6. 安全组中开启 `8080`端口 和 `3306`端口

## 错误

* 通过 本机的cmd 和 navcat 去访问服务器上的数据库可以访问到
* Java WEB 访问数据库就会报出

```txt
Access denied for user 'root'@'localhost' (using password: YES)
```

## 解决办法(待解决)
