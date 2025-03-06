# LinuxShellScripting
Repo for linux shell scripts

1. User Management Project - A Linux Shell Script on User Management. This scripts automates user creation, deletion and modification. 
Usage: ./usermanagement.sh -[option]

Options:
  -l   List all system users
  -c   Create a new user
  -d   Delete an existing user
  -m   Modify a user's information (username, password, or home directory)
  -a   Add a user to a group

Example usage:
  ./usermanagement.sh -l              # List all users
  ./usermanagement.sh -c              # Create a new user
  ./usermanagement.sh -d              # Delete an existing user
  ./usermanagement.sh -m              # Modify a user's information
  ./usermanagement.sh -a              # Add a user to a group
