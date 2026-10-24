# Host Security & System Health Auditor

An automated, modular Bash auditing tool developed on Ubuntu 26.04.1 LTS to monitor host integrity, resource constraints, and privilege configurations

## System Baseline
- **Distribution:** Ubuntu 26.04.1 LTS
- **Architecture:** x86_64
- **Kernel Version:** 7.0.0-30-generic
- **Internal IP:** 10.0.2.15/24 (enp0s3)

## Auditing Roadmap 
- [] Module 1: Storage & Root Filesystem Capacity
- [] Module 2: Memory & Swap Pressure
- [] Module 3: Identity & Access Management (UID 0 Audit)
- [] Module 4: Network Sockets & Exposed Services

### Module 2: Memory & Swap Pressure
- **Telemetry Source**: `free -m` parsed via `awk`.
- **Key Metric**: Evaluates **Available RAM** rather than free RAM to account for kernel page cache reclaiming.
- **Thresholds**:
  - RAM Available: Warning at `<= 20%`, Critical at `<= 10%`.
  - Swap Used: Warning at `>= 50%`, Critical at `>= 80%`.
- **Failure Risks**: Mitigates runaway memory exhaustion, thrashing, and process termination by the Linux OOM Killer.
