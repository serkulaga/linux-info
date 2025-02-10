#!/bin/bash

check_command() {
    local cmd=$1
    if command -v $cmd &> /dev/null; then
        case "$cmd" in
            nginx | node | wp)
                local version=$($cmd -v 2>&1 | head -n 1)
                ;;
            redis-server)
                local version=$($cmd --version 2>&1 | grep -oP 'v=\K\S+')
                ;;
            kubectl)
                local version=$($cmd version --client --short 2>&1)
                ;;
            *)
                local version=$($cmd --version 2>&1 | head -n 1)
                ;;
        esac
        local path=$(command -v $cmd)
        echo -e "$cmd\t$version\t$path"
    fi
}
# List of commands to check
commands=(
    "mysql" "docker" "nginx" "apache2" "php" "python" "git" "node" "ruby"
    "java" "go" "rust" "kubectl" "terraform" "django" "pip" "redis-server"
    "wp" "postgres" "mongodb" "sqlite3" "haproxy" "memcached"
    "openvpn" "samba"
)

# Print table header
echo -e "Application\tVersion\tPath"

# Loop through commands and check each one
for cmd in "${commands[@]}"; do
    check_command $cmd
done
