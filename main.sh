#!/bin/bash

CWL="[\e[1;36mWELCOME\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"

if [ "$1" = "res" ]; then
    find "./containers/" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 rm -r --
    echo "All folders in ./containers/ deleted."
fi

# Variables
SELECTED_CONTAINER=""

# Functions

create_container() {
  if [ ! -d "./containers/$1" ]; then
    mkdir -p "./containers/$1"
    echo -e "$COK - Container $1 created"
  else
    echo -e "$CER - Container $1 already exists"
  fi
}

select_folder() {
  folders=()
  for d in ./containers/*/; do
    if [ -d "$d" ]; then
      folders+=("$(basename "$d")")
    fi
  done

  if [ ${#folders[@]} -eq 0 ]; then
    echo "No folders found in ./containers"
    echo "Use argument 'i' to create a new container"
    sleep 3.5
    seconds=3
    while [ $seconds -gt 0 ]
    do
      clear
      echo "Closing in $seconds seconds"
      sleep 1
      ((seconds--))
    done
    exit
  fi

  # Enable letter key support and set selected color
  ESC=$(printf '\033')
  cursor_up="w"
  cursor_down="s"
  selected_start="$ESC[32m"
  selected_end="$ESC[39m"

  # Display folder list and allow scrolling
  selected=0
  while true; do
    clear
    echo -e "$CAC - Please select a Container\n"
    for i in "${!folders[@]}"; do
      if [ $i -eq $selected ]; then
        echo -e "${selected_start}${folders[i]}${selected_end}"
      else
        echo "${folders[i]}"
      fi
    done

    read -rsn1 input
    lower_input=${input,,}
    if [ "$lower_input" == "$cursor_up" ] && [ $selected -gt 0 ]; then
      ((selected--))
    elif [ "$lower_input" == "$cursor_down" ] && [ $selected -lt $((${#folders[@]}-1)) ]; then
      ((selected++))
    elif [ "$input" == "" ]; then
      break
    fi
  done

  SELECTED_CONTAINER=${folders[selected]}

  clear
  echo -e "$CAT - You selected ${folders[selected]}\n"
  echo -e "$CAT - Entering container shell..."
  sleep 0.3
  clear
}

if [ "$1" = "i" ]; then
    read -rep $'[\e[1;33mNew Container\e[0m] - Please enter the Container Name: ' CONTAINER_NAME  
    create_container $CONTAINER_NAME
else
    select_folder
    . containermanager.sh $SELECTED_CONTAINER
fi

