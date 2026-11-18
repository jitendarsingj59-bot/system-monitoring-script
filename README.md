
# System Monitoring and Alerting

## Project Overview
This project is a Bash-based system monitoring tool that monitors CPU, memory, and disk usage on an Ubuntu Linux system.

## Features
- Monitors disk usage.
- Monitors memory usage.
- Monitors CPU usage using mpstat.
- Displays top 5 CPU-consuming processes.
- Displays top 5 memory-consuming processes.
- Logs monitoring results with timestamps.
- Generates alerts when usage exceeds configured thresholds.
- Runs automatically every 5 minutes using Cron.

## Requirements
- Ubuntu Linux
- Bash
- sysstat (mpstat)
- Git

## Usage

Make the script executable:

```bash
chmod +x system_monitor.sh
```

Run the monitoring script:

```bash
./system_monitor.sh
```

## Configuration

Default thresholds:

- Disk: 80%
- Memory: 80%
- CPU: 80%

## Log File

Monitoring logs are stored in:

`logs/system_monitor.log`

View logs:

```bash
cat logs/system_monitor.log
```

## Automated Monitoring with Cron

The script is scheduled to run every 5 minutes.

```bash
*/5 * * * * cd /home/jeet/system-monitoring-script && ./system_monitor.sh
```

## Verification

Cron automation was verified by checking the log file and confirming that new monitoring entries appeared at 5-minute intervals.

## Author
Jeet

## Sample Output

Example output from the monitoring script:

System monitoring started.

Disk usage normal on /: 5%
Disk usage normal on /boot/efi: 1%

Memory usage normal: 15%
CPU usage normal: 1.5%

Top 5 CPU-consuming processes:
[Process details displayed]

Top 5 Memory-consuming processes:
[Process details displayed]

System monitoring completed.
