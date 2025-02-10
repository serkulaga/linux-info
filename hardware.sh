#!/bin/bash

# Detect CPU model and core count
CPU_MODEL=$(lscpu | grep "Model name" | sed -E 's/Model name:\s+//')
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# Detect OS display name
OS_NAME=$(cat /etc/os-release | grep "^PRETTY_NAME=" | cut -d'=' -f2 | tr -d '"')

# Detect total RAM size
RAM_SIZE=$(free -h | awk '/^Mem:/{print $2}')

# Detect storage devices with type detection
DISK_INFO=$(lsblk -d -o NAME,TYPE,SIZE,MODEL | awk '$2=="disk" {print $4, $3, disk_type}')

STORAGE_INFO=$(df -h --total | awk '/^total/ {print "Used: "$3 ", Free: "$4 ", Usage: "$5}')

# Detect GPU model
GPU_INFO=$(lspci | grep -i 'vga\|3d' | awk -F ': ' '{print $2}')

# Print results
echo "OS: $OS_NAME"
echo "CPU: $CPU_MODEL, $CPU_CORES core(s)"
echo "RAM: $RAM_SIZE"
echo "Disk: $DISK_INFO"
echo "Stotage: $STORAGE_INFO"
echo "GPU: $GPU_INFO"
