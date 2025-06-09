---
layout: post
title: "实用的 Linux 命令"
date: 2025-06-09 10:38:00 +0800
tag: Linux
---

* content
{:toc}

## 1. 快速创建多个相同类型的文件

`touch fileName_{1..3}.txt`

## 2. 快速生成一个大文件

`dd if=/dev/zero of=~/Downloads/fileName.txt bs=1M count=512`

## 3. 清空文件

* `: > fileName.txt`
* `true > fileName.txt` or `false > fileName.txt`
* `echo -n "" > fileName.txt`
* `cat /dev/null > fileName.txt`
* `truncate -s 0 fileNmae.txt`

## 4. find 查找

* 查找当前目录下某个名字文件
`find . -name  fileName.txt`
* 查找当前目录下文件
`find . -type f -name  fileName.*`
* 查找当前目录下目录
`find . -type d -name  name.*`
* 查找当前目录下指定权限文件
`find . -perm 755`
* 查找当前目录下不具备指定权限文件
`find . ! -perm 755`
* 查找当前目录下指定权限文件并修改权限
`find . -perm 777 -exec chomd 755 {} \;`
* 查找当前目录下某文件并删除
  * `find . -name fileName.txt -exec rm -rf {} \;`
  * `find . -name fileName.txt | xargs rm -rf {};`
  * `rm -rf $(find . -name fileName.txt)`
* 查找当前目录下指定大小文件(100M ~ 1G)
`find . -type f -size +100M -size -1G`
* 查找当前目录大于512M的文件并移动到指定目录
`find . -type f -size +512M -exec mv {} ./newDir`
* 查找当前目录下30天前修改过文件
`find . -mtime 30`
* 查找当前目录下30天前访问过的文件
`find . -atime 30`
* 查找当前目录下过去1小时修改过的文件
`find . -mmin -60`
* 查找当前目录下过去1小时访问过的文件
`find . -amin -60`
* 查找当前目录修改超过10天, 但修改不到30天的所有文件
`find . -mtime +10 -mtime -30`
* 查找当前目录下7天前修改过的文件并删除
`find . -mtime +7 -name fileName.* | xargs rm -rf {}`

## 5. 查看有几个逻辑CPU, 包括CPU型号

`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`

> -f 数据下标
> -d 分隔符
> echo "a.b.c.d" | cut -f3 -d. 输出: c

## 6. 查看有几颗CPU， 每颗分别是几核

`cat /proc/cpuinfo | gerep physical | uniq -c`

## 7. 后台运行

* 正常后台运行 `nohup ping www.baidu.com &`
* 日志不输出 `nohup ping www.baidu.com > dev/null &`
* 错误信息输出 `nohup ping www.baidu.com > run.log > 2>&1 &`

## 8. 按目录大小排序

* `du -xB M --max-depth=2 /var | sort -rn`
* `du -s * | sort -rnk 4`

> sort -r(从大到小) -n(按数值从大到小) -k(以第几列做为排序依据) -t (指定分隔符)
>
> du -x(排除挂载点干扰) -h(自动转合适单位K/M/G) -B(强制指定单位K/M/G) --max-depth(目录层级)

## 9. 查找80端口请求数最高的前10个ip

`netstat -anlp | grep 80 | grep tcp | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head`

> netstat -a (显示所有连接和监听端口) -n(以数字形式显示地址和端口) -l(仅显示监听端口) -p(显示进程信息)

## 10. sed

* 替换1为a(/有冲突可用:替代) 根据正则替换即可
  * `echo "123" | sed -i "s/1/a/g"`
  * `echo "123" | sed -i "s:1:a:g"`

[> 阅读原文](https://mp.weixin.qq.com/s/aFScGfEYbtV2AuhnV1zyuA)