---
layout: post
title:  "Stream API"
date:   2019-08-17 16:51:9 +0800
categories: Java
tag: Java
---

* content
{:toc}

一个Stream表面上与一个集合很类似，集合中保存的是数据，而流中对数据的操作。

**特点：**

* Stream 自己不会存储元素.
* Stream 不会改变源对象。相反，他们会返回一个持有结果的新Stream。
* Stream 操作是延迟执行的。这意味着他们会等到需要结果的时候才执行。

Stream遵循“做什么，而不是怎么去做”的原则。只需要描述需要做什么，而不用考虑程序是怎样实现的

## 如何使用Stream API

**使用Stream，会有三个阶段(步骤)：**

1. 创建一个Stream。   （创建）
2. 在一个或多个步骤中，将初始Stream转化到另一个Stream的**中间操作**。 （中间操作）
3. 使用一个**终止操作**来产生一个结果。该操作会强制他之前的延迟操作立即执行。在这之后，该Stream就不会在被使用了。（终止操作）

### Stream的创建方法

```java
// 1. Stream.of方法
Stream stream = Stream.of("a", "b", "c");
// 2. Arrays.of方法
String [] strArray = new String[] {"a", "b", "c"};
stream = Stream.of(strArray);
stream = Arrays.stream(strArray);
// 3. 集合方法
List<String> list = Arrays.asList(strArray);
stream = list.stream();
stream = list.parallelStream();//并行流

//4.创建无限流
//迭代
Stream<Integer> stream = Stream.iterate(0, (x)->x+2);
stream.limit(10)
  .forEach(System.out::println);
//生成
Stream<Double> stream2 = Stream.generate(()->Math.random());
stream2.limit(5)
  .forEach(System.out::println);
```

### Stream中间操作

中间操作包括：map (mapToInt, flatMap 等)、 filter、distinct、sorted、peek、limit、skip、parallel、sequential、unordered。

多个中间操作可以连接起来形成一个流水线，除非流水 线上触发终止操作，否则中间操作不会执行任何的处理！ 而在终止操作时一次性全部处理，称为“惰性求值”。

#### 筛选和切片

```java
public static void main(String[] args) {
        List<Employee> employees=new ArrayList<>();
        employees.add(new Employee("xxx", 30, 10000));
        employees.add(new Employee("yyy", 29, 8000));
        employees.add(new Employee("zzz", 22, 12000));
        employees.add(new Employee("张三", 21, 20000));
        employees.add(new Employee("李四", 32, 22000));
        //employees.add(new Employee("李四", 32, 22000));
        //1 筛选和切片
        // filter---从流中排除元素
        // limit——截断流，使其元素不超过给定数量。
        // skip(n) —— 跳过元素，返回一个扔掉了前 n 个元素的流。若流中元素不足 n 个，则返回一个空流。与 limit(n) 互补
        // distinct——筛选，通过流所生成元素的 equals() 去除重复元素
        System.out.println("-----------filter------------");
        Stream<Employee> stream = employees.stream().filter((e)->e.getAge()>=25);
        stream.forEach(System.out::println);

        System.out.println("---------limit-------");
        Stream<Employee> stream2 = employees.stream().limit(3);
        stream2.forEach(System.out::println);

        System.out.println("---------skip-------");
        Stream<Employee> stream3= employees.stream().skip(2);
        stream3.forEach(System.out::println);

        System.out.println("---------distinct-------");//通过equals方法去重复
        Stream<Employee> stream4= employees.stream().distinct();
        stream4.forEach(System.out::println);
    }
```

#### 映射

```java
public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee("xxx", 30, 10000));
        employees.add(new Employee("yyy", 29, 8000));
        employees.add(new Employee("zzz", 22, 12000));
        employees.add(new Employee("张三", 21, 20000));
        employees.add(new Employee("李四", 32, 22000));
        // map——接收 Lambda ，
        // 将元素转换成其他形式或提取信息。接收一个函数作为参数，该函数会被应用到每个元素上，并将其映射成一个新的元素。
        System.out.println("----------获取员工姓名-----------");
        Stream<String> str = employees.stream().map((e) -> e.getName());
        str.forEach(System.out::println);
        System.out.println("-------------------转成大写------------------------");
        List<String> strList = Arrays.asList("aaa", "bbb", "ccc", "ddd", "eee");
        Stream<String> stream = strList.stream().map(String::toUpperCase);

        stream.forEach(System.out::println);
    }
```

#### 排序

```java
public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee("xxx", 30, 10000));
        employees.add(new Employee("yyy", 29, 8000));
        employees.add(new Employee("zzz", 22, 12000));
        employees.add(new Employee("张三", 21, 20000));
        employees.add(new Employee("李四", 32, 22000));
        /*
            sorted()——自然排序
            sorted(Comparator com)——定制排序
         */
        System.out.println("-----------------自然排序-------------------");
        employees.stream().map(Employee::getName).sorted().forEach(System.out::println);
        System.out.println("-----------------定制排序-------------------");
        employees.stream().sorted((x, y) -> {
            if (x.getAge() == y.getAge()) {
                return x.getName().compareTo(y.getName());
            } else {
                return Integer.compare(x.getAge(), y.getAge());
            }
        }).forEach(System.out::println);
    }
```

### Stream 的终止操作

**终止操作包括：** forEach、forEachOrdered、toArray、reduce、collect、min、max、count、anyMatch、allMatch、noneMatch、findFirst、findAny、iterator。

#### 查找和匹配

* allMatch——检查是否匹配所有元素
* anyMatch——检查是否至少匹配一个元素
* noneMatch——检查是否没有匹配的元素
* findFirst——返回第一个元素
* findAny——返回当前流中的任意元素
* count——返回流中元素的总个数
* max——返回流中最大值
* min——返回流中最小值

```java
public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee("xxx", 30,"男",10000));
        employees.add(new Employee("yyy", 29,"男",8000));
        employees.add(new Employee("zzz", 22, "男",12000));
        employees.add(new Employee("张三", 21,"男",20000));
        employees.add(new Employee("李四", 32,"男",22000));
        //-----------foreach--------------
        employees.stream().forEach(System.out::println);
        /**
         *  allMatch——检查是否匹配所有元素
            anyMatch——检查是否至少匹配一个元素
            noneMatch——检查是否没有匹配的元素
            findFirst——返回第一个元素
            findAny——返回当前流中的任意元素
            count——返回流中元素的总个数
            max——返回流中最大值
            min——返回流中最小值
         */
        boolean b = employees.stream().allMatch((e)->e.getSex().equals("男"));
        boolean b2 = employees.stream().anyMatch((e)->e.getSex().equals("女"));
        boolean b3=employees.stream().noneMatch((e)->e.getSex().equals("女"));
        System.out.println(b);
        System.out.println(b2);
        System.out.println(b3);
        Optional<Employee> findFirst = employees.stream().findFirst();
        System.out.println(findFirst.get());
        Optional<Employee> findAny = employees.parallelStream().findAny();
        System.out.println(findAny.get());
        Optional<Employee> max = employees.stream().max((o1,o2)->o1.getAge()-o2.getAge());
        System.out.println(max.get());
        Optional<Double> min = employees.stream().map(Employee::getSalary).min(Double::compareTo);
        System.out.println(min.get());
    }
```

#### 规约和收集

```java
public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee("xxx", 30, "男", 10000));
        employees.add(new Employee("yyy", 29, "男", 8000));
        employees.add(new Employee("zzz", 22, "男", 12000));
        employees.add(new Employee("张三", 21, "男", 20000));
        employees.add(new Employee("李四", 32, "男", 22000));
        // -----------foreach--------------
        employees.stream().forEach(System.out::println);
        /**
         * reduce归约 reduce(T identity, BinaryOperator) / reduce(BinaryOperator)
         * ——可以将流中元素反复结合起来，得到一个值
         */
        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        Integer sum = list.stream().reduce(0, (x, y) -> x + y);

        System.out.println(sum);

        System.out.println("----------------------------------------");

        Optional<Double> op = employees.stream().map(Employee::getSalary).reduce(Double::sum);

        System.out.println(op.get());

        /**
         * collect——将流转换为其他形式。接收一个 Collector接口的实现，用于给Stream中元素做汇总的方法
         */
        System.out.println("-------------List集合---------------------");

        List<String> list2 = employees.stream().map(Employee::getName).collect(Collectors.toList());

        list2.forEach(System.out::println);

        System.out.println("---------------Set集合-------------------");

        Set<String> set = employees.stream().map(Employee::getName).collect(Collectors.toSet());

        set.forEach(System.out::println);
    }
```

#### 并行操作

Stream有串行和并行两种，串行Stream上的操作是在一个线程中依次完成，而并行Stream则是在多个线程上同时执行。

```java
int max = 1000000;
List<String> values = new ArrayList<>(max);
for (int i = 0; i < max; i++) {
    UUID uuid = UUID.randomUUID();
    values.add(uuid.toString());
}
```

**计算一下排序这个Stream要耗时多久:**

```java
public static void main(String[] args) {
        int max = 1000000;
        List<String> values = new ArrayList<>(max);
        for (int i = 0; i < max; i++) {
            UUID uuid = UUID.randomUUID();
            values.add(uuid.toString());
        }

        System.out.println("----------串行------------");
        long t0 = System.currentTimeMillis();
        long count = values.stream().sorted().count();
        System.out.println(count);
        long t1 = System.currentTimeMillis();
        long millis = t1-t0;
        System.out.println(millis);
//        System.out.println("-------------并行----------------");
//        long t0 = System.currentTimeMillis();
//        long count = values.parallelStream().sorted().count();
//        System.out.println(count);
//        long t1 = System.currentTimeMillis();
//        long millis = t1-t0;
//        System.out.println(millis);
}
```
