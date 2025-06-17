#!/bin/bash

# Simple WordPress Backup Script for ICT171 Assignment
# This script performs a basic backup of WordPress database and files.
# Author: [maheshpalamuttath] (Tyrone Steele } 35500984)


# 1: Database connection info. <<< REPLACE WITH YOUR ACTUAL CREDENTIALS >>>
DB_NAME="wordpress_blog"
DB_USER="Thepottersclay"
DB_PASSWORD="CaityTy1110"
DB_HOST="localhost"

# 2: Path to WordPress root directory and backup folder. <<< REPLACE WITH YOUR ACTUAL PATHS >>>
WP_ROOT_FOLDER="/var/www/html/thepottersclay.com.au/public" # Your WordPress installation root
BACKUP_FOLDER_PATH="/home/ubuntu/backups" # Recommended: Folder in your home directory for easy access
# --- END CONFIGURATION ---

# --- SCRIPT LOGIC ---

# 1: Define backup filenames with timestamps.
DATE=$(date +%d-%m-%Y-%H.%M.%S) #
DB_BACKUP_NAME="wp-db-backup-${DATE}.sql.gz"
WPFILES_BACKUP_NAME="wp-full-site-backup-${DATE}.tar.gz"

# Create backup directory if it doesn't exist and ensure ownership/permissions for script runner
sudo mkdir -p "$BACKUP_FOLDER_PATH"
sudo chown ubuntu:ubuntu "$BACKUP_FOLDER_PATH"
sudo chmod 755 "$BACKUP_FOLDER_PATH"

# Set up logging to console and file simultaneously
LOG_FILE="${BACKUP_FOLDER_PATH}/wp-backup-${DATE}.log"
exec > >(sudo tee -a "${LOG_FILE}") 2>&1

echo "================================================="
echo "WordPress Backup Script Started: $(date)"
echo "================================================="
echo ""

# Check if WordPress root folder exists
