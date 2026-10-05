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
