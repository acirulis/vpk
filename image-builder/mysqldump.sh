#!/bin/bash
# MySQL dump backup script
 
# MySQL access information
MyUSER="presidentlv"
MyPASS="yQ7JnsaggMHhZP7J"
MyHOST="db"
MBD="/backup/"
KEEP_BACKUP_COUNT=7
 
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"
TOUCH="$(which touch)"
NOW="$(date +"%Y-%m-%d")"
 
# this function deletes old backups for specified database
function delete_old_backup() {
  if [ $KEEP_BACKUP_COUNT -le 1 ]; then
    echo "ERROR: KEEP_BACKUP_COUNT count should be at least = 2"
    exit 1
  fi
 
  if [ -n "$1" ]; then
    COUNTER=0
    for i in `ls -1 $MBD/$1.*.gz`;
    do
      COUNTER=$(($COUNTER + 1))
      SQL_BACKUP[$COUNTER]="$i"
    done
    BACKUP_COUNT=$COUNTER
 
    BACKUPS_TO_DELETE="$(($BACKUP_COUNT - $KEEP_BACKUP_COUNT))"
    if [ $BACKUPS_TO_DELETE -gt 0 ]; then
      for i in `seq 1 $BACKUPS_TO_DELETE`;
      do
        rm -f "${SQL_BACKUP[$i]}"
      done
    else
      echo "Warning: no backups to delete for database $1, backup count: $BACKUP_COUNT, backups to keep count: $KEEP_BACKUP_COUNT"
    fi
  else
    echo "Error: Database to not specified!"
  fi
}
 
FILE=""
# list of databases to ignore
IGGY="information_schema performance_schema"
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"
 
date
 
for db in $DBS
do
  skipdb=-1
  if [ "$IGGY" != "" ]; then
    for i in $IGGY
    do
      [ "$db" == "$i" ] && skipdb=1 || :
    done
  fi
  if [ "$skipdb" == "-1" ]; then
    delete_old_backup $db
    FILE="$MBD/$db.$NOW.gz"
    $TOUCH $FILE
    $CHMOD 0600 $FILE
    $MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
  fi
done
