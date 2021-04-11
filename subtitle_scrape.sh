#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please specify a movie !!!"
    exit 1
fi

curl=$(which curl)
outfile="output.txt"
movie=$(echo $1 | tr ' ' '+')
url="http://worldsubtitle.info/?s=$movie"

function dump_webpage(){
    $curl -o $outfile $url
}

function strip_html(){
    movie=$(echo $movie | tr '+' '-')
    grep -oE 'href="([^"#]+)"' $outfile | sed 's:<a href="\(.*\)">.*</a>:\1:' | cut -f2 -d "=" > temp.txt
    url=$(grep -m 1 $movie temp.txt)
    temp="${url%\"}"
    temp="${temp#\"}"
    url=$(echo "$temp")
}

function extract_download_url(){
    grep -oE 'href="([^"#]+)"' $outfile | sed 's:<a href="\(.*\)">.*</a>:\1:' | cut -f2 -d "=" > temp.txt
    grep '.zip' temp.txt > $outfile
    grep '.rar' temp.txt >> $outfile
    cat $outfile
}

dump_webpage
strip_html
dump_webpage
extract_download_url
