# LinuxShellScripting
Repo for linux shell scripts

1. User Management Project - A Linux Shell Script on User Management. This scripts automates user creation, deletion and modification. <br>
Project Scope -
a. Lists All Users
    Display all system users.

b. User Creation
    Check if the user already exists.
    Create a user with a home directory.
    Set a password for the new user.

c. User Deletion
    Check if the user exists before deletion.
    Remove the user.

d. Modify User Details
    Change a user's username. 
    Change a user’s password.
    Change the user's home directory. 

e. Add a User to a Group
    Assign a user to an existing group.
    Verify if the user and group exist before assigning.

Usage - 

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
