#!/bin/bash
source ./opertions.sh  #calling operations.sh

src_file="/root/demo.txt"   #source file for copy_file_to_bucket function
dest_file1="dest1/demo.txt" #destination file for copy_file_to_bucket function
dest_file2="dest2/demo.txt" #destination file for copy_item_in_bucket function

echo "Enter the bucket name"
read -r bucket_name         #taking input from user(name)
echo "Enter the region"
read -r region              #taking input from user(region)

echo "#############################################################################"
echo "Running bucket_exists function"
bucket_exists "$bucket_name"    #calling bucket_exists function
echo "$?"                       #printing the return value
echo "End of bucket_exists function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running create_bucket function"
create_bucket "$bucket_name" "$region"  #calling create_bucket function
echo "$?"                               #printing the return value
echo "End of create_bucket function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running copy_file_to_bucket function"
copy_file_to_bucket "$bucket_name" "$src_file" "$dest_file1" 
echo "$?"                       #printing the return value               
echo "End of copy_file_to_bucket function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running copy_item_in_bucket function"
copy_item_in_bucket "$bucket_name" "$bucket_name/$dest_file1" "$dest_file2"
echo "$?"                       #printing the return value
echo "End of copy_item_in_bucket function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running list_items_in_bucket function"
list_items_in_bucket "$bucket_name"     #list items function
echo "$?"                               #printing the return value
echo "End of list_items_in_bucket function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running delete_item_in_bucket function"
delete_item_in_bucket "$bucket_name" "$dest_file1"  #delete dest_file1
delete_item_in_bucket "$bucket_name" "$dest_file2"  #delete dest_file2
echo "$?"                                           #printing the return value
echo "End of delete_item_in_bucket function"
echo "#############################################################################"
echo ""

echo "#############################################################################"
echo "Running delete_bucket function"
delete_bucket "$bucket_name"    #calling the delete_bucket function
echo "$?"                       #printing the return value
echo "End of delete_bucket function"
echo "#############################################################################"
