---
layout: post
title: "python升级后pip不可用"
date: 2024-09-04 11:31:31 +0800
categories: Python
tag: Python,Mac
---

* content
{:toc}

## 起因

`brew upgrade` 执行后后自动将的*pyhton11*升级为*python12*, 我将python_home更改为12后，把11删除了,
然后执行 `pip3 install requests` 就报下边所示错了

```txt
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try brew install
    xyz, where xyz is the package you are trying to
    install.

    If you wish to install a Python library that isn't in Homebrew,
    use a virtual environment:

    python3 -m venv path/to/venv
    source path/to/venv/bin/activate
    python3 -m pip install xyz

    If you wish to install a Python application that isn't in Homebrew,
    it may be easiest to use 'pipx install xyz', which will manage a
    virtual environment for you. You can install pipx with

    brew install pipx

    You may restore the old behavior of pip by passing
    the '--break-system-packages' flag to pip, or by adding
    'break-system-packages = true' to your pip.conf file. The latter
    will permanently disable this error.

    If you disable this error, we STRONGLY recommend that you additionally
    pass the '--user' flag to pip, or set 'user = true' in your pip.conf
    file. Failure to do this can result in a broken Homebrew installation.

    Read more about this behavior here: <https://peps.python.org/pep-0668/>

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

## 解决办法

`rm /usr/local/Cellar/python@3.12/3.12.5/Frameworks/Python.framework/Versions/3.12/lib/EXTERNALLY-MANAGED`

再进行安装的时候就没问题了,因为非自己想出的解决办法，也没有听说为什么要删除的具体原因
