#!/bin/bash

REQUIRED_UID='0'

if [[ $UID != $REQUIRED_UID ]]
then
  echo 'Sorry, but you are not a user with a root privileges. You are not allowed to execute that script.'
  exit 1
fi

read -p 'Please, enter you username: ' USERNAME
read -p 'Please, enter your real name: ' REALNAME
read -p 'Please, enter your password: ' PASSWORD

useradd -c "${REALNAME}" -m $USERNAME

if [[ $? = 0 ]]
then
  echo "Account for $USERNAME is successfully created."
else
  echo "Attempt to create account for $USERNAME is failed."
  exit 1
fi

echo $PASSWORD | passwd --stdin $USERNAME
passwd -e $USERNAME


HOST=$(hostname)

echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOST}"


