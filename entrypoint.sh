#!/bin/sh -l

#set -e at the top of your script will make the script exit with an error whenever an error occurs (and is not explicitly handled)
set -eu
apt install expect

PASSWORD=$4
#TEMP_SFTP_FILE='../sftp'

echo 'ssh start'

#ssh -o StrictHostKeyChecking=no -p $3 -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2 mkdir -p $6

echo 'sftp start'
# create a temporary file containing sftp commands
#printf "%s" "put -r $5 $6" >$TEMP_SFTP_FILE
#-o StrictHostKeyChecking=no avoid Host key verification failed.
#sftp -b $TEMP_SFTP_FILE -P $3 $7 -o StrictHostKeyChecking=no $1@$2
/usr/bin/expect -c "
spawn /usr/bin/sftp -P ${3} -o StrictHostKeyChecking=no ${1}@${2}
expect \"password: \"
send \"${4}\r\"
expect \"sftp>\"
send \"put -r ${5} ${8}\r\"
expect \"sftp>\"
send \"put -r ${6} ${9}\r\"
expect \"sftp>\"
send \"put -r ${7} ${10}\r\"
expect \"sftp>\"
send \"bye\r\"
expect \"#\"
"

echo 'deploy success'
exit 0

