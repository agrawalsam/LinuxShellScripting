#!/bin/bash

directory=""
compression=""
s3_location=""
archived_file_name=""

log_file='/var/log/user_management.log'

log_action(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $log_file >/dev/null
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

if [ -z "$directory" ]; then 
    echo "Directory Argument was not provided."
    exit 1
fi

if [ -z "$compression" ]; then 
    echo "Compression Argument was not provided."
    exit 1
fi

# check whether a directory exists or not and then check whether it is valid or not. 
if ! [ -d "$directory" ] || ! [ -r "$directory" ]; then 
    echo "Directory $directory doesnot exists or Directory $directory is not readable."
    log_action "Directory $directory doesnot exists or Directory $directory is not readable."
    exit 1
fi

# writes action into log. 
log_action "Directory $directory exists and is readable."

# check whether the compress mode is either zip or tar. 
if ! [ $compression == "zip" ] && ! [ $compression == "tar" ]; then 
    echo "$compression is not zip and tar"
    log_action "$compression is not zip and tar"
    exit 1
fi 

timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
archived_file_name="backup-${timestamp}-${directory}.$compression"

if [ $compression == "zip" ]; then 
    # using zip command to zip directory
    zip -r ${archived_file_name} ${directory}
elif [ $compression == "tar" ]; then 
    # using tar command to tar directory
    tar cf ${archived_file_name} ${directory}
fi 

if [[ $? -ne 0 ]]; then 
    log_action "Compression Failed for directory ${directory}"
    exit 1
fi         

# writes action into log. 
log_action "Compression for directory ${directory} Successful: ${archived_file_name}"

# Check the given S3 location should be non empty 
# Check the given S3 location should start with s3://
if [ -n "$s3_location" ] && echo $s3_location | grep -q "^s3://" ; then 
    echo "S3 Location $s3_location is provided in the arguments."
    # Now write the archived file into S3. 
    aws s3 cp ${archived_file_name} ${s3_location}
fi
