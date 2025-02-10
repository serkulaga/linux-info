#!/bin/bash

# Detect CPU model and core count
CPU_MODEL=$(lscpu | grep "Model name" | sed -E 's/Model name:\s+//')
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# Detect total RAM size
RAM_SIZE=$(free -h | awk '/^Mem:/{print $2}')

# Detect storage devices with type detection
STORAGE_INFO=$(lsblk -d -o NAME,TYPE,SIZE,MODEL | awk '$2=="disk" {print $4, $3, disk_type}')

# Detect GPU model and memory
GPU_INFO=$(lspci | grep -i 'vga\|3d' | awk -F ': ' '{print $2}')
GPU_MEM=$(glxinfo | grep "Video memory" | awk '{print $3 " MB"}')

# Print results
echo "CPU: $CPU_MODEL, $CPU_CORES core(s)"
echo "RAM: $RAM_SIZE"
echo "Storage: $STORAGE_INFO"
echo "GPU: $GPU_INFO, $GPU_MEM"
