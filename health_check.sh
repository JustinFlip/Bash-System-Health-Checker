#!/bin/bash

# System Health Check Script
# Quick validation of critical system metrics

echo "=== System Health Check ==="
echo "Date: $(date)"
echo ""

# CPU Usage
echo ">>> CPU Usage"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "CPU Usage: ${cpu_usage}%"
if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "⚠️  WARNING: High CPU usage"
fi
echo ""

# Memory Usage
echo ">>> Memory Usage"
mem_info=$(free -m | awk 'NR==2{printf "Used: %sMB (%.2f%%)\n", $3, $3*100/$2 }')
mem_percent=$(free | awk 'NR==2{printf "%.0f", $3*100/$2 }')
echo "$mem_info"
if [ "$mem_percent" -gt 90 ]; then
    echo "⚠️  WARNING: High memory usage"
fi
echo ""

# Disk Usage
echo ">>> Disk Usage"
df -h | awk 'NR==1 || /\/$/ || /^\/dev\/(sd|nvme|xvd)/ {print $0}'
critical_disks=$(df -h | awk '0+$5 > 90 {print $6 " at " $5}')
if [ -n "$critical_disks" ]; then
    echo "⚠️  WARNING: Critical disk usage:"
    echo "$critical_disks"
fi
echo ""

# Load Average
echo ">>> Load Average"
load_avg=$(uptime | awk -F'load average:' '{print $2}')
echo "Load Average:$load_avg"
echo ""

# Check critical services (common ones)
echo ">>> Critical Services"
services=("sshd" "cron" "systemd-resolved")
for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo "✓ $service: running"
    elif service "$service" status >/dev/null 2>&1; then
        echo "✓ $service: running"
    else
        echo "✗ $service: not running or not found"
    fi
done
echo ""

# Network connectivity
echo ">>> Network Connectivity"
if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
fi
echo ""

# Check for failed systemd services
echo ">>> Failed Services"
failed=$(systemctl list-units --state=failed --no-pager 2>/dev/null | grep -c "failed")
if [ "$failed" -gt 0 ]; then
    echo "⚠️  $failed failed service(s) detected:"
    systemctl list-units --state=failed --no-pager --no-legend 2>/dev/null
else
    echo "✓ No failed services"
fi
echo ""

# Summary
echo "=== Health Check Complete ==="
echo ""
echo "---"
echo "Justin Flip Health Checker"
echo "---"
