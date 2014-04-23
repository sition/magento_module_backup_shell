#!/bin/sh
#
# File base and MYSQL backup script
#

# PATH AND FILE NAME CONFIG
NOWDATE=`date +%m-%d-%y` # Sets the date variable format for zipped file: MM-dd-yy
FILENAME="$NOWDATE-backup.tar.gz"
SQLNAME="$NOWDATE-backup.sql"
STARGET="/home/admin/domains/stagefreaks.nl/backup/"
SSOURCE="/home/admin/domains/stagefreaks.nl/public_html/*"
RBACKUP="tar -zcf $STARGET$FILENAME $SSOURCE"


# DATABASE CONFIG
DBHOSTS="localhost"
DBNAME="admin_sf"
DBUSER="admin_sf"
DBPASSWORD="^vuqA94qh{2csM2zo"

#EMAIL CONFIG
EMAIL="michel.doens@sition.nl"


clear # clears terminal window
echo
echo "Hi, $USER!"
echo
echo "Beginning backup of files @ `date`"
echo
echo "tar directory structure..."
$RBACKUP
echo
echo "Backup Complete!"
echo
echo "Beginning backup of MYSQL @ `date`"
echo
mysqldump --opt -u $DBUSER -p$DBPASSWORD $DBNAME > $STARGET$SQLNAME
echo "End MYSQL Backup"
echo "Backup Complete" | mail -s "Backup" $EMAIL