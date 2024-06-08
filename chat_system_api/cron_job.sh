#!/bin/bash
# cron_job.sh

# Update crontab
whenever --update-crontab

# Start cron
cron -f
