#!/bin/sh
#
# File base and MYSQL backup script
#
####################################################################
# backupsite.sh - backup all files and folders in Web DocRoot

#######################
# DATABASE CONFIG
DBHOSTS="dbint054241"
DBNAME="db054241_deterra_production"
DBUSER="u054241_root" 
DBPASSWORD="v8&K@S7YTYdXf@ue"

#######################
# Config Directories
HOMEDIR=/home/users/detexftp
BINDIR=/home/users/detexftp/deterra.nl/bin
BAKDIR=/home/users/detexftp/deterra.nl/backup
# path from homedir to magento folder
DOCDIR=deterra.nl





TIMESTAMP=$(date +%Y%m%d)



if [ "$1" != "" ] || [ "$1" = "--help" ]
   then
      echo -e "\nUseage: backupsite.sh (Archive Doc Root to .tgz file)\n"
      exit 1
fi






echo -e "\nBeginning Site Archive... \n"

#########
# Site Doc Root Folder

echo -e "Archiving $DOCDIR to file $BAKDIR/$TIMESTAMP-public_html.tgz"

cd $HOMEDIR/$DOCDIR

tar -czf $BAKDIR/$TIMESTAMP-public_html.tgz --exclude="media/*" \
         --exclude="var/backups/*"  --exclude="backup/*"  --exclude="var/cache/*"  \
         --exclude="var/session/*" .

if [ -f $BAKDIR/$TIMESTAMP-public_html.tgz ]
   then
      echo -e "Archive $BAKDIR/$TIMESTAMP-public_html.tgz completed\n"
   else
      echo -e "\nWeb Site Document Root Backup Failed!\n"
      exit 1
fi

########
# Media Folder

echo -e "Archiving public_html/media to file $BAKDIR/$TIMESTAMP-media.tgz"

tar -czf $BAKDIR/$TIMESTAMP-media.tgz --exclude="media/tmp/*" \
         --exclude="media/catalog/product/cache/*" media

if [ -f $BAKDIR/$TIMESTAMP-media.tgz ]
   then
      echo -e "Archive $BAKDIR/$TIMESTAMP-media.tgz completed\n"
   else
      echo -e "\nWeb Site Media/ Directory Backup Failed!\n"
      exit 1
fi

########
# Database

echo "Beginning backup of MYSQL @ `date`"
echo
mysqldump --opt --host=$DBHOSTS -u $DBUSER -p$DBPASSWORD $DBNAME > $BAKDIR/$TIMESTAMP-db.sql


if [ -f $BAKDIR/$TIMESTAMP-db.sql ]
   then
      echo -e "Archive $BAKDIR/$TIMESTAMP-db.sql completed\n"
   else
      echo -e "\nWeb Site DATABASE Backup Failed!\n"
      exit 1
fi

echo -e "Site Archive Complete\n"