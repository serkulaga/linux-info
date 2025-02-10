#!/bin/bash

# Ensure nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "Installing nmap..."
    sudo apt update && sudo apt install -y nmap
fi

# Determine local network subnet
IP_RANGE=$(ip route | grep "src" | awk '{print $1}' | head -n 1)
if [ -z "$IP_RANGE" ]; then
    echo "Could not determine local network range."
    exit 1
fi
echo "Scanning network: $IP_RANGE"

# Define output file
OUTPUT_FILE="nmap_scan_results.csv"
echo "IP Address, MAC Address, Vendor, Hostname, OS, Uptime, Open Ports, Protocols, Services" > "$OUTPUT_FILE"

# Perform an advanced scan
sudo nmap -O -sV -p- --script banner,uptime,mac-address,vuln "$IP_RANGE" -oG - | awk '
/Up$/{ip=$2}
/MAC Address:/{mac=$3; vendor=substr($0, index($0,$4))}
/Ports:/{split($0, p, "Ports: "); split(p[2], ports, ", "); open_ports=""; protocols=""; services="";
    for (i in ports) {
        split(ports[i], details, "/");
        open_ports = open_ports details[1] " ";
        protocols = protocols details[2] " ";
        services = services details[5] " ";
    }
    print ip "," mac "," vendor "," $5 "," $4 "," $6 "," open_ports "," protocols "," services
}' >> "$OUTPUT_FILE"

echo "Scan complete. Results saved to $OUTPUT_FILE."
