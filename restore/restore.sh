#!/bin/sh
#
# File base and MYSQL backup script
#
####################################################################
# restore.sh - put in resore folder

#######################
# DATABASE CONFIG
DOMAINNAME="deterra.sition-klanten.nl"
PREFIX=""
DBHOST="localhost"
DBNAME="deterra"
DBUSER="deterra" 
DBPASSWORD="pFtXBHLFRbIGjwPN"

#######################
# Config Directories
HOMEDIR=/home/deterra
BINDIR=$HOMEDIR/bin
BAKDIR=$HOMEDIR/backup
# path from homedir to magento folder
DOCDIR=public_html
SOURCE=www.deterra.nl

TIMESTAMP=$(date +%Y%m%d)

echo "################### getting database files ################### "
cd $HOMEDIR/$DOCDIR 
wget http://$SOURCE/backup/$TIMESTAMP-db.sql -N

echo "################### getting public_html files ################### " 
wget http://$SOURCE/backup/$TIMESTAMP-public_html.tgz -N

echo "################### getting media files ################### " 
wget http://$SOURCE/backup/$TIMESTAMP-media.tgz -N

echo "################### extracting website###################  " 
tar -xzvf $HOMEDIR/$DOCDIR/$TIMESTAMP-public_html.tgz

echo "################### extracting media folder ################### " 
tar -xzvf $HOMEDIR/$DOCDIR/$TIMESTAMP-media.tgz

cd $HOMEDIR/$DOCDIR/app/etc/
cp local.xml local-$TIMESTAMP.xml

echo "<config>
    <global>
        <install>
            <date><![CDATA[Thu, 21 Nov 2013 09:01:42 +0000]]></date>
        </install>
        <crypt>
            <key><![CDATA[L6pa7.HdJo6GT4[BCL]]></key>
        </crypt>
        <disable_local_modules>false</disable_local_modules>
        <resources>
            <db>
                <table_prefix><![CDATA[$PREFIX]]></table_prefix>
            </db>
            <default_setup>
                <connection>
                    <host><![CDATA[$DBHOST]]></host>
                    <username><![CDATA[$DBUSER]]></username>
                    <password><![CDATA[$DBPASSWORD]]></password>
                    <dbname><![CDATA[$DBNAME]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </default_setup>
        </resources>
        <session_save><![CDATA[files]]></session_save>
    </global>
    <admin>
        <routers>
            <adminhtml>
                <args>
                    <frontName><![CDATA[admin]]></frontName>
                </args>
            </adminhtml>
        </routers>
    </admin>
</config>" > local.xml

echo "################### restore database & update domain ################### "
cd $HOMEDIR/$DOCDIR
mysql -h $DBHOST -u $DBUSER -D $DBNAME -p$DBPASSWORD -Bse "SET FOREIGN_KEY_CHECKS = 0; source $TIMESTAMP-db.sql;SET FOREIGN_KEY_CHECKS = 1;exit"
mysql -h $DBHOST -u $DBUSER -D $DBNAME -p$DBPASSWORD -Bse "UPDATE core_config_data SET value ='http://$DOMAINNAME/' WHERE path ='web/unsecure/base_url';exit"
mysql -h $DBHOST -u $DBUSER -D $DBNAME -p$DBPASSWORD -Bse "UPDATE core_config_data SET value ='http://$DOMAINNAME/' WHERE path ='web/secure/base_url';exit"
wait
echo "################### touch index.php, disabeling compiler & cache ################### "
cd $HOMEDIR/$DOCDIR
php -f index.php >/dev/null
wait
cd $HOMEDIR/$DOCDIR/shell
php -f cleancache.php all 
wait
php -f compiler.php disable 
wait
php -f indexer.php reindexall
wait

echo "###################  done ################### " 

