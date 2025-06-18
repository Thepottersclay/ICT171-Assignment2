#!/bin/bash



DB_NAME="wordpress_blog"
DB_USER="Thepottersclay"
DB_PASSWORD="CaityTy1110"
DB_HOST="localhost"

WP_ROOT_FOLDER="/var/www/html/thepottersclay.com.au/public"
BACKUP_FOLDER_PATH="/home/ubuntu/backups"


DATE=$(date +%d-%m-%Y-%H.%M.%S) #
DB_BACKUP_NAME="wp-db-backup-${DATE}.sql.gz"
WPFILES_BACKUP_NAME="wp-full-site-backup-${DATE}.tar.gz"


sudo mkdir -p "$BACKUP_FOLDER_PATH"
sudo chown ubuntu:ubuntu "$BACKUP_FOLDER_PATH"
sudo chmod 755 "$BACKUP_FOLDER_PATH"


LOG_FILE="${BACKUP_FOLDER_PATH}/wp-backup-${DATE}.log"
exec > >(sudo tee -a "${LOG_FILE}") 2>&1

echo "================================================="
echo "WordPress Backup Script Started: $(date)"
echo "================================================="
echo ""

if [ ! -d "$WP_ROOT_FOLDER" ]; then
    echo "ERROR: WordPress installation folder '$WP_ROOT_FOLDER' not found. Exiting."
    exit 1
fi


echo "--- Backing up database '$DB_NAME' ---"

if sudo mariadb-dump --opt -u"$DB_USER" -p"$DB_PASSWORD" -h"$DB_HOST" "$DB_NAME" | gzip > "$BACKUP_FOLDER_PATH/$DB_BACKUP_NAME"; then
    echo "Database backup successful: $BACKUP_FOLDER_PATH/$DB_BACKUP_NAME"
else
    echo "ERROR: Database backup failed! Check DB credentials and database server status."
    exit 1
fi

echo ""


echo "--- Backing up WordPress files from '$WP_ROOT_FOLDER' ---"
cd "$WP_ROOT_FOLDER" || { echo "ERROR: Could not navigate to WordPress root. Exiting."; exit 1; }

if sudo tar -czf "$BACKUP_FOLDER_PATH/$WPFILES_BACKUP_NAME" --exclude='./wp-content/cache' --exclude='./wp-content/uploads/cache' .; then
    echo "WordPress files backup successful: $BACKUP_FOLDER_PATH/$WPFILES_BACKUP_NAME"
else
    echo "ERROR: WordPress files backup failed! Check permissions for '$WP_ROOT_FOLDER'."
    exit 1
fi

echo ""


echo "--- Cleaning up old database backups ---"
find "$BACKUP_FOLDER_PATH" -maxdepth 1 -name "*.sql.gz" -type f -printf "%T@ %p\n" | sort -rn | awk 'NR>3 {print $2}' | xargs -r sudo rm --
echo "Old database backups cleaned."

echo ""


echo "--- Cleaning up old WordPress files backups ---"
find "$BACKUP_FOLDER_PATH" -maxdepth 1 -name "*.tar.gz" -type f -printf "%T@ %p\n" | sort -rn | awk 'NR>3 {print $2}' | xargs -r sudo rm --
echo "Old files backups cleaned."

echo ""
echo "================================================="
echo "WordPress Backup Script Completed: $(date)"
echo "================================================="

exit 0
