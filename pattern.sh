#!/bin/bash

# Initialize default values for files
output_file="results.txt"
patterns_file="patterns.txt"
url_file="scope.txt"

# Parse command-line options
while getopts "o:p:u:" opt; do
    case ${opt} in
        o ) output_file=$OPTARG ;;
        p ) patterns_file=$OPTARG ;;
        u ) url_file=$OPTARG ;;
        \? ) echo "Usage: cmd [-o output_file] [-p patterns_file] [-u url_file]" >&2
             exit 1 ;;
    esac
done
shift $((OPTIND -1))

# Clear the output file at the start
> "$output_file"

# Function to check for patterns in URLs from Wayback Machine and filter by status code
check_patterns_in_urls() {
    local url=$1

    echo "Checking $url..."

    # Fetch URLs from Wayback Machine
    waybackurls "$url" | while read -r wayback_url; do
        # Check if URL contains any pattern
        while IFS= read -r pattern; do
            if echo "$wayback_url" | grep -qi "$pattern"; then
                # Fetch the HTTP status code of the URL
                status_code=$(curl -o /dev/null -s -w "%{http_code}" "$wayback_url")
                if [[ $status_code -eq 200 || $status_code -eq 403 ]]; then
                    # Output to both console and file
                    echo "$wayback_url ($status_code)" | tee -a "$output_file"
                fi
                break
            fi
        done < "$patterns_file"
    done
}

# Check if files exist
if [[ ! -f $url_file || ! -f $patterns_file ]]; then
    echo "Error: Required file(s) not found."
    exit 1
fi

# Loop through each URL in the file and check for the patterns
while IFS= read -r url; do
    check_patterns_in_urls "$url"
done < "$url_file"
