---
layout: post
title:  "Spring Boot 的启动方式"
date:   2020-05-07 19:50:33 +0800
categories: Spring
tag: Spring, SpringBoot
---

* content
{:toc}

## 方式一(@SpringBootApplication)

`@SpringBootApplication`

```java
package com.example.springbootstartingmode;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringBootStartingModeApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootStartingModeApplication.class, args);
    }

}
```

## 方式二(@EnableAutoConfiguration)

* 开启自动配置文件 `@EnableAutoConfiguration`
* 扫描包，默认是自己`@ComponentScan("xyz.zzzxb.controller")`

```java
package com.example.springbootstartingmode;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;

@EnableAutoConfiguration
@ComponentScan
public class SpringBootStartingModeApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootStartingModeApplication.class, args);
    }

}

```

## Spring boot 加载 xml 配置文件

`@ImportResource(locations = {"application.xml"})`

