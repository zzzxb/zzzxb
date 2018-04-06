---
layout: post
title:  "HibernateUtil"
date:   2018-4-6 17:30:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

*在项目开发过程中，通常使用工具类来管理SessionFactory和Session，代码如下所示。

1.HibernateUtil
----------------

```java
public class HibernateUtil {
	//初始化一个ThreadLocal对象,ThreadLocal对象有get(),set()方法.
	private static final ThreadLocal sTL = new ThreadLocal();
	private static Configuration conf = null;
	private static SessionFactory sf = null;
	static{
		try {
			conf = new Configuration().configure();
			sf = conf.buildSessionFactory();
		} catch (Throwable ex) {
			ex.printStackTrace();
			throw new ExceptionInInitializerError(ex);
		}
	}
	
	public static Session currentSession(){
		//sTL的get()方法根据当前线程返回其对应的线程内部变量，即Session对象，多线程的情况下共享数据库连接是不安全的。ThreadLocal保证了每个线程都有自己独立的Session对象。
		Session session = (Session) sTL.get();
		//如果session为null，打开一个新的session
		if(session == null){
			//创建一个Session
			session=sf.openSession();
			//保存该session对象到ThreadLocal中
			sTL.set(session);
		}
		//如果当前线程已经访问过数据库，则从sTL中get()就可以获取该线程上次获取过的session对象
		return session;
	}

	/*关闭session，首先调用sTL.get()方法获取session对象，接着调用sTL.set
	 *(null)方法，把sTL管理的Session对象置为NULL，最后关闭Session。
	 */
	public static void closeSession(){
		Session session = (Session)sTL.get();
		sTL.set(null);
		session.close();
	}
}
```
*通过ThreadLocal类，既实现了多线程并发，同时，也实现Singleton单例模式。
*做项目时建议使用HibernateUtil