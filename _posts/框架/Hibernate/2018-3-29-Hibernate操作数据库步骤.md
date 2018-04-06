---
layout: post
title:  "Hibernate操作数据库7个步骤!"
date:   2018-3-29 3:29:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

一.Hibernate操作数据库7个步骤!
--------------------
1. 读取并解析配置文件
> <code>Configuration conf = new Configuration().configure();</code>
> 根据默认位置的Hibernate配置文件的配置信息，构建Configuration对象。Configuration 负责管理Hibernate的配置信息。

2. 读取并解析映射信息,创建SessionFactory对象
> <code>SessionFactory sf = conf.buildSessionFactory();</<code>
> SessionFactory负责创建Session对象。Configura对象会根据当前的数据库
配置信息，构造SessionFacctory对象。SessionFactory对象一旦构建完毕，则Configura对象的任何变更将不会影响已经创建的SessionFactory对象。如果Hibernate配置信息有改动，那么需要基于改动后的Configuration对象重建构建一个SessionFactory对象.

3. 打开Session
> <code>Session session = sf.openSession();</code>
> Session是Hiberante持久化操作的基础。Session负责完成对象的持久化操作，它相当于JDBC中的Connection。Session作为贯穿Hiberante的持久化管理器的核心，提供了众多持久化方法，如save(),delete(),update(),get(),load()等。通过这些方法，即可透明地完成对象的增删改查(CRUD)。

4. 开始一个事物(增删改操作必须，查询操作可选)
> <code>Transaction tx = session.beginIransaction();</code>

5. 数据库操作
> <code>session.save();</code>

6. 结束事物
> 提交事物<code>tx.commit();</code>
> 回滚事物<code>tx.rollback();</code>

7. 关闭session
> session.close();
> 如果在Hibernate配置文件中，参数current_session_context_class设置为thread,并采用SessionFactory的getCurrentSession()方法获得session，则不需要执行session.close()方法.