---
layout: post
title:  "Hibernate实现增删改查"
date:   2018-4-6 17:40:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

1.Hibernate按主键查询
----------------------
```java
	public void GetAndLoad(){
		try {
			 Session session = HibernateUtil.currentSession();
			 /*在进行修改或删除操作时，应先加载对象，然后再执行修改或删除操作。
			  *hibernate提供了两种方法按照主键加载对象：load()和get()
			  */
			 
			 //get()方法,按主键查找,找不到的话会报-指针为空的异常
//			 Dept dept = (Dept) session.get(Dept.class, new Byte("11"));
//			 System.out.println(dept.getDeptno() + "\t" + dept.getDname() + "\t"
//					 + dept.getLoc());
			 //load()方法,找不到会报-对象找不的异常
			 Dept dept1 = (Dept) session.load(Dept.class, new Byte("11"));
			 System.out.println(dept1.getDeptno() + "\t" + dept1.getDname() + "\t"
					 + dept1.getLoc());
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			HibernateUtil.closeSession();
		}
	}
```

2.增加操作
-----------------
1. new一个实体类Zzzxb并设置属性
2. 通过session.save(Zzzxb);持久化操作
3. 通过tx.commit();提交事务

3.修改操作
-----------------
1. 通过load或get先获取对象
2. 通过对象的set属性来更改
3. 通过commit提交事务

4.删除操作
-----------------
1. 先获取对象
2. 通过sessiion.delete();来持久化操作
3. 通过commit提交事务


*增删改操作要在事务环境中进行完成。
<code>tx = session.beginTrannsaction();</code>