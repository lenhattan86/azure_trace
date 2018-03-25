#!/bin/bash
download_links="AzurePublicDatasetLinks.txt"
folder="dataset"

mkdir $folder
cd $folder

while read line; do    
    url="$line"
    echo $url
    strLen=$(expr ${#url} - 1)
    url=${url:0:strLen}
    echo $url    
    wget "$url"        
done < ../$download_links

cd ..