#!/bin/bash

# This script disables, deletes, and/or archives user accounts.

readonly ARCHIVE_DIR='/archive'

usage() {
  if [[ $UID -ne 0 ]]
  then
    echo "Please, run sudo ${0}"
  elif [[ $1 -eq 'option' ]]
  then
    echo "Invalid option is provided." >&2
    echo "There are valid options:" >&1
    echo "Use :" >&1
    echo "     -d   deletes accounts instead of disabling them." >&1
    echo "     -r   removes the home directory associated with the account(s)." >&1
    echo "     -a   creates an archive of the home directory associated with" >&1
    echo "          the account(s) and stores the archive in the /archives" >&1
    echo "          directory." >&1
  elif [[ $1 -eq 'usernames' ]]
  then
    echo "You DID NOT specified any username." >&2
    echo "Please, provide ATLEAST ONE username." >&1
    echo "Usage:"
    echo "      sudo  $0 [OPTIONS] [USERNAME]..."
  fi

  exit 1
}

display_on_failure() {
  if [[ $? -ne 0 ]]
  then
    local MESSAGE=$1
    echo $MESSAGE >&2
    exit 1
  fi
}

if [[ $UID -ne 0 ]]
then
  echo "You DO NOT have a superuser privileges to run this script." >&2
  exit 1
fi


while getopts dra OPTION
do
  case $OPTION in
    d)
      DELETE_USER='true';;
    r)
      REMOVE_OPTION='-r';;
    a)
      ARCHIVE='true';;
    ?)
      usage 'option';;
   esac
done

shift $(( OPTIND - 1 ))

USERNAMES=$@
for USERNAME in $USERNAMES
do
  echo "Processing the user ${USERNAME}"
  USERID=$(id -u $USERNAME)
  if [[ $USERID -lt 1000 ]]
  then
    echo "Refusing to remove $USERNAME account with UID $USERID" >&2
    exit 1
  fi

  if [[ $ARCHIVE -eq 'true' ]]
  then

    if [[ ! -d $ARCHIVE_DIR ]]
    then
      echo "Creating ${ARCHIVE_DIR}"
      mkdir -p $ARCHIVE_DIR
    fi

    display_on_failure "Creating ${ARCHIVE_DIR} failed."

    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"

    if [[ -d $HOME_DIR ]]
    then
      echo "Creating archive of ${HOME_DIR}"
      tar -zcf $ARHIVE_FILE $HOME_DIR

      display_on_failure "Creating archive ${ARHIVE_FILE} failed."
    else
      echo "${HOME_DIR} does not exist or is not a directory." >&2
      exit 1
    fi

    if [[ $DELETE_USER -eq 'true' ]]
    then
      userdel $REMOVE_OPTION $USERNAME

      display_on_failure "Deleting account of ${USERNAME} failed."

      echo "${USERNAME} was deleted."
    else
      chage -E 0 $USERNAME

      display_on_failure "Account WAS NOT disabled."
      echo "Account was disabled."
    fi
  fi
done

exit 0

