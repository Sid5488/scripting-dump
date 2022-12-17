#!/bin/bash

# Shell script to backup MySQL database
# To backup NySQL database file to /backup dir and later up by your
#script. You can skip few databases from backup too.

# Script start hour -- optional
START="$(date)"

# Configuration
mysql_user="" # USERNAME -- YOUR USERNAME
password="" # password -- YOUR PASSWORD
host="" # hostname -- YOUR HOST

mysql="$(which mysql)"
mysql_dump="$(which mysqldump)"
chown="$(which chown)"
chmod="$(which chmod)"

# Backup dest directory
dest="" # YOUR DIRECTORY TO SAVE BACKUP

# Main directory where backup will be stored
mdb="$dest/" # ADD FOLDER TO SAVE

# Get data in dd-mm-yyyy format
now="$(date +"%d-%m-%y")"

# File to store current backup file
file=""

# Store list of databases
tables=""

# Backup these databases
database="" # YOUR DATABASE TO GENERATE DUMP FILE

mkdir $mdb
mkdir $mdb/$now

# Only root can access it!
$chown 0.0 -R $mdb
$chmod 0600 $mdb

# Get all databases list first
tables="$($mysql -u $mysql_user -h $host --password=$password $database -Bse 'SHOW TABLES')"

for table in $tables
do
  if [ -n $table ]; then
    file="$mdb/$now/$table.gz"

    $mysql_dump --add-drop-table --extended-insert --no-create-db -u $mysql_user -h $host --password=$password $database $table > $file
  fi
done

end="$(date)"

touch $mdb/$now/$now
echo $start >> $mdb/$now/$now
echo $end >> $mdb/$now/$now

exit;
