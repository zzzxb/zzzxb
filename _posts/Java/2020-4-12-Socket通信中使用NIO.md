---
layout: post
title:  "Socket通信中使用NIO"
date:   2020-3-25 17:33:00 +0800
categories: Java
tag: Java
---

* content
{:toc}


NIO, 同步非阻塞IO，适合高负载、高并发下使用

```java
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.Set;

/**
 * @author Zzzxb
 * @date 2020/4/11 21:26
 */
public class NIOServer {

    private static int port = 10000;

    public static void main(String[] args) throws IOException {
        // 负责轮询是否有新连接，服务端监测到新连接之后，不再创建一个新的线程
        // 而是直接将新连接绑定到 ClientSelector 上, 这样就不用IO模型中的 while(true) 死等了
        Selector serverSelector = Selector.open();

        // clientSelector 负责轮询连接是否有数据可读
        Selector clientSelector  = Selector.open();

        // 扶着监听是否有客户端连接
        new Thread(() -> {
            try {
                // 对应IO中的服务端启动
                ServerSocketChannel listenerChannel = ServerSocketChannel.open();
                listenerChannel.socket().bind(new InetSocketAddress(port));
                listenerChannel.configureBlocking(false);
                listenerChannel.register(serverSelector, SelectionKey.OP_ACCEPT);

                while (true) {
                    // 监测是否有新连接，这里的1指的是阻塞时间为 1ms
                    if (serverSelector.select(1) > 0) {
                        Set<SelectionKey> set = serverSelector.selectedKeys();
                        Iterator<SelectionKey> keyIterator = set.iterator();

                        while (keyIterator.hasNext()) {
                            SelectionKey key = keyIterator.next();

                            if (key.isAcceptable()) {
                                try {
                                    SocketChannel clientChannel =
                                            ((ServerSocketChannel) key.channel()).accept();
                                    clientChannel.configureBlocking(false);
                                    clientChannel.register(clientSelector, SelectionKey.OP_READ);
                                } finally {
                                    keyIterator.remove();
                                }
                            }
                        }
                    }
                }
            } catch(Exception e) {

            }
        }).start();

        // 负责监听客户端是否发送信息
        new Thread(() -> {
            try {
                while(true) {
                    if (clientSelector.select(1) > 0) {
                        Set<SelectionKey> set = clientSelector.selectedKeys();
                        Iterator<SelectionKey> keyIterator = set.iterator();

                        while (keyIterator.hasNext()) {
                            SelectionKey key = keyIterator.next();

                            if (key.isReadable()) {
                                try {
                                    SocketChannel clientChannel = (SocketChannel) key.channel();
                                    ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                                    clientChannel.read(byteBuffer);
                                    byteBuffer.flip();
                                    System.out.println(
                                            Charset.defaultCharset()
                                                    .newDecoder().decode(byteBuffer).toString()
                                    );
                                } finally {
                                    keyIterator.remove();
                                    key.interestOps(SelectionKey.OP_READ);
                                }
                            }
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

> (出处)https://snailclimb.gitee.io/javaguide/#/docs/java/BIO-NIO-AIO