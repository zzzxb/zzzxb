---
layout: post
title:  "LinkedList源码分析"
date:   2020-3-22 23:23:00 +0800
categories: Java
tag: Java
---

* content
{:toc}

* LinkedList，有序集合，采用双向链表存放数据，线程不安全，通过使用`List list = Collections.synchronizedList(new LinkedList(...)); `使线程变为安全的

## 直接实现的接口，继承的类

```java
public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable
```

## 属性

* 被`transient`关键字修饰的属性是都不会被序列化的

```java
    transient int size = 0;

    /**
     * Pointer to first node.
     * Invariant: (first == null && last == null) ||
     *            (first.prev == null && first.item != null)
     */
    transient Node<E> first; // 头节点

    /**
     * Pointer to last node.
     * Invariant: (first == null && last == null) ||
     *            (last.next == null && last.item != null)
     */
    transient Node<E> last; // 尾节点
```

## 构造函数

```java
  /**
     * Constructs an empty list.
     */
    public LinkedList() {
    }
```

```java
    /**
     * Constructs a list containing the elements of the specified
     * collection, in the order they are returned by the collection's
     * iterator.
     *
     * @param  c the collection whose elements are to be placed into this list
     * @throws NullPointerException if the specified collection is null
     */
    public LinkedList(Collection<? extends E> c) {
        this();
        addAll(c);
    }
```

## 头插和尾插法

```java
    /**
     * Links e as first element.
     */
    private void linkFirst(E e) {
        final Node<E> f = first;
        final Node<E> newNode = new Node<>(null, e, f);
        first = newNode;
        if (f == null)
            last = newNode;
        else
            f.prev = newNode;
        size++;
        modCount++;
    }
```

```java
   /**
     * Links e as last element.
     */
    void linkLast(E e) {
        final Node<E> l = last;
        final Node<E> newNode = new Node<>(l, e, null);
        last = newNode;
        if (l == null)
            first = newNode;
        else
            l.next = newNode;
        size++;
        modCount++;
    }
```

## Node 类

```java
    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }
```

## GIF 演示

![LinkedListDemo]({{ '/styles/images/LinkedListDemo.gif' | prepend: site.baseurl }})