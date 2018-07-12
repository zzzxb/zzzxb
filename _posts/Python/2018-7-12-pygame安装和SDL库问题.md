---
layout: post
title:  "pygame安装和SDL库问题"
date:   2018-7-12 13:33:01 +0800
categories: python
tag: python
---

* content
{:toc}

　今天在Ubuntu18.04上安装python3的pygame库遇到的问题。

用pip安装pygame时是路径不对还是怎么回事没法下载，我就去官网下了。

**http://www.pygame.org/download.shtml**pygame下载地址

下载后进行解压，解压后通过```sudo python3 setup.py```安装，然后就报错说我没有sdl-config

通过```sudo apt-get install libsdl1.2-dev```安装sdl, 巧了这个我也安装不上。(网上找的说是安装

sudo apt-get install x11proto-xext-dev　和　sudo apt-get install libxext-dev)不过我安装不上

然后我就又去官网下载**http://www.libsdl.org/download-1.2.php**

下载后解压到**/usr/SDL/**里面，没有就新建文件夹.

然后通过下面命令安装

```./configure```

```make```

```make install``

然而又很不幸，我又没安装成功，报错是：

```
./src/video/x11/SDL_x11sym.h:168:17: error: conflicting types for _XData32?
 SDL_X11_SYM(int,_XData32,(Display *dpy,register long *data,unsigned len),(dpy,data,len),return)
                 ^
./src/video/x11/SDL_x11dyn.c:95:5: note: in definition of macro 釹DL_X11_SYM?
  rc fn params { ret p##fn args ; }
     ^
In file included from ./src/video/x11/SDL_x11dyn.h:34:0,
                 from ./src/video/x11/SDL_x11dyn.c:26:
/usr/include/X11/Xlibint.h:568:12: note: previous declaration of 鈅XData32?was here
 extern int _XData32(
            ^
make: *** [build/SDL_x11dyn.lo] Error 1
```

**解决方法**经过一番查找后网上给出的答案是libx11-dev版本问题（查看版本如图），版本>1.5.99，所以需要修改**src/video/x11/SDL_x11sym.h **文件,按照提示修改168行

* 原来的是：(在差不多１６８行的位置)

```
SDL_X11_SYM(int,_XData32,(Display *dpy,register  long *data,unsigned len),(dpy,data,len),return)
```

* 修改后:在代码**register long**中间加上**_Xconst**, 如下:

```
SDL_X11_SYM(int,_XData32,(Display *dpy,register _Xconst long *data,unsigned len),(dpy,data,len),return)
```

 然后在执行**make**  和**sudo make install**哎呀，成功了！！！

* 之后再回到pygame的目录中通过```sudo python3 setup.py```安装　pygame,

  之后在命令行输入```python3``` 通过```import pygame```什么都没报的话就成功了。
