---
layout: post
title:  "Spring Boot + ZK + Dubbo"
date:   2020-4-16 19:44:01 +0800
categories: Dubbo
tag: Dubbo
---

* content
{:toc}

今天早上本打算用 SpringBoot + ZK +Dubbo 写个小 Demo 呢，捣鼓了半天都没捣鼓明白哪里出的错，网上说的 zk 和 curator 版本的问题，换了好几版本都有问题，索性把zk换到最新的3.6.0版本，依赖也用新的，结果，莫问题了,正常运行,你说气人不气人，下次写东西的一定要养成一个习惯 - 加版本号。

[Apache Zookeeper 官网](https://zookeeper.apache.org/)  
[Zookeeper Download](https://zookeeper.apache.org/) 3.6.0目前最新的稳定版本
[Dubbo Admin 旧, 可视化监控界面](https://github.com/apache/dubbo-admin/tree/master)  
[Dubbo Admin 新](https://github.com/apache/dubbo-admin/tree/develop)

## 版本说明

* Zookeeper 3.6.0
* Spring Boot 2.2.6
* curator 4.2.0
* Dubbo 2.7.6

## Provider

* **pom.xml**

```xml
    <!-- spring boot parent starter -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.6.RELEASE</version>
    </parent>

    <dependencies>
        <!-- spring boot web starter-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>2.2.6.RELEASE</version>
        </dependency>
        <!-- dubbo starter -->
        <dependency>
            <groupId>org.apache.dubbo</groupId>
            <artifactId>dubbo-spring-boot-starter</artifactId>
            <version>2.7.6</version>
        </dependency>
        <!-- curator framework -->
        <dependency>
            <groupId>org.apache.curator</groupId>
            <artifactId>curator-framework</artifactId>
            <version>4.2.0</version>
        </dependency>
        <!-- curator-recipes -->
        <dependency>
            <groupId>org.apache.curator</groupId>
            <artifactId>curator-recipes</artifactId>
            <version>4.2.0</version>
        </dependency>
    </dependencies>
```

*  **application.yml**

```yml
server:
  port: 10000 # 服务端口

spring:
  application:
    name: dubbo_provider # 服务名称

dubbo:
  application:
    name: service_provider # dubbo 上注册的服务名称
  registry:
    address: zookeeper://172.20.10.3:2181 # 注册到 zookeeper 的地址
  protocol:
    name: dubbo # dubbo 协议
    port: 20880 # 开放端口
  scan:
    base-packages: xyz.zzzxb.provider.service # 提供的服务
```

* **ProviderApp.java** 

```java
package xyz.zzzxb.provider;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author Zzzxb
 * @date 2020/4/16 00:29
 */
@SpringBootApplication
@EnableDubbo
public class ProviderApp {

    public static void main(String[] args) {
        SpringApplication.run(ProviderApp.class, args);
    }
}
```

* **Service**

```java
package xyz.zzzxb.provider.service;

/**
 * @author Zzzxb
 * @date 2020/4/16 02:16
 */
public interface DemoService {

    String demo(String name);
}
```

* **ServiceImpl**

```
package xyz.zzzxb.provider.service.imp;

//  这里使用的Dubbo提供的Service注解,不是Spring提供的
import org.apache.dubbo.config.annotation.Service;
import xyz.zzzxb.provider.service.DemoService;

/**
 * @author Zzzxb
 * @date 2020/4/16 02:16
 */
@Service
public class DemoServiceImpl implements DemoService {

    @Override
    public String demo(String name) {
        return "Hello " + name;
    }
}
```

* 到此，就可以成功执行了.

## Consumer

* **application.yml**

```yml
server:
  port: 10001

spring:
  application:
    name: dubbo_consumer

dubbo:
  application:
    name: client_consumer
  registry:
    address: zookeeper://localhost:2181
```

* **ConsumerApp**

```java
package xyz.zzzxb.consumer;

import org.apache.dubbo.config.spring.context.annotation.EnableDubbo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author Zzzxb
 * @date 2020/4/16 20:26
 */
@SpringBootApplication
@EnableDubbo
public class ConsumerApp {

    public static void main(String[] args) {
        SpringApplication.run(ConsumerApp.class, args);
    }
}
```

* **service**

这个服务需要着重看一下, 在**consumer**项目下创建一个跟**provider**项目下相同的**service**服务接口

* 我的项目结构

SpringBoot_ZK_Dubbo  

—— Provider  
———— xyz.zzzxb.provider  
—————— service  
———————— DemoService.java
———————— impl  
—————————— DemoServiceImpl.java  
—————— ProviderApp.java  

—— Consumer  
———— xyz.zzzxb.consumer  
—————— controller  
—————— ConsumerApp.java  
———— xyz.zzzxb.provider  
—————— service  
———————— DemoService.java

这个service接口可以单独分出来，让provider 和 consumer 共同使用，也可以通过这种方式进行使用

```java
package xyz.zzzxb.provider.service;

/**
 * @author Zzzxb
 * @date 2020/4/16 02:16
 */
public interface DemoService {

    String demo(String name);
}
```

* **Controller**

```java
package xyz.zzzxb.consumer.controller;

import org.apache.dubbo.config.annotation.Reference;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import xyz.zzzxb.provider.service.DemoService;

/**
 * @author Zzzxb
 * @date 2020/4/16 20:29
 */
@RestController
public class DemoController {

    @Reference // 通过 Reference 进行远程调用
    private DemoService demoService;

    @RequestMapping("/demo/{name}")
    public String demo(@PathVariable String name) {
        return demoService.demo(name);
    }
}
```