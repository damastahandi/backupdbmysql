#!/bin/sh
HOST='(your-server-ip)'
DSTFOLDER='(your-dst-folder)'
EXTRAFILE='(your-extra-file)'
DATE="$(date '+%d%m%Y-%H%M')"
LOG='(backup-log)'

function get_all_db {
   /bin/mysql --defaults-extra-file=$EXTRAFILE -h $HOST -e 'SHOW DATABASES;' | \
      /bin/tr -d '| ' | /bin/awk '!/Database|mysql|performance_schema|sys|information_schema/{print $i}'
}

function backupdb {
   while read db; do /usr/bin/mysqldump --defaults-extra-file=$EXTRAFILE -h $HOST --single-transaction --routines --databases $db > $DSTFOLDER/${db}.sql 2> $LOG; done
}

function compress_db {
   while read sql; do /usr/bin/tar -zcf ${sql}-$DATE.tar.gz -C $DSTFOLDER ${sql}.sql 2> $LOG; done
}

function rm_file {
   while read rm; do /usr/bin/rm -f $DSTFOLDER/${rm}.sql; done
}

function send_msg_fail {
	/usr/local/bin/telegram-send -g "Backup database error, please see $LOG for detail information."
}

function send_msg_success {
   LISTFILES="$(ls -lhtr $DSTFOLDER | awk '{print $5,$9}')"
   /usr/local/bin/telegram-send -g "Backup database success has successful! $LISTFILES"
}

# Create an alias
alias cddstfolder='cd $DSTFOLDER'

# Array database & BackupDatabases
get_all_db | backupdb
if [ "$?" -ne 0 ]
then
 send_msg_fail
else
 # Go to destination folder
 cddstfolder
 # Compress database
 get_all_db | compress_db
 if [ "$?" -ne 0 ]
 then
  send_msg_fail
 else
  # Remove file with extension .sql
  get_all_db | rm_file
  LISTFILES="$(ls -lhtr $DSTFOLDER | awk '{print $5,$9}')"
  send_msg_success
  # Remove file after 7 days
  find $DSTFOLDER -maxdepth 1 -type f -mtime +7 -name '*.tar.gz'
  if [ "$?" -ne 0 ]
  then
   /usr/local/bin/telegram-send -g "Backup file older than 7 days not found."
  else
   DELETEFILES="$(find $DSTFOLDER -maxdepth 1 -type f -mtime +7 -name '*.tar.gz' -ls -exec rm {} \;)"
   /usr/local/bin/telegram-send -g "Backup file older than 7 days has been deleted! $DELETEFILES"
  fi
 fi
fi
  
