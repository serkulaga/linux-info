#!/bin/bash

# Print CSV header
echo "CONTAINER_NAME,IMAGE,PORTS,CPU,MEMORY_USED,MEMORY_ALLOCATED,MEMORY_PERCENTAGE"

# Loop through running containers
docker ps --format "{{.Names}},{{.Image}},{{.Ports}}" | while IFS=, read -r name image ports; do
    # Extract only the open port numbers (remove the protocol part like tcp)
    open_ports=$(echo "$ports" | sed -E 's/([0-9]+).*[^0-9]*/\1 /g' | tr -s ' ')

    # Get stats from docker stats
    stats=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}}" "$name")

    # Parse the stats into individual variables
    cpu_usage=$(echo "$stats" | cut -d',' -f1 | sed 's/%//')
    memory_usage=$(echo "$stats" | cut -d',' -f2 | awk -F'/' '{print $1}')
    memory_allocated=$(echo "$stats" | cut -d',' -f2 | awk -F'/' '{print $2}')
    memory_percentage=$(echo "$stats" | cut -d',' -f3 | sed 's/%//')

    # Print the result in CSV format
    echo "$name,$image,$open_ports,$cpu_usage,$memory_usage,$memory_allocated,$memory_percentage"
done
