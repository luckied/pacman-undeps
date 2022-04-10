#!/bin/sh
# undeps - This script lists and removes UNneeded DEPendencieS on Arch Linux
# Options: -l <list> | -r <remove> | -ra <remove all - recursive>
# Estêvão Valadão - estevao@archlinux-br.org
 
LOOPFLAG=0
PACMAN=$(which pacman 2> /dev/null)
SUDO=$(which sudo 2> /dev/null)
 
case "$1" in                      
  -l)
  echo -e "
  \r** UNNEEDED DEPENDENCIES **
  \r-> checking dependencies...
  "
  $PACMAN -Qdtq
  if [ "$?" = 1 ]; then
    echo -e "-> Your system doesn't have unneeded dependencies. \n"
  fi 
  ;;
  -r)
  while [ "$LOOPFLAG" = 0 ]
  do
    echo -e "
    \r** UNNEEDED DEPENDENCIES **
    \r-> checking dependencies...
    "
    $PACMAN -Qdtq
    if [ "$?" = 0 ]; then
      echo ""
      echo -n "Remove these packages with pacman? [Y/n] "
      read OPTION 
      if [ "$OPTION" = "y" ] || [ "$OPTION" = "" ]; then
        echo -n "-> "
        if [ -f $SUDO ]; then
          $SUDO $PACMAN -Rn $($PACMAN -Qdtq)
          if [ "$?" != 0 ]; then
            echo -e "-> Dependencies skipped... next dependencies... \n"
          else
            echo -e "-> Unneeded dependencie(s) sucessfully removed. \n"
          fi
        else
          $PACMAN -Rn $($PACMAN -Qdtq)
          echo -e "-> Unneeded dependencie(s) sucessfully removed. \n"
        fi
      elif [ "$OPTION" = "n" ]; then
        exit 0
      fi  
    else
      LOOPFLAG=1
      echo -e "-> Your system doesn't have unneeded dependencies. \n"
    fi
  done
  ;;
  -ra)
  $PACMAN -Qdtq > /dev/null
  if [ "$?" = 1 ]; then
    echo -e "
    \r** UNNEEDED DEPENDENCIES **
    \r-> checking dependencies...
    "
    echo -e "-> Your system doesn't have unneeded dependencies. \n"    
  else  
    echo -e "\n** UNNEEDED DEPENDENCIES - RECURSIVE **"
    echo -n "-> "
    if [ -f $SUDO ]; then
       $SUDO $PACMAN -Rsn $($PACMAN -Qdtq)
    else
       $PACMAN -Rsn $($PACMAN -Qdtq)
    fi
  fi
  ;;
  *)
    echo "Usage: $0 {-l <list> | -r <remove> | -ra <remove all - recursive>}"
esac
exit 0
