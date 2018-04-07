---
layout: post
title:  "Hibernate关联映射"
date:   2018-4-7 9:40:01 +0800
categories:	框架
tag: Hibernate
---

* content
{:toc}

1.关联关系
----------
1. 多对一
```java
	//单项多对一关联
	//例:Dept.java（部门）,Emp.java(员工)
	//Dept.java
	public class Dept implements Serializable{
		private Byte deptNo;//部门编号
		private String deptName;//部门名称
		private String location;//部门地址
		//构造方法和setter和getter方法省略
	}
	//Emp.java
	public class Emp implements Serializable{
		private Integer empNo;//员工编号
		private String empName;//员工姓名
		private Dept dept;//所属部门
	}
	//Emp.hbm.xml
	...
		//Emp表关联的表以及主键
	<many-to-one name="dept" column="DEPTNO"
		class="src下实体类的位置"></many-to-one>

	//添加-删除和数据库中的删除性质相同，不过是用面向对象方式解决而已
	Dept dept = new Dept(nnew Byte("22"),"学习部","校部");
	session.save(dept);
	Emp emp = new Emp(10,"Zzzxb",dept);
	session.save(emp);
	tx.commit();
```
2. 一对多
```java
	//一对多和多对一是相对的，下面只是对上边多对一的修改
	//双向一对多关联
	//Dept.java
	public class Dept implemennts Serializalole{
		private Byte deptNo; //部门编号
		private String deptName; //部门名称
		private String location; //部门地址
		priavet Set<Emp> emps = new HashSet<Emp>();//员工集合
		public Set<Emp> getEmps(){
			return emps;
		}
		public void SetEmps (Set<Emp> emps){
			this.emps=emps;
		}
		...setter and getter
	}
	//Dept.hbm.xml
	<set name="emps">//emps是员工类集合
		<key column="DEPTNO"></key>
		<one-to-many class="emp实体类位置"/>
	</set>
```
	*双向关联关系下的增删改操作
	1.set中cascade属性(Oracle中的级联操作)
		1.none
		2.save-update
		3.delete
		3.all
```java
	//增-(删 改和查与之前操作一样这里不一一赘述了）
	Dept dept = new Dept(new Byte("22"),"学习部","系部");
	Emp emp = new Emp(1,"Zzzxb");
	emp.setDept(dept);
	dept.getEmps().add(emp);
	session.save(dept);
	tx.commit();

	Dept dept = (Dept)sessssion.load(Dept.class,new Byte("22"));
	sessionn.delete(dept);
	tx.commit();
```
	2.set中inverse属性
		1.inverse译为"反转",false为主动方,一般在one方使用true
```java
	//更换绑定，即把学生从部门中的学习部转到纪律部
	Dept dept = (Dept) session.load(Dept.class, new Byte("7"));
	Emp emp = (Emp) session.load(Emp.class, new Integer("4"));
	//建立Dept和Emp的关联关系
	emp.setDept(dept);
	dept.getEmps().add(emp);
	tx.commit();
```
	3.set中order-by属性
		1.asc和desc（升序降序）只对set中元素排序
```java
	//加载持久化对象Dept和Emp
	Dept dept = (Dept) session.get(Dept.class, new Byte("10"));
	Set<Emp> emps = dept.getEmps();
	for(Emp emp : emps){
		syso(emp.getEmpName());
	}
```
3. 多对多
	1. 通过中间表关联(例:项目(Project)-中间表(Proemp)-员工(Employee))
```java
	//在Project类中定义employeess属性的代码如下:
	public class Project implemennts java.io.Serializable{
		private Integer proid;
		private Sstrinng proname;
		private Seet<Employee> employees=new HashSet<Employee>(0);
	}
	//在Project.hbm.xml文件中,映射Project类的employees属性代码如下:
	<set name="employees" table="PROEMP" cascade="save-update">
		<key column="RPROID"/>
		<many-to-many class="employee实体类位置" column="REMPID"/>
	</set>
	//多对多中不建议把cascade属性设为all(多对多级连删除容易出错)
	Employee employee1 = new Employee(5,"Zzzxb");
	Employee employee2 = new Employee(6,"Zpp");
	Project project1 = new Project(5,"5号项目");
	Project project2 = new Project(6,"6号项目");
	project1.getEmployees().add(employee1);
	project1.getEmployees().add(employee2);
	project2.getEmployees().add(employee1);
	session.save(project1);
	session.save(project2);
	tx.commit();
```
	2. 配置双向多对多关联
	*对于双向多对多关联，需要把其中一段的inverse属性改为true
```java
	//Project.hbm.xml
	<set name="employees" table="PROEMP" cascade="save-update">
		<key column="RPROID"/>
		<many-to-many class="Employee实体类" column="REMPID"/>
	</set>
	//Employee.hbm.xml
	<set name="projects" inverse="true" table="PROEMP">
		<key column="REMPID"/>
		<many-to-many class="Project实体类位置 column="RPROID"/>
	</set>
```
* 一对多和多对一是相对这种关系跟数据库中外键的意思是相同的。通过反向生成工具可生成。


2.延迟加载
----------
当Hibernate从数据库中加载Dept对象时，如果同时自动加载所有关联的Emp对象，而程序世界上仅仅需要访问Dept对象,那么这些关联的Emp对象就白白浪费了许多内存空间。

Hibernate查询Dept对象时,立即查询并加载与之关联的Emp对象，这种策咯称为立即加载。立即加载存在两大不足。
>(1)select语句数目太多，需要频繁地访问数据库，会影响查询性能。
>(2)在应用程序只需要访问Dept对象，而不需要访问Emp对象的场合，加载Emp对象完全是多余操作，这些多余的Emp对象白白浪费了许多空间。

>Hibernate允许对象-关系映射文件中配置加载策略。

|类别名|<class>元素中lazy属性可选值为:默true(延迟加载) false(立即加载)|
|-|:-:|
|一对多关联级别|<set>中lazy属性可选值为:true(延迟加载) extra(增强延迟加载) 和 false(立即加载)|
|多对多关联级别|<many-to-many>元素中lazy属性可选proxy(延迟加载) no-proxy(无代理延迟加载)和false(立即加载);<many-to-one>元素中的lazy属性默认为proxy|

3.Open Session In View 模式
----------------------------
内容不完全，更多自行查找