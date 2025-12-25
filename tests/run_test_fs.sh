#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "$SCRIPT_DIR/.."

TAR_FILE="test_blk.tar.gz"

if [ -f "$SCRIPT_DIR/$TAR_FILE" ]; then
    echo "在 tests 目录下找到 $TAR_FILE，正在解压..."
    tar -zxvf "$SCRIPT_DIR/$TAR_FILE" -C "$SCRIPT_DIR/.."
elif [ -f "$SCRIPT_DIR/../$TAR_FILE" ]; then
    echo "在根目录下找到 $TAR_FILE，正在解压..."
    cd "$SCRIPT_DIR/.."
    tar -zxvf "$TAR_FILE"
else
    echo "错误: 未找到 $TAR_FILE (检查了 tests/ 和 根目录)。"
    exit 1
fi

cd "$SCRIPT_DIR/.."

echo "正在运行测试..."
cargo xtask qemu --build-config tmp/configs/qemu-aarch64-fs.toml --qemu-config tmp/configs/qemu-aarch64-info-fs.toml --vmconfigs tmp/configs/arceos-blktest-aarch64-qemu-smp1-fs.toml 
