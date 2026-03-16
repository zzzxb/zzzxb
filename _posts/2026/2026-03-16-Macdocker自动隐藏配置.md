---
layout: post
title: "Mac docker 自动隐藏配置"
date: 2026-03-16 13:59:44 +0800
tag: 2026
---

* content
{:toc}


Mac Dock 自己使用习惯的响应时间配置

* **显示延迟**

```bash
# 查看
defaults read com.apple.dock autohide-delay

# 修改这里的 0 可以修改为自己想要的配置
defaults write com.apple.dock autohide-delay -float 0 && killall Dock

# 恢复默认值
defaults delete com.apple.dock autohide-delay &&killall Dock
```

* **动画速度**

```bash
# 查看
defaults read com.apple.dock autohide-time-modifier

# 修改这里的 0 可以修改为自己想要的配置
defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock

# 恢复默认值
defaults delete com.apple.dock autohide-time-modifier
```

