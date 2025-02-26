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