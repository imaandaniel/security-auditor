#!/usr/bin/env bash

# Host Security & System health Auditor
# Module 1: Storage & Filesystem Health 

STORAGE_WARN=80
STORAGE_CRIT=90

audit_storage() {
	local disk_usage
	disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
	
	echo "[*] Auditing Storage: Root filesystem usage is ${disk_usage}%"

	if [ "$disk_usage" -ge "$STORAGE_CRIT" ]; then
	    echo "[CRITICAL] Root partition exceeds ${STORAGE_CRIT}%!"
	elif [ "$disk_usage" -ge "$STORAGE_WARN" ]; then
	    echo "[WARNING] Root partition exceeds ${STORAGE_WARN}%!"
	else	
	    echo "[PASS] Storage capacity is healthy."
	fi
}

#Main Execution Flow
audit_storage

# --- MODULE 2: MEMORY & SWAP PRESSURE ---
echo -e "\n[*] Auditing Memory & Swap Pressure..."

# Extract available RAM percentage and used Swap percentage
MEM_AVAIL_PCT=$(free -m | awk '/Mem:/ {printf "%.0f", ($7/$2) * 100}')
SWAP_USED_PCT=$(free -m | awk '/Swap:/ {if ($2 > 0) printf "%.0f", ($3/$2) * 100; else print 0}')

echo "Available RAM: ${MEM_AVAIL_PCT}%"
echo "Used Swap:     ${SWAP_USED_PCT}%"

# Evaluate RAM Health
if [ "$MEM_AVAIL_PCT" -le 10 ]; then
    echo "[CRITICAL] Available memory dangerously low (${MEM_AVAIL_PCT}% remaining)!"
elif [ "$MEM_AVAIL_PCT" -le 20 ]; then
    echo "[WARNING] Memory pressure detected (${MEM_AVAIL_PCT}% remaining)."
else  
  echo "[OK] Memory headroom is healthy."
fi

# Evaluate Swap Health
if [ "$SWAP_USED_PCT" -ge 80 ]; then
    echo "[CRITICAL] High swap exhaustion (${SWAP_USED_PCT}% used)! Thrashing risk imminent."
elif [ "$SWAP_USED_PCT" -ge 50 ]; then
    echo "[WARNING] Moderate swap usage (${SWAP_USED_PCT}% used)."
else
    echo "[OK] Swap utilization is nominal."
fi
