---
layout: post
title:  "About Git!"
date:   2017-5-27 22:03:01 +0800
categories: jekyll
tag: jekyll
---

* content
{:toc}



关于Git我遇到的问题
-----------------------
[Git教程](http://www.yiibai.com/git/)

&nbsp;&nbsp;&nbsp;&nbsp;今晚在使用git push时出现的问题<br>
	
	warning: push.default is unset; its implicit value has changed in
	Git 2.0 from 'matching' to 'simple'. To squelch this message
	and maintain the traditional behavior, use:
  	git config --global push.default matching
	To squelch this message and adopt the new behavior now, use:
  	git config --global push.default simple
	When push.default is set to 'matching', git will push local branches
	to the remote branches that already exist with the same name.
	Since Git 2.0, Git defaults to the more conservative 'simple'
	behavior, which only pushes the current branch to the corresponding
	remote branch that 'git pull' uses to update the current branch.
	See 'git help config' and search for 'push.default' for further information.
	(the 'simple' mode was introduced in Git 1.7.11. Use the similar mode
	'current' instead of 'simple' if you sometimes use older versions of Git)

&nbsp;&nbsp;&nbsp;&nbsp;Git 从git 2.0版本以后开始使用matching(上边的信息就是来提示用户设置默认值的)
	
	#matching（匹配所有分支)
	matching 参数是 Git 1.x 的默认参数，也就是老的执行方式。其意是如果你执行 git push但没有指定分支，它将 push 所有你本地的分支到远程仓库中对应匹配的分支。
	<big>simple（匹配单个分支）</big>
	simple参数是 Git 2.x 默认参数，意思是执行 git push 没有指定分支时，只有当前分支会被 push 到远程仓库。
所以如果我们想使用matching方式，可以在命令行输入：
git config --global push.default matching
如果我们想使用simple方式，可以在命令行输入：
git config --global push.default simple



&nbsp;&nbsp;&nbsp;&nbsp;git push 失败总是无法上传

	根据出错所提示的内容来解决问题,我遇到的是GitHub上电子邮件私密的问题,由于设置为私密外部访问时会拒绝访问并报错提示，然后百度了一下答案都是零零散散的达非所问，没搜出来我就把错误信息翻译了一下，提示到邮件无法访问的问题，修改后OK了.
	有时候搜索答案并非解决一个问题的好方法，只有在不断的报错中去自行摸索才是学习的好方法，他会让你对这个错误进行那么点了解，所以在摸爬滚打中成长并非不是一个好办法。
	最后也提醒下大家也是提醒我自己，不会英语并不是无法成功，但他可以使你少费很多时间去查看问题。
对计算机专业的人来讲,英语仅次于编程语言的重要性。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![加油]({{ '/styles/images/cheer.jpg' | prepend: site.baseurl  }})

