---
layout: post
title:  "Hibernate配置"
date:   2018-3-29 2:29:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

一.数据持久化概念
--------------------
> 数据持久化是将内存中的数据模型转换为存储模型，以及将存储模型转换为
内存中的数据模型的统称。例如文件的存储~数据的读取等都是数据持久化操作。
数据模型可以是任何数据结构或对象模型，存储模型可以是关系模型，XML，二进制流等。

二.Hibernate框架
--------------------
> Hibernate是数据持久化工具，是一个开放源码的对象关系映射框架。Hibernate
内部封装了通过JDBC访问数据库的操作，向上层应用提供面向对象的数据访问api。

三.什么是ROM
--------------------
> ORM(Object/Relational Mapping)即对象/关系映射，是一种数据持久化技术。
它在对象模型和关系型数据库之间建立起对应关系，并且提供了一种机制，通过
JavaBean对象去操作数据库表中的数据。ORM在对象模型和关系数据库的表之间建立了一座桥梁，有了ORM程序员就不需要在使用SQL语句操作数据库中的表了，使用
API直接操作JavaBean就可以实现数据的增删改查了。Hibernate就是采用ORM对象关系映射技术的持久化开发的框架。

四.Hibernate的优缺点
--------------------
* 优点
	1. Hibernate功能强大，是java应用与关系数据库之间的桥梁，较之jdbc方式操作数据库，代码量大大减少，提高了持久化代码的开发速度，降低了成本呢
	2. Hibernate支持许多面向对象的特性，如组合，继承，多态等，使得开发人
	员不必在面向业务领域的对象模型和面向数据库的关系数据库模型之间来回切换，方便开发人员进行领域驱动的面向对象的设计与开发。
	3. 可移植性好。系统不会绑定在某个特定的关系型数据库上，对于系统更换数据库，通常只需要修改Hibernate配置文件即可正常运行。
	4. Hibernate框架开源免费，可以在需要时研究院代码，改写源代码，进行功能的定制，具有可扩展性。
* 缺点
	1. 不适合以数据为中心大量使用存储过程的应用。
	2. 大规模的批量插入，修改和删除不适用Hibernate。
	Hibernate不适用于小型项目；也不适用与关系模型设计不合理不规范的系统

五.Hibernate环境搭建
--------------------
*使用Hiber的准备工作
1.下载jar包--2.部署jar包--3.创建配置文件hibernate.cfg.xml--4.创建持久化类和映射文件

1. Hibernate[官方网站](http://www.hibernate.org)
2. 将下载的hibernate3.jar和lib/required目录下的jar包及Oracle数据库驱动
jar包复制到建好的工程web-inf下的lib目录中。或者通过BuildPath--》configureBuildPath选项导入。
3. 创建Hibernate配置文件hibernate.cfg.xml
	```xml
		<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
    <session-factory>
        <!-- Database connection settings -->
        <property name="connection.driver_class">oracle.jdbc.driver.OracleDriver</property>
        <property name="connection.url">jdbc:oracle:thin:@localhost:1521:orcl</property>
        <property name="connection.username">scott</property>
        <property name="connection.password"></property>
        <!-- SQL dialect -->
        <property name="dialect">org.hibernate.dialect.Oracle10gDialect</property>
        <!-- Echo all executed SQL to stdout -->
        <property name="show_sql">false</property>
        <mapping resource="entity/Zzzxb.hbm.xml"/>
    </session-factory>
</hibernate-configuration>
	```	

4. 创建持久化类(实体类)和映射文件
	```xml
	<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping PUBLIC
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
<hibernate-mapping >
    <class name="entity.Zzzxb" table="Zzzxb">
        <id name="id" column="id">
            <generator class="assigned"/>
        </id>
        <property name="name" column="name"/>
    </class>
</hibernate-mapping>
	```