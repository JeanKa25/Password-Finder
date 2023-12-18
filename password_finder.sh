#!/bin/bash

# Function to store new username and password
store_new_credentials() {
  echo "Enter a new username:"
  read new_username

  # Check if the username is valid (not empty)
  if [[ -z "$new_username" ]]; then
    echo "Error: Invalid username"
    return 1
  fi

  echo "Enter a new password:"
  read -s new_password

  # Check if the password is valid (not empty)
  if [[ -z "$new_password" ]]; then
    echo "Error: Invalid password"
    return 1
  fi

  # Encrypt the password using a secure algorithm (example: Base64)
  encrypted_password=$(echo "$new_password" | base64 | tr -d '\n')

  # Append the new username and password to the file
  echo "$new_username:$encrypted_password" >> passwords.txt

  # Success message
  echo "Credentials stored successfully"
}

# Function to retrieve a decrypted password
copy_password() {
  echo "Enter a username:"
  read username

  # Check if the username is valid (not empty)
  if [[ -z "$username" ]]; then
    echo "Error: Invalid username"
    return 1
  fi

  # Check if the password file exists and is readable
  file="./passwords.txt"
  if [[ ! -f "$file" ]] || [[ ! -r "$file" ]]; then
    echo "Error: Could not access password file"
    return 1
  fi

  # Search for the corresponding password
  password=$(grep "$username" "$file" | cut -d ':' -f 2)

  # Check if the password was found
  if [[ -z "$password" ]]; then
    echo "Error: Could not find password for $username"
    return 1
  else
    # Decrypt the password
    decrypted_password=$(echo "$password" | base64 -d)

    # Copy the password to the system's clipboard
    echo "$decrypted_password" | clip.exe

    echo "Password Copied!!"
  fi
}

# Function to retrieve a password
get_password() {
  echo "Enter a username:"
  read username

  # Check if the username is valid (not empty)
  if [[ -z "$username" ]]; then
    echo "Error: Invalid username"
    return 1
  fi

  # Check if the password file exists and is readable
  file="./passwords.txt"
  if [[ ! -f "$file" ]] || [[ ! -r "$file" ]]; then
    echo "Error: Could not access password file"
    return 1
  fi

  # Search for the corresponding password
  password=$(grep "$username" "$file" | cut -d ':' -f 2)
  decrypted_password=$(echo "$password" | base64 -d)

  # Check if the password was found
  if [[ -z "$password" ]]; then
    echo "Error: Could not find password for $username"
    return 1
  else
    # Output the password
    echo "Password for $username: $decrypted_password"
  fi
}

# Function to delete a password
delete_encrypted_password() {
  echo "Enter a username:"
  read username

  # Check if the username is valid (not empty)
  if [[ -z "$username" ]]; then
    echo "Error: Invalid username"
    return 1
  fi

  # Check if the password file exists and is writable
  file="./passwords.txt"
  if [[ ! -f "$file" ]] || [[ ! -w "$file" ]]; then
    echo "Error: Could not access password file"
    return 1
  fi

  # Remove the line with the corresponding username
  sed -i "/$username/d" "$file"

  # Success message
  echo "Password deleted successfully"
}
function menu_loop() {
while true; do
echo "---------------------------------------------------"

echo "What would you like to do?"
echo "1. Store new credentials"
echo "2. Retrieve encrypted password"
echo "3. Copy decrypted password"
echo "4. Delete password"
echo "5. Exit program"
read -p "Enter your choice (1, 2, 3, 4, or 5): " choice

case "$choice" in
  1) store_new_credentials;;
  2) get_password;;
  3) copy_password;;
  4) delete_encrypted_password;;
  5) break;;
  *) echo "Error: Invalid choice";;
esac

done
}
menu_loop
