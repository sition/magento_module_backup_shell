magento_module_backup_shell
===========================

Magento_module_backup_shell

michel.doens@sition.nl
www.sition.nl

copies and restores database from source to destination server

manual:
1. copy restore & backup folder to magento root dir of source & destination server;
2. edit backup/.htaccess  & add your source server ip address;
3. edit config.cfg files in /backup on source server
4. edit config.cfg files in /restore on desination folder

5. create the backup on source server:  sh cronbackup.sh
6. download & restore backup on destination server:  sh restore.sh 

for questions:  michel.doens@sition.nl  
