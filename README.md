# LinuxShellScripting
**Repo for linux shell scripts**

**1. User Management Project -** A Linux Shell Script on User Management. This scripts automates user creation, deletion and modification. <br>

**2. Directory Backup into a S3 Bucket -** A Linux Shell Script Project to compress directory and store it in S3 as a backup. <br>

**1. User Management Project -** <br>

**Project Scope** - <br>

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

**Usage -** <br>

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

**2. Directory Backup into a S3 Bucket -** <br>

**Project Scope** - <br>
**Objective:** <br>
The purpose of the script is to automate the process of creating backups of a specified directory, compressing it into either a ZIP or TAR format, and optionally uploading the backup to an S3 bucket for storage. It also involves logging actions throughout the process and cleaning up local backups after successful upload.

<br>

a. Directory Validation <br>
    Ensure that the directory to be backed up exists and is readable. <br>
    If the directory does not exist or cannot be read, the script exits with an error and logs the issue. <br>

b. Compression <br>
    The script accepts a compression method (zip or tar). <br>
    It compresses the specified directory into the chosen format (zip or tar). <br>
    If compression fails, the script exits and logs the failure. <br>

c. S3 Upload <br>
    The script allows for an optional S3 destination (s3://bucket-name/path). <br>
    It uploads the compressed backup to the specified S3 location. <br>
    After a successful upload, the script removes the local backup to save space. <br>

d. Logging <br>
    Actions are logged to a user-specific log file ($HOME/backup.log). <br>
    Logs include timestamps and descriptions of the actions taken (e.g., directory check, compression, and S3 upload). <br>


**System Requirements** - <br>
**Dependencies** - <br>
    zip (for compression) should be installed for ZIP compression. <br>
    tar (for compression) should be installed for TAR compression. <br>
    aws-cli (for S3 upload) should be installed and configured with valid AWS credentials. <br>

**Permissions** - <br>
    The script requires write permissions to the log file ($HOME/backup.log). <br>
    The script assumes that the user running it has the appropriate permissions to access the directories and execute aws s3 cp. <br>
