#!/bin/bash

REQUIRED_UID='0'

if [[ $UID -ne $REQUIRED_UID ]]
then
  echo 'Sorry, but you are not a user with a root privileges. You are not allowed to execute that script.'
  exit 1
fi

USERNAME=${1}
COMMENT=${2}
PASSWORD=$(date +%s%N | sha256sum )

useradd -c "${COMMENT}" -m $USERNAME

if [[ $? -eq 0 ]]
then
  echo "Account for $USERNAME is successfully created."
else
  echo "Attempt to create account for $USERNAME is failed."
  exit 1
fi

if [[ ${#} -lt 1 ]]
then
  echo "Usage: ${0} USERNAME ['REAL NAME']"
  exit 1
fi

echo $PASSWORD | passwd --stdin $USERNAME
passwd -e $USERNAME


echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"  
echo "Host: ${HOSTNAME}"
exit 0

