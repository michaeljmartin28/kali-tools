#!/bin/bash

# Define ANSI escape sequences for colors
BOLD='\e[1m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'

# Function to print verbose messages
function verbose() {
    if [ "$verbose" = true ]; then
        echo -e "$1"
    fi
}

# Function to decode Base64 string
function decode_base64() {
    local input="$1"
    local decoded
    if decoded=$(echo "$input" | base64 --decode 2>/dev/null); then
        echo -n "$decoded"
    else
        verbose "${RED}Failed to decode: $input${RESET}"
    fi
}

# Function to calculate MD5 checksum
function calculate_md5() {
    local filePath="$1"
    md5sum "$filePath" | awk '{print $1}'
}

# Parse command-line arguments using getopts
verbose=false
while getopts ":f:vo:" opt; do
    case $opt in
        f) filePath="$OPTARG" ;;
        v) verbose=true ;;
        o) outfile="$OPTARG" ;;
        \?) echo -e "${RED}Invalid option: -$OPTARG${RESET}" >&2; exit 1 ;;
        :) echo -e "${RED}Option -$OPTARG requires an argument.${RESET}" >&2; exit 1 ;;
    esac
done

if [ -z "$filePath" ]; then
    echo -e "${YELLOW}Usage: $0 -f <filePath> [-v] [-o <outfilePath>]${RESET}"
    exit 1
fi

verbose "${CYAN}Reading file: $filePath${RESET}"

# Read the file content
file_content=$(<"$filePath")

verbose "${GREEN}File content read successfully.${RESET}"

# Split the content by empty lines
IFS=''
elements=()
# read each line
while IFS= read -r line; do
    # if the line is empty, and the buffer contains data, add the buffered line to the array.
    if [[ -z "$line" && ${#buffer[@]} -gt 0 ]]; then
        elements+=("$(IFS=$'\n'; echo "${buffer[*]}")")
        buffer=()
    else
        # Read in the line
        buffer+=("$line")
    fi
done <<< "$file_content"
# Add last line
[ ${#buffer[@]} -gt 0 ] && elements+=("$(IFS=$'\n'; echo "${buffer[*]}")")

length=${#elements[@]}

verbose "${GREEN}File content split into elements.${RESET}"

# Base64 decode each element
index=1
data=""
for element in "${elements[@]}"; do
    decoded_text=$(decode_base64 "$element")
    data+="$decoded_text"
    verbose "${GREEN}Partition $index decoded successfully.${RESET}"

    # Append decoded text to the outfile if provided
    if [ -n "$outfile" ]; then
        echo -n "$decoded_text" >> "$outfile"
        verbose "${GREEN}Partition $index appended to outfile: $outfile${RESET}"
    fi

    ((index++))
done
data+="\n"

md5Input=$(calculate_md5 $filePath)
md5Output=$(calculate_md5 $outfile)

echo -e "${MAGENTA}--------------------------------------------${RESET}"
echo -e "${MAGENTA}    Finished decoding $length partitions.${RESET}"
echo -e "    MD5 checksum of the input file: ${YELLOW}${md5Input}${RESET}"
echo -e "    MD5 checksum of the output:     ${YELLOW}${md5Output}${RESET}"

if [ -n "$outfile" ]; then
    # Append a newline to the end of the file
    echo "" >> "$outfile"
    echo -e "${MAGENTA}    Data written to: $outfile${RESET}"
    echo -e "${MAGENTA}--------------------------------------------${RESET}"
else
    echo -e "${MAGENTA}--------------------------------------------${RESET}"
    echo -e "$data"
fi

