---
layout: post
title: "MySQL 笔记"
date: 2025-02-25 20:41:00 +0800
tag: MySQL
---

* content
{:toc}

## JSON

1. JSON文档元素可以被快速访问
2. 服务器再次读取JSON文档时夫需要重新解析文本
3. 可以直接通过文档元素作为条件，而不需要查询整个文档 

```sql
# 创建表
create table detail (
    id INT primary key auto_increment,
    name VARCHAR(16) not null,
    other JSON
)

# 添加数据
insert detail(name, other) values('Zzzxb', '{
  "age": "18",
  "gender": "man",
  "hobby": [
    "programme",
    "game"
  ],
  "from": {
    "country": "China",
    "province": "BeiJing"
  }
}');

# 查询数据 - 查询来自JSON内部字段
select other->>'$.from' from detail;
# 查询数据 - 格式美化
select JSON_PRETTY(other) from detail;
select JSON_PRETTY(other->>'$.from') from detail;
```
### JSON FUNCTION

* `JSON_PRETTY` 美化JSON文档
* `JSON_CONTAINS` 包含数据, 存在返回 1, 不存在返回0, 不存在key为null
* `JSON_CONTAINS_PATH` 存符合一个或多个条件, 存在返回 1, 不存在返回0, 不存在key为null
* `JSON_SET` 替换现有值并添加不存在的值
* `JSON_INSERT` 插入值，但不替换现有值
* `JSON_REPLACE` 仅替换现有值
* `JSON_REMOVE` 从文档中删除数据
* `JSON_KEYS` 获取JSON文档中的所有键
* `JSON_LENGTH` 给出JSON文档中的元素个数 

[延申阅读](https://dev.mysql.com/doc/refman/8.0/en/json-function-reference.html)

## 公用表达式(CTE)

使用CTE后，子查询只会计算一次，而使用派生类，查询会根据派生表的引用次数
进行多次查询

1. 查询结果可以**多次复用**, 多次操作同一张表时可以通过CTE复用
2. 分为非递归和递归

### 非递归

```sql
# 示例只是展示使用方式，并不没有展示具体场景
# 派生表(子查询)
select d.name, ed.details from
(select * from detail) as d, emp_details as ed
where d.name = ed.details->>'$.name';

# 单个cte
with nickname as (select * from detail)
select nk1.name, nk2.other from
             nickname as nk1,
             nickname as nk2
where nk1.name = nk2.name;

# 多个cte
with nickname1 as (select * from detail),
     nickname2 as (select * from emp_details)
select nk1.name, nk2.details from
             nickname1 as nk1,
             nickname2 as nk2
where nk1.name = nk2.details->>'$.name';
```

### 递归

递归CTE是一种特殊的CTE, 其子查询会引用自己的名字。
`WITH` 子句必须以 `WITH RECURSIVE` 开头。
递归CTE子查询包裹两部分: `seed` 查询和 `recursive` 查询,
由 `UNION [ALL]` 或 `UNION DISTINCT` 分隔。

```sql
# 格式
WITH RECURSIVE cte as
(select * from table_name) /* seed select*/
union all
(select * from cte, table_name) /* recursive select */
select * from cte;

# 打印从1到5的所有数字
WITH RECURSIVE cte (n) as
(select 1
 union all
 select n + 1 from cte where n < 5
)
select * from cte;
```

## 生成列

* `virtual` 生成列: 从表中读取记录，将计算该列(不占用空间)
* `stored` 生成列: 向表中写入新记录时，将计算该列并将其作为常规列存储在表中(占用空间)

```sql
create table employees (
    id int not null primary key,
    first_name VARCHAR(8) not null,
    last_name VARCHAR(16) not null,
    hire_date date not null,
    full_name VARCHAR(24) as (CONCAT(first_name, last_name)),
    key name (first_name, last_name)
)

insert employees (id, first_name, last_name, hire_date)
values (1, 'Zzz', 'xb', NOW());

alter table employees add hire_date_year year as (YEAR(hire_date)) virtual;
```

[延申阅读](https://dev.mysql.com/doc/refman/8.0/en/create-table-generated-columns.html)

## 窗口函数

对于查询中的每一行，可以使用窗口函数，利用与该行相关的执行计算。使用`OVER`和`WINDOW` 子句完成.

* `CUME_DIST()` 累计分布值
* `DENSE_RANK()` 分区内当前行的等级(无间隔)
* `FIRST_VALUE()` 窗口帧中第一行的参数值
* `LAG()` 落后于分区内当前行的那一行的参数值
* `LAST_VALUE()` 窗口帧中最末行的参数值
* `LEAD()` 领先于分区内当前行的那一行的参数值 
* `MTH_VALUE()` 窗口帧中的第N行的参数值
* `NTILE()` 分区内当前行的桶的编号
* `PERCENT_RANK()` 百分比排名值 
* `RANK()` 分区中当前行的等级(有间隔)
* `ROW_NUMBER()` 分区内当前行的编号

[延申阅读](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html)
[窗口函数行号方法ROW_NUMBER](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_row-number)

## 事务

* 事务特性(ACID)
  * 原子性(Atomicity)
  * 一致性(Consistency)
  * 隔离性(Isolation)
  * 持久性(Durability)


### 执行事务

```sql
-- BEGIN 或 START TRANSACTION 开启事务 
BEGIN

-- 要执行的 SQL 语句

-- COMMIT 提交事务, ROLLBACK 回滚事务
COMMIT
```

[延申阅读](https://dev.mysql.com/doc/refman/8.0/en/implicit-commit.html)

### 保存点

```sql
BEGIN

-- 需要执行的 SQL

SAVEPOINT flag_name; # 这里是保存点

-- 需要执行的 SQL

ROLLBACK TO flag_name; # 这里是回滚点
```

### 隔离级别 

* **读提交(read uncommitted)** 当前事务读取另一个事务提交的数据(**不可重复读 non-repeatable read**)
* **读未提交(read committed)** 当前事务读取另一个事务未提交的写入数据(**脏读 dirty read**)
* **可重复读取(repeatable read)** 一个事务通过第一条语句只能看到相同的数据，即使另一个事务已提交数据。在同一个事务中，读取通过第一次建立快照的数据是一致的。
* **序列化(serializable)** 通过把选定的所有行锁起来，序列化可以提供最高级别隔离。

### 锁

* **内部锁**(自身服务器内部执行的内部锁, 以管理多个会话对表内容的争用)
  * **行级锁** *只有访问行会被锁定* 适用于多用户、高并发和OLTP程序， 只用**InnoDB**支持行级锁
  * **表级锁** *一次只允许一个会话更新这些表*(MySQL 对 **MyISAM, MEMORY, MERGE**使用表级锁)适用以只读或读取操作为主的单用户程序
* **外部锁**(为客户会话提供选项来显式地获取表锁, 以阻止其他会话访问表)
  * **READ(共享锁)** 多个会话可以从表中读取数据而不需要获取锁，如果想要有写入操作，除非释放锁
  * **WRITE(排他锁)** 除持有该锁的会话之外，任何其他会话都不能读取或写入数据，除非释放锁

* 示例

```sql
-- 加锁
LOCK TABLE table_name [READ | WRITE]
-- 释放锁
UNLOCK TABLE;

-- 冻结对数据库所有的写入操作 
FLUSH TABLES WITH READ LOCK;
```

* 锁队列

除共享锁(一个表可以有多个共享锁)之外，没有两个锁可以一起加在一个表上。如果一个表已经有一个共享锁，此时有一个排他锁进来，
那么它将被保留在队列中，知道共享锁释放。

* `SHOW PROCESSLIST` 查看执行列表

[元数据锁](https://dev.mysql.com/doc/refman/8.0/en/metadata-locking.html)