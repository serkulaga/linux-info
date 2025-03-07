#!/bin/bash

# Print CSV header
printf "CONTAINER_NAME\tIMAGE\tPORTS\tCPU\tMEMORY_USED\tMEMORY_ALLOCATED\tMEMORY_PERCENTAGE\n"

# Loop through running containers
docker ps --format "{{.Names}},{{.Image}},{{.Ports}}" | while IFS=, read -r name image ports; do

    # Get stats from docker stats
    stats=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}}" "$name")

    # Parse the stats into individual variables
    cpu_usage=$(echo "$stats" | cut -d',' -f1 | sed 's/%//')
    memory_usage=$(echo "$stats" | cut -d',' -f2 | awk -F'/' '{print $1}')
    memory_allocated=$(echo "$stats" | cut -d',' -f2 | awk -F'/' '{print $2}')
    memory_percentage=$(echo "$stats" | cut -d',' -f3 | sed 's/%//')

    # Print the result in CSV format
    printf "$name\t$image\t$ports\t$cpu_usage\t$memory_usage\t$memory_allocated\t$memory_percentage\n"
done
