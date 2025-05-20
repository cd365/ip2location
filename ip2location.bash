#!/bin/bash

# ip2location download token
token=${1}
# ip2location database code
database_code=DB11LITEBINIPV6
# ip2location download path
download_path="https://www.ip2location.com/download/?token=${token}&file=${database_code}"

# THIS FILE CAN ONLY BE DOWNLOADED 5 TIMES WITHIN 24 HOURS
curl -o IP2LOCATION-LITE-DB11.IPV6.BIN.zip "${download_path}"
#wget -c -O IP2LOCATION-LITE-DB11.IPV6.BIN.zip "${download_path}"

unzip -o IP2LOCATION-LITE-DB11.IPV6.BIN.zip -d .
tar -jcvf IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2 IP2LOCATION-LITE-DB11.IPV6.BIN LICENSE_LITE.TXT README_LITE.TXT
rm -f IP2LOCATION-LITE-DB11.IPV6.BIN LICENSE_LITE.TXT README_LITE.TXT

git add IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2
git commit -m "Update database data in format BIN"
git push origin master

for (( i=7; i>0; i--))
do
    j=$((i+1))
    filename="IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2.${i}"
    filename_next="IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2.${j}"
    if [ ${i} -eq 7 ]; then
        if [ -f $filename ];then
            rm -f $filename
        fi
        continue
    fi
    if [ -f $filename ];then
        mv $filename $filename_next
    fi
done

mv IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2 IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2.1