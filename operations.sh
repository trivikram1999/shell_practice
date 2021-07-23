#!/bin/bash
function bucket_exists()              
{
    bucket_name=$1                    #bucket name is captured

    #cmd to check if bucket exists
    BUCKET_EXISTS=$(aws s3api head-bucket --bucket "$bucket_name" 2>&1 || true)
    if [ -z "$BUCKET_EXISTS" ]; then  #if no error message then bucket exists
        echo "Bucket exists"
        return 0
    else
        echo "Bucket does not exist"              #else bucket does not exist
        return 1
    fi
}



function create_bucket()       
{
    bucket_name=$1             #bucket name is captured
    region=$2                  #region is captured

    if [[ -z "$bucket_name" ]]; then        #check whether bucket name is provided
        echo "ERROR: You must provide a bucket name."
        return 1
    fi

    if [[ -z "$region" ]]; then             #check whether region name is provided
        echo "ERROR: You must provide an AWS Region code."
        return 1
    fi

    bucket_exists "$bucket_name"            #call bucket_exists function
    if [[ $? == 0 ]]; then                  #if no error message then bucket exists
        echo "The bucket already exists"
        echo "aborting create_bucket()..."
        return 1
    else
        echo "Creating a bucket..."
        echo "Data Provided is:"
        echo "Bucket_name= $bucket_name"
        echo "Region= $region"
        RESPONSE=$(aws s3api create-bucket \
                --bucket "$bucket_name" \
                --create-bucket-configuration LocationConstraint="$region") #creating bucket

        if [[ $? != 0 ]]; then          #if error return 1
            echo "ERROR: AWS reports create-bucket operation failed."
            echo "$RESPONSE"
            return 1
        else 
            echo "$RESPONSE"        #print the url
            return 0
        fi
    fi              
}



function copy_file_to_bucket()
{
    bucket_name=$1          #name of the bucket
    source_file=$2          #file with the location in local
    dest_filename=$3        #file name with location to be saved in the bucket

    RESPONSE=$(aws s3api put-object \
                --bucket "$bucket_name" \
                --body "$source_file" \
                --key "$dest_filename")         #command to copy file to bucket
    
    if [[ ${?} -ne 0 ]]; then       #if any error returning 1
        echo "ERROR: AWS reports put-object operation failed.\n$RESPONSE"
        return 1
    else
        echo "$RESPONSE"        #no error returning 0
        return 0            
    fi
}



function copy_item_in_bucket()
{
    bucket_name=$1              #name of the bucket
    source_file=$2              #source file with the location in the bucket
    dest_file=$3                #dest name with the location in the bucket

    RESPONSE=$(aws s3api copy-object \
                --bucket "$bucket_name" \
                --copy-source "$source_file" \
                --key "$dest_file")             #command to copy files within the bucket
    
    if [[ ${?} -ne 0 ]]; then       #if any error returning 1
        echo "ERROR: AWS reports put-object operation failed.\n$RESPONSE"
        return 1
    else
        echo "$RESPONSE"        #no error returning 0
        return 0            
    fi
}



function list_items_in_bucket()
{
    bucket_name=$1              #name of the bucket

    RESPONSE=$(aws s3api list-objects \
                --bucket "$bucket_name" \
                --output text \
                --query 'Contents[].{Key: Key, Size: Size}' )   
                                            #command to list items along with size
    if [[ ${?} -eq 0 ]]; then
        echo "$RESPONSE"            #no error returning 0
        return 0
    else
        echo "ERROR: AWS reports s3api list-objects operation failed.\n$RESPONSE"
        return 1                         #if any error returning 1
    fi
}



function delete_item_in_bucket()
{
    bucket_name=$1              #name of the bucket
    key=$2                      #the file name in the bucket to delete
        
    RESPONSE=$(aws s3api delete-object \
                --bucket "$bucket_name" \
                --key "$key")           #command to delete items in bucket

    if [[ $? -ne 0 ]]; then
        echo "ERROR:  tAWS reports s3api delete-object operation failed.\n$RESPONSE"
        return 1                #if any error returning 1
    else
        echo "Object deleted"        #no error returning 0
        return 0            
    fi
}



function delete_bucket()
{
    bucket_name=$1              #name of the bucket

    RESPONSE=$(aws s3api delete-bucket \
                --bucket "$bucket_name")        #command to delete the bucket

    if [[ $? -ne 0 ]]; then
        echo "ERROR: AWS reports s3api delete-bucket failed.\n$RESPONSE"
        return 1                #if any error returning 1
    else
        echo "Bucket deleted"        #no error returning 0
        return 0            
    fi
}
