#!/bin/bash

# Function to check for patterns in URLs from Wayback Machine and filter by status code
check_patterns_in_urls() {
    local url=$1
    local patterns_file="patterns.txt"

    echo "Checking $url..."

    # Fetch URLs from Wayback Machine
    waybackurls "$url" | while read -r wayback_url; do
        # Check if URL contains any pattern
        while IFS= read -r pattern; do
            if echo "$wayback_url" | grep -qi "$pattern"; then
                # Fetch the HTTP status code of the URL
                status_code=$(curl -o /dev/null -s -w "%{http_code}" "$wayback_url")
                if [[ $status_code -eq 200 || $status_code -eq 403 ]]; then
                    echo "$wayback_url ($status_code)"
                fi
                break
            fi
        done < "$patterns_file"
    done
}

# File containing the list of URLs
url_file="scope.txt"

# Check if files exist
if [[ ! -f $url_file || ! -f "patterns.txt" ]]; then
    echo "Error: Required file(s) not found."
    exit 1
fi

# Loop through each URL in the file and check for the patterns
while IFS= read -r url; do
    check_patterns_in_urls "$url"
done < "$url_file"

