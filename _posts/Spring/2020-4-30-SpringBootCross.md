---
layout: post
title:  "Spring Boot - Cross(跨域问题)"
date:   2020-04-30 19:32:33 +0800
categories: Spring
tag: Spring, SpringBoot, Cross
---

* content
{:toc}

今天跟朋友演示前后端分离项目怎么写的时候，本来是一个挺简单的演示，结果我给全忘了。就连 Jquery 里的 ajax 都忘了怎么用了，一脸大写的尴尬。

跨域问题出现在前后端分离的项目中，前端通过前端服务器来启动，后端通过后端服务器来启动, 也就是他们的ip地址，或者端口其中一个或两个都不同，为了我们接口的安全，是不允许这样调用接口的，所以就出来了一个跨域问题，他能指定哪个接口对外开放，对哪个服务地址进行开放，对哪种接口类型进行开放,这样可以让接口相对安全一点。再安全一点的可以加 tocken 认证,之类的。

## 示例

* 对整个类的接口都进行跨域访问，访问地址只能`localhost:5500`访问

```java
@RestController
@CrossOrigin(origins = "http://localhost:5500")
@RequestMapping("/example")
public class CrossController {

    @RequestMapping("/show/{name}")
    public String show(@PathVariable String name) {
        return "Hello " + name;
    }
}
```

* 指定哪个接口可以跨域，哪个接口不能跨域

```java
@RestController
@RequestMapping("/example")
public class CrossController {

    @CrossOrigin(origins = "http://localhost:5500")
    @RequestMapping("/show/{name}")
    public String show(@PathVariable String name) {
        return "Hello " + name;
    }
}
```

* 第二种方式(全局方式)

```java
package org.example.crossdomain.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CrossConfig {

    @Bean
    public WebMvcConfigurer webMvcConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            // 具体可以看api里边说明，都进行了一一介绍
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**") // 开放的映射地址
                    .allowedHeaders("*") // 开放请求头，数据请求类型的
                    .allowedMethods("*") // 开放接口类型 GET, POSS 等
                    .allowedOrigins("*") // 指定哪些地址可以进行访问接口
                    .allowCredentials(true) //浏览器是否应该同时发送凭据，如cookie
                    .maxAge(3600); // 可以被客户端缓存时间
            }
        };
    }
}
```

[spirng api 5.2.6](https://docs.spring.io/spring/docs/5.2.6.RELEASE/javadoc-api/)

* 前端调用

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.0/jquery.js"></script>
<body align="center">
    <button onclick="show()">Show</button>
</body>
<script>
    function show() {
        $.ajax({
            type: 'GET',
            url: "http://localhost:10000/example/show/zwj",
            success: function(data) {
                console.info(data);
            }
        });
    }
</script>
</html>
```

* ok 这样跨域的问题就解决了