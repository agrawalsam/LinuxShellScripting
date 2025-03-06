#!/bin/bash

log_file="/var/log/user_management.log"

log_action(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $log_file >/dev/null
}

list_user() {
    # Display all system users.
    echo $(cut -d ':' -f1 /etc/passwd)
}

user_exists() {
    # to check whether the user exists or not
    # Search for $1 in the /etc/passwd    
    if grep -q "^$1:" /etc/passwd ; then 
        return 0
    fi
    return 1
}

user_add(){
    echo "Adding User"
    read -s -p "Enter password for $1: " password
    useradd -m -s /bin/bash "$1"
    echo "$1:$password" | sudo chpasswd
    echo "User Added."
}

user_creation() {
    read -p "Enter the User Name to be added: " input

    # first check whether the user exists or not 
    if user_exists "$input"; then 
        echo "User Already Exists"
        log_action "User $input Already Exist!"
        return 1
    fi 

    echo "User doesn't exist yet."
    
    # add the user in the system. 
    user_add "$input"

    if [[ $? -eq 0 ]]; then 
        log_action "User $input Added!"
        return 0
    fi
    log_action "User $input Addition Failed!"
    return 1
}

user_delete(){
    echo "Deleting User."
    userdel "$1"
    echo "User Deleted."
}

user_deletion(){
    read -p "Enter the User Name to be deleted: " input
    
    # first check whether the user exists or not 
    if ! user_exists "$input"; then 
        echo "User Doesn't Exists so it cannot be deleted"
        log_action "User $input doesn't exist so cannot be deleted!"
        return 1
    fi 
    
    # deleting the user from the system. 
    user_delete "$input" 

    if [[ $? -eq 0 ]]; then 
        log_action "User $input Deleted!"
        return 0
    fi 
    log_action "User $input Deletion Failed!"
    return 1
}

group_exists(){
    if grep -q '^$1:' /etc/group ; then 
        return 0
    fi 
    return 1
}

add_user_to_group(){
    read -p "Enter the user name: " input 
    read -p "Enter the group name where $input needs to be added: " group 

    # check whether the name exists or not 
    if ! user_exists "$input"; then 
        echo "User Doesn't Exists so it cannot be deleted"
        log_action "User $input Doesn't Exist!"        
        return 1
    fi

    # check whether the group exists or not 
    if group_exists "$group"; then 
        echo "Group doesn't exists or there is some error"
        log_action "User $group Doesn't Exist!"
        return 1
    fi 

    # Add the user into the group. 
    sudo usermod -aG "$group" "$input" 

    if [[ $? -ne 0 ]]; then 
        echo "User addition to Group failed"
        log_action "User $input Added to Group $group Failed!"
        return 1
    fi 
    echo "User $input added to Group $group."
    log_action "User $input Added to Group $group."
    return 0
}


usage(){
    echo "Usage: $0 -[option]"
    echo ""
    echo "Options:"
    echo "  -l   List all system users"
    echo "  -c   Create a new user"
    echo "  -d   Delete an existing user"
    echo "  -m   Modify a user's information (username, password, or home directory)"
    echo "  -a   Add a user to a group"
    echo ""
    echo "Example usage:"
    echo "  $0 -l              # List all users"
    echo "  $0 -c              # Create a new user"
    echo "  $0 -d              # Delete an existing user"
    echo "  $0 -m              # Modify a user's information"
    echo "  $0 -a              # Add a user to a group"
}


change_username(){
    read -p "Enter the new username for user ${1}: " newinput
    sudo usermod -l $newinput "$1"
    if [[ $? -eq 0 ]]; then 
        echo -e "\nUsername Changed"
        log_action "User $1 Changd to $newinput Successfull!"
        return 0
    else 
        echo -e "\nUsername Change Failed."
        log_action "User $1 Changing to $newinput Failed!"        
        return 1
    fi
}

change_directory(){
    read -p "Enter the new home directory for user $1: " input 
    sudo usermod -d "$input" -m "$1"
    if [[ $? -eq 0 ]]; then 
        echo -e "Directory Changed"
        log_action "Directory $1 Changed to $input Successfull!"
        return 0
    else 
        echo -e "Directory Change Failed."
        log_action "Directory $1 Changed to $input Failed!"
        return 1
    fi
}

modify_password(){
    read -s -p "Enter the new password for user $1: " input
    echo "$1:$input" | sudo chpasswd
    if [[ $? -eq 0 ]]; then 
        echo -e "\nPassword Modification Completed."
        log_action "User $1 Password Changed!"
        return 0
    else 
        echo -e "\nPassword Modification Failed."
        log_action "User $1 Password Changing Failed!"
        return 1
    fi
}

user_modification(){
    read -p "Enter the Username: " user
    # first check whether the user exists or not 
    if ! user_exists "$user"; then 
        echo "User Doesn't Exists so it cannot be deleted"
        log_action "User $user doesn't Exist."
        return 1
    fi

    echo -e "Usage -\n1.Change Username\n2.Change Home Directory\n3.Modify Password"
    read -p "Enter your choice: " input
    case $input in
        1)
            change_username "$user"
            ;;
        2)
            change_directory "$user"
            ;;
        3)
            modify_password "$user"
            ;;
        *)
            echo "Invalid Choice"
            ;;
    esac
}

while getopts "cdmla" opts; do 
    case $opts in 
        l)
            echo "List All Users: "
            echo $(list_user)
            ;;
        c)
            user_creation
            ;;
        d)
            user_deletion
            ;;
        m)
            user_modification 
            ;;
        a)
            add_user_to_group
            ;;
        *)
            usage
            ;;
    esac
done