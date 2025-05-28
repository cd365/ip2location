#!/bin/bash

# current script directory
script_dir=$(dirname "${0}")

# ip2location download token
token=${1}
# ip2location database code
database_code=DB11LITEBINIPV6
# output filename
output_filename=a.zip

cd "${script_dir}"

# If the file does not exist, compile go download code.
if ! test -f download.out ; then
    go build -o download.out download.go
fi

# Build dynamic download command.
if test -f ${output_filename} ; then
    rm -f ${output_filename}
fi
download_cmd="${script_dir}/download.out -f ${database_code} -t ${token} -o ${output_filename}"

# THIS FILE CAN ONLY BE DOWNLOADED 5 TIMES WITHIN 24 HOURS --> https://lite.ip2location.com/database-download
# Execute dynamically generated download command.
eval "${download_cmd}"

unzip -o ${output_filename} -d .
file=IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2
file1="${file}.1"
if test -f "${file}" ; then
    rm -f "${file}"
fi
tar -jcvf "${file}" IP2LOCATION-LITE-DB11.IPV6.BIN LICENSE_LITE.TXT README_LITE.TXT
rm -f IP2LOCATION-LITE-DB11.IPV6.BIN LICENSE_LITE.TXT README_LITE.TXT

if test -f "${file1}" ; then
    hash=$(sha256sum "${file}" | awk '{print $1}')
    hash1=$(sha256sum "${file1}" | awk '{print $1}')
    if [ "${hash}" == "${hash1}" ]; then
        git checkout .
        exit
    fi
fi

git add *.tar.bz2
git commit -m "Update IP database"
git push origin master

# Keep 7 copies of historical data.
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

cp IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2 IP2LOCATION-LITE-DB11.IPV6.BIN.tar.bz2.1

