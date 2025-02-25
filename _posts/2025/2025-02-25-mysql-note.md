---
layout: post
title: "MySQL 笔记"
date: 2025-02-25 20:41:00 +0800
tag: MySQL
---

* content
{:toc}

## JSON

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