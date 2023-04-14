#!/bin/bash

CWL="[\e[1;36mWELCOME\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"

clear

CONTAINER_NAME=$1

# Introduction message
echo -e "\033[1m\033[32mWelcome to container manager.\033[0m You are managing \033[1m$CONTAINER_NAME\033[0m container."

# Commands
function creds() {
  command_executed=false
  clear
  while [[ $command_executed == false ]]; do
    read -r -rep "- ($CONTAINER_NAME) [Credentials]: " subcommand
    if [[ $subcommand == "w" ]]; then
        read -rp "Enter key: " key
        read -rp "Enter value: " value
        
        if [[ -n "$key" && -n "$value" ]]; then
            echo "$key:$value" >> ./containers/$CONTAINER_NAME/creds.store
        else
            echo "Key and value cannot be empty"
        fi
    elif [[ $subcommand == "r" ]]; then
        clear
        if [ -e ./containers/$CONTAINER_NAME/creds.store ]; then
            cat ./containers/$CONTAINER_NAME/creds.store
            echo ""
            echo "Press any key to continue"
            read -n1 -s
            clear
        else
            clear
            echo "No values found in database."
            sleep 1.5
        fi
    elif [[ $subcommand == "d" ]]; then
        read -rp "Enter key to delete: " key_to_delete
        if [ -n "$key_to_delete" ]; then
            sed -i "/^$key_to_delete:/d" ./containers/$CONTAINER_NAME/creds.store
            echo "Key '$key_to_delete' deleted successfully."
        else
            echo "Key cannot be empty."
        fi
    elif [[ $subcommand == "exit" ]]; then
        command_executed=true
    else
        echo "Unknown command: $subcommand"
    fi
  done
}

function hasher() {
  command_executed=false
  clear
  while [[ $command_executed == false ]]; do
    read -r -rep "- ($CONTAINER_NAME) [Credentials]: " subcommand
    if [[ $subcommand == "e" ]]; then
        read -r -p "Enter hash function (md5, sha1, sha256, sha512): " hash_func
        read -r -p "Enter value to encrypt: " value
        read -r -p "Enter key (optional): " key
        if [[ -z "$key" ]]; then
          encrypted=$(echo -n "$value" | openssl dgst -$hash_func -binary | base64)
        else
          encrypted=$(echo -n "$value" | openssl enc -$hash_func -k "$key" -a)
        fi
        echo "Encrypted text: $encrypted"
    elif [[ $subcommand == "d" ]]; then
        read -r -p "Enter hash function (md5, sha1, sha256, sha512): " hash_func
        read -r -p "Enter value to decrypt: " value
        read -r -p "Enter key (optional): " key
        if [[ -z "$key" ]]; then
          plaintext=$(echo -n "$value" | base64 -d | openssl dgst -$hash_func)
        else
          plaintext=$(echo -n "$value" | openssl enc -$hash_func -k "$key" -d)
        fi
        echo "Decrypted text: $plaintext"
    else
        echo "Unknown command: $subcommand"
    fi
  done
}


# List of commands
declare -A COMMANDS=(
  ["credentials"]="creds"
  ["creds"]="creds"
  ["c"]="creds"

  ["h"]="hasher"
  ["hasher"]="hasher"
  ["hash"]="hasher"
)

# Main loop
while true; do
  # Get the current container name

  # Read the user input
  read -r -rep "- ($1): " command

  # Check if the command exists in the mapping
  if [[ -n "${COMMANDS[$command]}" ]]; then
    # If it does, execute the corresponding function
    "${COMMANDS[$command]}"
  elif [[ "$command" == "exit" ]]; then
    # If the command is "exit", exit the script
    exit
  else
    # Otherwise, print an error message
    echo "Unknown command: $command"
  fi
done

