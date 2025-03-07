#!/bin/bash

directory=""
compression=""
s3_location=""
archived_file_name=""

log_file="${HOME}/backup.log"

log_action(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $log_file >/dev/null
}

directory_check(){
    if [ -z "$1" ]; then 
        echo "Directory Argument was not provided."
        log_action "Directory Argument was not provided."
        exit 1
    fi

    # check whether a directory exists or not and then check whether it is valid or not. 
    if ! [ -d "$1" ] || ! [ -r "$1" ]; then 
        echo "Directory $1 doesnot exists or Directory $1 is not readable."
        log_action "Directory $1 doesnot exists or Directory $1 is not readable."
        exit 1
    fi

    # writes action into log. 
    log_action "Directory $1 exists and is readable."
}

compression_check(){
    if [ -z "$1" ]; then 
        echo "Compression Argument was not provided."
        log_action "Compression Argument was not provided."
        exit 1
    fi

    # check whether the compress mode is either zip or tar. 
    if ! [ $1 == "zip" ] && ! [ $1 == "tar" ]; then 
        echo "$1 is not zip and tar"
        log_action "$1 is not zip and tar"
        exit 1
    fi 
}

compression(){
    read -p "Enter the directory where you want the compressed backup to be stored :" input 

    # check whether the output directory exists or not. 
    directory_check $input

    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    archived_file_name="backup-${timestamp}-$1.$2"
    archived_file_name="$input/${archived_file_name}"
    
    if [ $2 == "zip" ]; then 
        # using zip command to zip directory
        zip -r ${archived_file_name} $1
    elif [ $2 == "tar" ]; then 
        # using tar command to tar directory
        tar cf ${archived_file_name} $1
    fi 

    if [[ $? -ne 0 ]]; then 
        log_action "Compression Failed for directory $1"
        exit 1
    fi         

    # writes action into log. 
    log_action "Compression for directory $1 Successful: ${archived_file_name}"
}


s3_move() {
    # Check the given S3 location should be non empty 
    # Check the given S3 location should start with s3://
    if [ -n "$s3_location" ] && echo $s3_location | grep -q "^s3://" ; then 
        log_action "S3 Location $s3_location is provided in the arguments."
    
        # Now copy the archived file into S3. 
        aws s3 cp ${archived_file_name} ${s3_location}

        # after successful copy, we can delete the backup file in server. 
        rm ${archived_file_name}
    fi
}

usage(){
    echo "Usage: $0 -[option]"
    echo ""
    echo "Options:"
    echo "  -d   Input the directory name"
    echo "  -c   Compression Method. Either Zip or Tar. Zip needs to be installed beforehand with apt install zip. "
    echo "  -s   S3 Output Location for the compressed file to save. AWS needs to be installed. apt install aws."
    echo ""
    echo "Example usage:"
    echo "  $0 -d              # /home/user/sample_log|sample_log"
    echo "  $0 -c              # zip|tar"
    echo "  $0 -s              # s3://abc/def/"    
}

while getopts "d:c:s:" opt; do 
    case $opt in 
        d)
            directory=$OPTARG
            ;;
        c)  
            compression=$OPTARG
            ;;
        s)
            s3_location=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done 

directory_check $directory

compression_check $compression

compression $directory $compression

s3_move $archived_file_name $s3_location 
