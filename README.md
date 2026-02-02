# System Health Checker

A lightweight Bash script for quick validation of critical system metrics on Linux systems.

## Features

- **CPU Usage Monitoring** - Tracks CPU utilization with warnings at >80%
- **Memory Usage** - Monitors RAM consumption with alerts at >90%
- **Disk Space Check** - Validates available disk space (warns at >90% usage)
- **Load Average** - Displays system load metrics
- **Service Status** - Checks critical services (SSH, cron, DNS resolver)
- **Network Connectivity** - Verifies internet connection
- **Failed Services Detection** - Identifies any failed systemd services

## Requirements

- Linux operating system (tested on Ubuntu/Debian/RHEL-based systems)
- Bash shell
- Standard Linux utilities: `top`, `free`, `df`, `systemctl`, `ping`
- `bc` for floating-point calculations (usually pre-installed)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/system-health-checker.git
cd system-health-checker
```

2. Make the script executable:
```bash
chmod +x health_check.sh
```

## Usage

Run the script manually:
```bash
./health_check.sh
```

### Sample Output

```
=== System Health Check ===
Date: Sun Feb 1 10:30:45 CST 2026

>>> CPU Usage
CPU Usage: 15.3%

>>> Memory Usage
Used: 2048MB (51.20%)

>>> Disk Usage
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       50G   20G   28G  42% /

>>> Load Average
 1.23, 1.45, 1.67

>>> Critical Services
✓ sshd: running
✓ cron: running
✓ systemd-resolved: running

>>> Network Connectivity
✓ Internet connectivity: OK

>>> Failed Services
✓ No failed services

=== Health Check Complete ===

---
Justin Flip Health Checker
---
```

## Automated Monitoring

To run the health check automatically, add it to cron:

```bash
# Edit crontab
crontab -e

# Run every hour and log output
0 * * * * /path/to/health_check.sh >> /var/log/health_check.log 2>&1

# Run every 30 minutes
*/30 * * * * /path/to/health_check.sh >> /var/log/health_check.log 2>&1
```

## Customization

### Adjusting Warning Thresholds

Edit the script to modify warning thresholds:

- **CPU**: Change line `if (( $(echo "$cpu_usage > 80" | bc -l) ));`
- **Memory**: Change line `if [ "$mem_percent" -gt 90 ];`
- **Disk**: Change line `critical_disks=$(df -h | awk '0+$5 > 90 {print $6 " at " $5}')`

### Adding Custom Services

Modify the `services` array to check additional services:

```bash
services=("sshd" "cron" "systemd-resolved" "nginx" "mysql")
```

## Troubleshooting

**Script reports "command not found" for bc:**
```bash
# Ubuntu/Debian
sudo apt-get install bc

# RHEL/CentOS
sudo yum install bc
```

**Permission denied when running script:**
```bash
chmod +x health_check.sh
```

**systemctl commands fail:**
The script falls back to the `service` command for non-systemd systems.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Justin Flip**

---
Justin Flip Health Checker
