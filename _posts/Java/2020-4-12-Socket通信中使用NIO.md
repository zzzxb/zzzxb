---
layout: post
title:  "Socket通信中使用NIO"
date:   2020-4-12 01:08:00 +0800
categories: Java
tag: Java
---

* content
{:toc}


NIO, 同步非阻塞IO，适合高负载、高并发下使用

* 三个特性
 * Buffer（缓冲区）
 * Channel（通道）
 * Selector（选择器）

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
        // 打开一个选择器
        Selector serverSelector = Selector.open();

        // 打开一个选择器
        Selector clientSelector  = Selector.open();

        // 负责监听是否有客户端连接
        new Thread(() -> {
            try {
                // 打开Socket 通道
                ServerSocketChannel listenerChannel = ServerSocketChannel.open();
                // 获取与此通道关联的套接字,将套接字绑定到本地地址并设置端口
                listenerChannel.socket().bind(new InetSocketAddress(port));
                // 调整此通道的阻塞模式 
                listenerChannel.configureBlocking(false);
                // 向给定的选择器注册此通道，返回一个选择键,用于套接字接受操作的操作集位
                listenerChannel.register(serverSelector, SelectionKey.OP_ACCEPT);

                while (true) {
                    // 监测是否有新连接，这里的1指的是阻塞时间为 1ms
                    // 选择一组键，其相应的通道已为 I/O 操作准备就绪。
                    if (serverSelector.select(1) > 0) {
                        // 返回此选择器的已选择键集
                        Set<SelectionKey> set = serverSelector.selectedKeys();
                        // 创建迭代器
                        Iterator<SelectionKey> keyIterator = set.iterator();
                        // 迭代获取 SelectionKey
                        while (keyIterator.hasNext()) {
                            SelectionKey key = keyIterator.next();

                            //测试此键的通道是否已准备好接受新的套接字连接。
                            if (key.isAcceptable()) {
                                try {
                                    // 获取并接受到此通道套接字的连接
                                    SocketChannel clientChannel =
                                            ((ServerSocketChannel) key.channel()).accept();
                                    clientChannel.configureBlocking(false);
                                    // 注册 clientChannel 到 clientSelector ,用于读取操作的操作集位
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
                        // 迭代 clientSelector
                        Set<SelectionKey> set = clientSelector.selectedKeys();
                        Iterator<SelectionKey> keyIterator = set.iterator();

                        while (keyIterator.hasNext()) {
                            SelectionKey key = keyIterator.next();
                            // 测试此键的通道是否已准备好进行读取。
                            if (key.isReadable()) {
                                try {
                                    // 获取可以进行读取的客户端通道
                                    SocketChannel clientChannel = (SocketChannel) key.channel();
                                    // 分配一个新的字节缓冲区
                                    ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                                    // 读取数据到缓冲区
                                    clientChannel.read(byteBuffer);
                                    // 反转此缓冲区
                                    byteBuffer.flip();
                                    // 打印消息
                                    System.out.println(
                                        // 返回此 Java 虚拟机的默认 charset
                                            Charset.defaultCharset()
                                            // 为此 charset 构造新的解码器,将此 charset 中的字节解码成 Unicode 字符的便捷方法
                                                    .newDecoder().decode(byteBuffer).toString()
                                    );
                                } finally {
                                    keyIterator.remove();
                                    // 将此键的 interest 集合设置为给定值。 
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
* 只有自己能临时看懂的流程图

[!大概流程图]({{'/styles/images/nio.jpg' | prepend: site.baseurl}})

[!Slector]({{'/styles/images/Slector.png' | prepend: site.baseurl}})

[引自JavaGuid](https://snailclimb.gitee.io/javaguide/#/docs/java/BIO-NIO-AIO)
