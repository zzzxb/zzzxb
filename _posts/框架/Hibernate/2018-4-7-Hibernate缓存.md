---
layout: post
title:  "Hibernate缓存"
date:   2018-4-7 15:08:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

1.Hibernate缓存
---------------

缓存是计算机领域的概念，他介于应用程序和永久性数据存储源(如硬盘上的文件或者数据库之间)，起作用是降低应用程序直接读写永久性数据存储源的频率，从而提高应用的运行性能。缓存中的数据是是数据存储源中数据的复制，应用程序在运行时直接读写缓存中的数据，只在某些特定时刻按照缓存中的数据来同步更新数据存储源。

缓存的物理介质通常是内存，而永久性数据存储源的物理介质通常是硬盘或磁盘，应用程序读写内存的速度显然比读写硬盘的速度快。如果缓存中存放的数据量非常大，也会用硬盘作为缓存的物理介质。

###hibernate的缓存一般分为三类：
1. **一级缓存**：Session缓存称为一级缓存。由于Session对象的生命周期通常对应一个数据库事务，因此它的缓存是事务范围的缓存。一级缓存是必须的。在一级缓存中，持久化类的每个实例都具有唯一的OID。
2. **二级缓存**：SessionFactory缓存分为内置缓存和外置缓存。内置缓存是Hibernate自带的，不可拆卸，是只读缓存，用来存放映射元数据和预定义SQL语句。外置缓存是一个可配置的缓存插件，默认SessionFactory不会启用这个缓存插件你。外置缓存中的数据是数据库的复制。SesssionFactory的外置缓存称为hibernate的二级缓存。二级缓存由SessionFactory负责管理。SesssionFactory对象的生命周期和应用程序的整个进程对应。二级缓存是可选的，可以在每个类或每个集合的粒度上配置二级缓存。
3. **查询缓存**：他是Hibernate为查询结果提供的，依赖于二级缓存.

###缓存的作用范围分为3类：
1. **事务范围**:每个事务都有自己的缓存，缓存内数据不会被多事务并发访问。例如：hibernate的一级缓存，事务是不能跨多个Session的，Session内数据只能被当前事务访问，因此它属于事务范围的缓存。
2. **进程范围**：进程内的所有事物共享缓存，进程结束，缓存结束生命周期。例如，Hibernate的二级缓存，SessionFactory对象的生命周期对应应用程序的整个进程，因此它属于进程范围的缓存。
3. **集群范围**：缓存被一个或多个机器上的多个进程共享。Hibernate的二级缓存也可以作为集群范围的缓存。

2.Hibernate一级缓存
-------------------
Session内的缓存即一级缓存，位于缓存中的对象称谓持久化对象，它和数据库中的相关记录对应。Session能够在某些时间点，按照缓存中的变化来执行相关sql语句，从而同步更新数据库，这一过程称为刷新缓存。

当应用程序调用Session的save(),update(),saveOrUpdate(),load()或get()方法，以及调用Query查询接口的list()或iterate()方法时，如果在Session的缓存中还不存在相应的对象，Hibernate就会把该对象加入到一级缓存中。在刷新缓存时，Hibernate会根据缓存中对象的状态变化来同步更新数据库。由此可见，Session缓存有两大作用：

1. 减少访问数据库的频率。
2. 保证数据库中的相关记录于缓存中的相应对象同步。

```java
	Dept dept1 = (Dept) sessionn.get(Dept.class, new Byte("1"));
	Dept dept2 = (Dept) sessionn.get(Dept.class, new Byte("1"));
	System.out.println(dept1 == dept2);
	//第一行第一次进行加载，get()方法先到一级缓存中查找OID为1的Dept对象，由于还不存在这个Dept对象，因此通过select语句到数据库中年加载该对象，并把它放到一级缓存中。第2行第二次执行Session的get()方法，get()方法先到一级缓存中查找OID为1的Dept对象，由于已经存在这个Dept对象，就直接返回该Dept对象的引用，不会再执行select查询语句。因此再示例7中，只执行了一次select语句，变量dept1和dept2引用的时同一个Dept对象，第三行输出true
```

Sessionn为应用程序提供了两个管理缓存的方法。
1. evict(Objecto) :从缓存中清除指定的持久化对象。

```java
	Dept dept1 = (Dept) session.get(Dept.class, new Byte("1"));
	session.evict(dept1);
	Dept dept2 = (Dept) session.get(Dept.class, new Byte("1"));
	System.out.println(dept1 + "~~~" + dept2);
	System.out.println(dept1 == dept2);
	//第1次执行Sessionn的get()方法，get()方法先到一级缓存中查找OID为1的Dept对象，由于还不存在这个Dept对象，因此通过select语句到数据库中加载该对象，并把它放到一级缓存中。第2行session.evict()方法清除了缓存中的Dept对象。第3行第二次执行Session的get()方法，get()方法先拿到一级缓存查找OID为1的Dept对象，由于荣然不存咋这个Dept对象，因此通过select语句到数据库中加载该对象，再次执行select查询语句。因此再这段代码中，执行了两次select语句，变量dept1和dept2指向了不同的Dept对象，第4行输出了false。
```

2. clear():清空缓存中的所有持久化对象。
另外说一下flush().方法。
```java
	Dept dept = (Dept)sessionn.get(Dept.class, new Byte("1"));
	dept.setDeptName("测试部");
	dept.setDeptName("质控部");
	tx.commit();
	//Hibernate执行以下update语句:update dept set dname=?,loc=? where deptno=? Dname字段被修改为"质控部"。在上边基础上增加flush()方法执行。

	Dept dept = (Dept) ssession.get(Dept.classs, new Byte("1"));
	dept.setDeptName("开发部");
	session.flush();
	dept.setDeptName("市场部");
	tx.commit();
	//这段代码中Hibernate执行了以下两条update语句：
	//update dept set dname=?,loc=? where deptno=?
	//update dept set dname=?,loc=? where deptno=?
```
在上面代码中增加session.flush()语句后，flush()方法会强制进行从缓存到数据库的同步。在通过Session进行批量操作时，可以使用flush()和clear()方法配合实现.
```java
	Emp emp = null;
	for(int i = 0; i<10000; i++){
		emp = new Emp(i, "emp"+i);
		session.save(emp);
		if(i%30 == 0){
			session.flush();
			session.clear();
		}
	}
	tx.commit();
```
这段代码向Emp表中插入了10000条记录，每次批量插入30条Emp记录。程序执行sesion.fluh()方法时，会先向数据库批量插入30条记录，执行session.clear()方法把刚添加的30个Emp对象从一级缓存中清空。执行这段代码时注意以下两点:

1. 如果希望提高批量插入的行你能，可以在hibernate.cfg.xml中,把hibernate.jdbc.batch_size 属性设置为30.但要注意，Emp对象的主键生成器不能为identity,因为如果使用了identity标识符生成器，hibernate会自动关闭JDBC的批量执行操作，batch_size的设置就不起作用。
2. 也可以禁止使用二级缓存，因为如果使用了二级缓存，那么一级缓存中的对象会先复制到二级缓存中，再保存到数据库，这样会导致大量不必要的开销。

一级缓存随着Session的开启而产生，随着Sessiion的关闭而结束，之前在程序中持久化在操作的都是一级缓存中的对象。要合理地管理好缓存，提高程序效率，可以通过clear() , evict()方法来清除缓存中的对象。

3.Hibernate二级缓存
-------------------
二级缓存时进程或集群范围内的缓存，可以被所有的Sesssion共享，其生命周期和SessionFactory一样。二级缓存是可配置的插件。Hibernate打包一些开源缓存实现，提供对他们的内置支持。

|缓存插件|缓存实现类|查询缓存|类型|
|-|-|-|-|
|EHCache|org.hibernate.cache.EHCacheProvider|支持|进程范围的缓存；内存或者硬盘|
|OSCache|org.hibernate.cache.OSCacheProvider|支持|进程范围的缓存；内存或者硬盘|
|SwarmCache|org.hibernate.cache.SwarmCacheProvider|不支持|集群范围的缓存|
|JBossCache|org.hibernate.cache.TreeCacheProvider|支持|集群范围的缓存|

为了把表中的缓存插件集成到hibernate中,Hibernate提供了CacheProvider接口，它是缓存插件与hibernate之间的适配器。表中的缓存实现类就是CacheProvider的不同实现。

###配置二级缓存的步骤如下:
1. 选择合适的缓存插件，配置其自带的配置文件。
2. 选择需要使用二级缓存的持久化类，设置它的二级缓存的并发访问策略。
以EHCache配置为例:

1. 将ehcache.xml文件添加到类路径下。
>在路径hibernate-distrbution-3.3.2GA\project\etc下复制ehcache.xml
><cache>标签为每个需要二级缓存的类和集合设定缓存的数据过期策略。配置如下

```xml
	<!--缓存的名称，取值为列的完整名称或类的集合的名称-->
	<cache name ="sampleCachel"
	<!--基于缓存可存放的对象的最大数目-->
		macElementsInMemeory="1000"
	<!--如果true,表示对象永不过期，默认false-->
		eternal="true"
	<!--设置允许对象处于空闲状态的最长时间，单位是秒-->
		timeToldleSeconnds="0"
	<!--设置允许存在于缓存中的最长时间，单位是秒-->
		timeToLiveSeconds="0"
	<!--是否将溢出的对象写到基子硬盘的缓存中-->
		overflowToDisk="false"
	/>
```

2. 开启二级缓存：
```xml
	<property name="hibernate.cache.use_second_level_cache">true</property>
```
3. 指定缓存产品提供商
```xml
	<property name="hibernate.cache.provider_class">
		org.hibernate.cache.EhCacheProvider
	</property>
```
4. 指定使用二级缓存的持久化类。修改持久化类的映射文件,为\<class\>元素添加\<cache\>元素，配置如下:
```xml
	<class name="Student" table="STUDENT">
		<cache usage="" region="" include=""/>
	</class>
```

* \<cache\>的属性:
	* usage属性是必须的，指定并发访问策略，取值为transactional(事务缓存),read-write(读/写缓存)，nonstrict-read-write(非严格读/写缓存)或read-only(只读缓存).
	* region属性可选，默认为类或者集合的名称
	* include属性可选，取值为non-lazy(当缓存一个对象时，不会缓存它的映射为延迟加载的属性),all,默认取值为all.

####注意
配置EHCache二级缓存时，需要添加如下jar包到程序中:
1.  ehcache-1.2.3.jar, EHCache包.
2. commons-logging-1.1.1.jar, 日志包。