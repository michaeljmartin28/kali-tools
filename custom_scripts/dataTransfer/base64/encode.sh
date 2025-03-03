#!/bin/bash

# Function to print usage information
function usage() {
    echo -e "This program takes a file and encodes it into several base64 encoded strings in a single file."
    echo -e "It can also format the output file as a Ducky Script for use with a Rubber Ducker of Bash Bunny.\n"
    echo -e "Usage: $0 -f <filePath> -p <partitions> [-o <outfilePath>] [-n] [-d]"
    echo -e "  -f <filePath>      : Path to the input file to encode (required)"
    echo -e "  -p <partitions>     : The number of partitions to use."
    echo -e "  -o <outfilePath>   : Path to the output file (optional)"
    echo -e "  -n                  : Removes the column spacing for Base64 Encoding. Similar to 'base64 -w 0' (optional)"
    echo -e "  -d                  : Format output file as a Ducky Script. (optional)"
    echo -e "  -h                  : Display this help menu."
    exit 1
}

# Function to calculate MD5 checksum
function calculate_md5() {
    local filePath="$1"
    md5sum "$filePath" | awk '{print $1}'
}

BOLD='\e[1m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'


duckyScript="false"
keepNewLines="true"

while getopts "f:o:p:nd" opt; do
  case $opt in
    f)
      filePath="$OPTARG"
      ;;
    o)
      outfile="$OPTARG"
      ;;
    p)
      PARTITIONS="$OPTARG"
      ;;
    n)
      keepNewLines="false"
      ;;
    d)
      duckyScript="true"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "$filePath" ]; then
    echo -e "${YELLOW}An input file is required.${RESET}"
    usage
    exit 1
fi

if [ -z "$PARTITIONS" ]; then
    echo -e "${YELLOW}Choose a number of partitions to use.${RESET}"
    usage
    exit 1
fi

shift $((OPTIND - 1))
echo -e "${BOLD}${BLUE}-----------------------------------\nArguments${RESET}"
echo Infile: $filePath
echo Outfile: $outfile
echo Partitions: $PARTITIONS
echo Keep New Lines: $keepNewLines
echo Ducky Script: $duckyScript
echo -e "${BOLD}${BLUE}-----------------------------------\n${RESET}"


if [[ $outfile == "" ]]; then
    outfile=${filePath}_base64_partitions.txt
fi


if [[ "$outfile" != /* ]]; then
    outfile=$PWD"/"$outfile
fi
if [[ "$filePath" != /* ]]; then
    filePath=$PWD"/"$filePath
fi
echo -e "Using ${BOLD}${YELLOW}${outfile}${RESET} for results"

# Create temp directory
TEMP_DIR=$(mktemp -d)

# Wait for it to exist
while [[ ! -e "$TEMP_DIR" ]]; do
    sleep 0.1
done


split $filePath -n $PARTITIONS $TEMP_DIR/chunk_

WD=$PWD
cd $TEMP_DIR

index=1
for file in *; do
    if [ -f "$file" ]; then

        line=""

        echo -e "Processing file: $file (Part ${BOLD}$index${RESET} of ${BOLD}$PARTITIONS${RESET})"

        if [[ $keepNewLines == "true" ]]; then
            line+=$(base64 $file) 
        else
            line+=$(base64 -w 0 $file)
        fi

        echo -e "$line\n" >> $outfile

        ((index++))
    fi
done

if [[ $duckyScript == "true" ]]; then
    sed -i '/./s/^/DELAY 100\nSTRING &/' $outfile 
fi

rm -rf $TEMP_DIR

md5Input=$(calculate_md5 $filePath)
md5Output=$(calculate_md5 $outfile)

echo -e "MD5 checksum of the input file: ${YELLOW}${md5Input}${RESET}"
echo -e "MD5 checksum of the output:     ${YELLOW}${md5Output}${RESET}"





