import wget
from time import sleep


textFile="AzurePublicDatasetLinks_unicode.txt"

with open(textFile) as f:
    lines = f.readlines()
    for line in lines[2:]:
        url = line[0:len(line)-4]
        print(len(line))
        print(url)
        filename = wget.download(url)
        sleep(10)