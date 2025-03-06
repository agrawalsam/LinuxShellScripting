# LinuxShellScripting
Repo for linux shell scripts

1. User Management Project - A Linux Shell Script on User Management. This scripts automates user creation, deletion and modification. <br>

Project Scope - <br>

a. Lists All Users <br>
    Display all system users.

b. User Creation <br>
    Check if the user already exists. <br>
    Create a user with a home directory. <br>
    Set a password for the new user. <br>

c. User Deletion <br>
    Check if the user exists before deletion. <br>
    Remove the user. <br>

d. Modify User Details <br>
    Change a user's username. <br>
    Change a user’s password. <br>
    Change the user's home directory. <br>

e. Add a User to a Group <br>
    Assign a user to an existing group. <br>
    Verify if the user and group exist before assigning. <br>

Usage - <br>

Usage: ./usermanagement.sh -[option] <br>

Options: <br>
  -l   List all system users <br>
  -c   Create a new user <br>
  -d   Delete an existing user <br>
  -m   Modify a user's information (username, password, or home directory) <br>
  -a   Add a user to a group <br>

Example usage:<br>
  ./usermanagement.sh -l              # List all users <br>
  ./usermanagement.sh -c              # Create a new user <br>
  ./usermanagement.sh -d              # Delete an existing user <br>
  ./usermanagement.sh -m              # Modify a user's information <br>
  ./usermanagement.sh -a              # Add a user to a group <br>
