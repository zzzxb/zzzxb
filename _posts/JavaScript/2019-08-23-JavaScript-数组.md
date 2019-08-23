---
layout: post
title:  "JavaScript-数组"
date:   2019-08-23 22:47:3 +0800
categories: JavaScript
tag: JavaScript
---

* content
{:toc}

## 一维数组

```js
var arr = new Array();
```

## 二维数组

```js
var arr = new createArray(2);

function main() {
    arr[0][0] = 1;
    arr[0][1] = 2;
    console.log(arr[0][0]);
    console.log(arr[0][1]);
}

function createArray(size){
    var array = new  Array();
    for (i=0; i<length; i++) {
        array[i] = new Array();
    }
    return array;
}
```
