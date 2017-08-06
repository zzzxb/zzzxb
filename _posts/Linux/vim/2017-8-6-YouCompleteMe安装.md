---
layout: post
title:  "vim YouCompleteMe自动补全的安装配置与使用"
date:   2017-8-6 11:31:00 +0800
categories: Linux
tag: Linux
---

* content
{:toc}


### 1 下载 ###

`git clone --recursive git://github.com/Valloric/YouCompleteMe`

如果执行该命令没报错, 就ok了. 但是中途有可能会断掉, 可以 cd 到 YouCompleteMe, 然后反复用如下命令再次进行下载:

`git submodule update --init --recursive` 

我是网络不好弄了好久才下载完.

### 2 安装 ###

`cd ~/.vim/bundle/YouCompleteMe`到这个目录下  
`./install.py --clang-completer`安装  
到达100%的时候就安装成功了  
[ 95%] Building CXX object ycm/CMakeFiles/ycm_core.dir/Candidate.cpp.o  
[ 96%] Building CXX object ycm/CMakeFiles/ycm_core.dir/IdentifierUtils.cpp.o  
[ 97%] Building CXX object ycm/CMakeFiles/ycm_core.dir/ycm_core.cpp.o  
[ 97%] Building CXX object ycm/CMakeFiles/ycm_core.dir/IdentifierCompleter.cpp.o  
[ 98%] Building CXX object ycm/CMakeFiles/ycm_core.dir/LetterNodeListMap.cpp.o  
[100%] Building CXX object ycm/CMakeFiles/ycm_core.dir/CustomAssert.cpp.o  
[100%] Linking CXX shared library /home/wuyt/mutils/debian_lenny_cfg/vim_cfg/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so  
[100%] Built target ycm_core  

### 3 配置 ###

.vimrc中加入:

" YouCompleteMe  
`set runtimepath+=~/.vim/bundle/YouCompleteMe`
`let g:ycm_collect_identifiers_from_tags_files = 1`           " 开启 YCM 基于标签引擎  
`let g:ycm_collect_identifiers_from_comments_and_strings = 1` " 注释与字符串中的内容也用于补全  
`let g:syntastic_ignore_files=[".*\.py$"]`  
`let g:ycm_seed_identifiers_with_syntax = 1`                  " 语法关键字补全  
`let g:ycm_complete_in_comments = 1`  
`let g:ycm_confirm_extra_conf = 0`  
`let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']`  " 映射按键, 没有这个会拦截掉tab, 导致其他插件的tab不能用.  
`let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']`  
`let g:ycm_complete_in_comments = 1 `                         " 在注释输入中也能补全  
`let g:ycm_complete_in_strings = 1`                           " 在字符串输入中也能补全  
`let g:ycm_collect_identifiers_from_comments_and_strings = 1` " 注释和字符串中的文字也会被收入补全  
`let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'`
`let g:ycm_show_diagnostics_ui = 0`                           " 禁用语法检查  
`inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" |`            " 回车即选中当前项  
`nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>|`     " 跳转到定义处  
`"let g:ycm_min_num_of_chars_for_completion=2`                 " 从第2个键入字符就开始罗列匹配项  

其中 ~/.vim/bundle/YouCompleteMe 为下载 YouCompleteMeu 的路径.  
