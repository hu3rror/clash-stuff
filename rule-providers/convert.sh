#!/bin/bash
set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 定义输入和输出文件夹
INPUT_DIRS=("$SCRIPT_DIR/direct" "$SCRIPT_DIR/domestic" "$SCRIPT_DIR/proxy")

# 遍历每个输入文件夹
for INPUT_DIR in "${INPUT_DIRS[@]}"; do
  # 检查输入文件夹是否存在
  if [ ! -d "$INPUT_DIR" ]; then
    echo "输入文件夹不存在: $INPUT_DIR"
    continue
  fi

  # 遍历所有 .txt 文件
  for txt_file in "$INPUT_DIR"/*.txt; do
    # 检查文件是否存在
    if [ ! -f "$txt_file" ]; then
      echo "没有找到 .txt 文件"
      continue
    fi

    # 获取文件名，不带扩展名
    base_name=$(basename "$txt_file" .txt)
    
    # 定义输出文件路径
    output_file="$INPUT_DIR/$base_name.mrs"
    
    # 根据文件名选择转换命令
    if [[ "$base_name" == *"_domainset"* ]]; then
      convert_command="convert-ruleset domain text"
    elif [[ "$base_name" == *"_ip"* && "$base_name" != *"non_ip"* ]]; then
      convert_command="convert-ruleset ipcidr text"
    else
      echo "跳过文件: $txt_file"
      continue
    fi
    
    # 调用 clash-meta 命令进行转换
    clash-meta $convert_command "$txt_file" "$output_file"
    
    # 检查转换是否成功
    if [ $? -eq 0 ]; then
      echo "成功转换: $txt_file -> $output_file"
    else
      echo "转换失败: $txt_file"
    fi
  done
done