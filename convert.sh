#!/bin/bash

# 批量转换markdown文件为Jekyll博客格式
# 用法: ./convert.sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 使用printf代替echo -e
print_color() {
    printf "${2}${1}${NC}\n"
}

# 基础目录
BASE_DIR="_posts"

# 检查_posts目录是否存在
if [ ! -d "$BASE_DIR" ]; then
    print_color "错误: 目录 $BASE_DIR 不存在" "$RED"
    exit 1
fi

# 获取当前日期
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S +0800")
TODAY_DATE=$(date +"%Y-%m-%d")

# 创建临时文件来存储需要删除的文件列表
TEMP_FILE=$(mktemp)

print_color "开始递归检索 $BASE_DIR 目录下的所有.md文件" "$GREEN"
echo "------------------------"

# 计数器
CONVERTED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0

# 使用for循环结合find，避免子shell问题
OIFS="$IFS"
IFS=$'\n'
for INPUT_FILE in $(find "$BASE_DIR" -type f -name "*.md" | sort); do
    # 获取文件名（不含路径）
    FILENAME=$(basename "$INPUT_FILE")
    FILE_PATH=$(dirname "$INPUT_FILE")
    
    # 检查文件名是否以日期开头（任何格式的日期）
    # 匹配模式：数字开头，后面跟着-和数字，再后面跟着-和数字
    # 例如: 2017-8-2-xxx.md, 2026-02-27-xxx.md, 2017-11-4-xxx.md 等
    if [[ $FILENAME =~ ^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}-.*\.md$ ]]; then
        print_color "跳过: $INPUT_FILE (以日期开头)" "$YELLOW"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi
    
    print_color "处理: $INPUT_FILE" "$YELLOW"
    
    # 提取标题（从文件中查找第一个#开头的行）
    TITLE=$(grep -m 1 "^# " "$INPUT_FILE" | sed 's/^# //' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # 如果没有找到标题，使用文件名作为标题
    if [ -z "$TITLE" ]; then
        TITLE=$(basename "$INPUT_FILE" .md)
        print_color "  警告: 未找到标题，使用文件名作为标题: $TITLE" "$YELLOW"
    fi
    
    # 生成文件名：将标题中的空格去掉，并将中文/特殊字符处理为URL友好的格式
    FILENAME_TITLE=$(echo "$TITLE" | sed 's/[[:space:]]//g' | sed 's/[\/:*?"<>|]/-/g')
    OUTPUT_FILENAME="${TODAY_DATE}-${FILENAME_TITLE}.md"
    OUTPUT_FILE="$FILE_PATH/$OUTPUT_FILENAME"
    
    # 检查输出文件是否已存在
    if [ -f "$OUTPUT_FILE" ]; then
        print_color "  警告: 输出文件已存在: $OUTPUT_FILENAME" "$YELLOW"
        printf "  是否覆盖? (y/n): "
        read -r REPLY
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "  跳过文件"
            SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
            continue
        fi
    fi
    
    # 提取标签（从文件路径或内容中推断）
    TAG="其他"
    # 从文件路径中提取年份作为标签
    if [[ "$FILE_PATH" =~ ([0-9]{4})$ ]]; then
        TAG="${BASH_REMATCH[1]}"
    fi
    
    # 创建Jekyll头部
    cat > "$OUTPUT_FILE" << EOF
---
layout: post
title: "$TITLE"
date: $CURRENT_DATE
tag: $TAG
---

* content
{:toc}

EOF
    
    # 复制原文件内容（跳过第一行标题）
    # 检查文件是否有标题行
    FIRST_LINE=$(head -n 1 "$INPUT_FILE")
    if [[ $FIRST_LINE =~ ^# ]]; then
        # 如果有标题行，跳过它
        tail -n +2 "$INPUT_FILE" >> "$OUTPUT_FILE"
    else
        # 如果没有标题行，复制全部内容
        cat "$INPUT_FILE" >> "$OUTPUT_FILE"
    fi
    
    # 检查转换是否成功
    if [ $? -eq 0 ]; then
        print_color "  转换成功: $OUTPUT_FILENAME" "$GREEN"
        CONVERTED_COUNT=$((CONVERTED_COUNT + 1))
        # 记录成功转换的原文件
        echo "$INPUT_FILE" >> "$TEMP_FILE"
    else
        print_color "  转换失败: $FILENAME" "$RED"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        rm -f "$OUTPUT_FILE"
    fi
    
    echo "------------------------"
done
IFS="$OIFS"

# 输出统计信息
echo
print_color "转换完成!" "$GREEN"
print_color "成功: $CONVERTED_COUNT 个文件" "$GREEN"
print_color "跳过: $SKIPPED_COUNT 个文件" "$YELLOW"
print_color "失败: $FAILED_COUNT 个文件" "$RED"

# 列出所有跳过的文件类型
echo
print_color "跳过的文件类型:" "$YELLOW"
print_color "- 以日期开头的文件（如: 2017-8-2-xxx.md, 2026-02-27-xxx.md）" "$YELLOW"
print_color "转换的文件类型:" "$GREEN"
print_color "- 非日期开头的文件（如: 清晰的Git提交.md, 无头浏览器截图.md）" "$GREEN"

# 如果有转换成功的文件，询问是否删除原文件
if [ $CONVERTED_COUNT -gt 0 ] && [ -s "$TEMP_FILE" ]; then
    echo
    printf "是否删除原文件? (y/n): "
    read -r REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_color "正在删除原文件..." "$YELLOW"
        while IFS= read -r file; do
            rm -f "$file"
            if [ $? -eq 0 ]; then
                echo "  已删除: $file"
            else
                print_color "  删除失败: $file" "$RED"
            fi
        done < "$TEMP_FILE"
        print_color "原文件删除完成" "$GREEN"
    else
        echo "跳过删除原文件"
    fi
fi

# 清理临时文件
rm -f "$TEMP_FILE"