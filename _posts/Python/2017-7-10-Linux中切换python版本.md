---
layout: post
title:  "Linux中切换python版本!"
date:   2017-7-10 15:00:00 +0800
categories: python
tag: python
---

* content
{:toc}




shell里执行：

sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100<br>
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150<br>

此时你会发现 alternatives

如果要切换到Python2，执行：

sudo update-alternatives --config python

按照提示输入选择数字回车即可。

这样你甚至可以将自己喜欢的任意版本Python安装到任意位置，然后使用update-alternatives将其设置为系统默认python。
python --version 查看python版本

