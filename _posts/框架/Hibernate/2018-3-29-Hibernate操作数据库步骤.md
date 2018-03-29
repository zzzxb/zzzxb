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
2. 读取并解析映射信息,创建SessionFactory对象
> <code>SessionFactory sf = conf.buildSessionFactory();</<code>
3. 打开Session
> <code>Session session = sf.openSession();</code>
4. 开始一个事物(增删改操作必须，查询操作可选)
> <code>Transaction tx = session.beginIransaction();</code>
5. 数据库操作
> <code>session.save();</code>
6. 结束事物
> 提交事物<code>tx.commit();</code>回滚事物<code>tx.rollback();</code>
7. 关闭session
> session.close();