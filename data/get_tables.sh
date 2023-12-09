#!/bin/bash

# Create the extracted_tables folder if it doesn't exist
mkdir -p extracted_tables

# Iterate over each file in the pages directory
for file in pages/*; do
    # Check if the item is a file (not a directory)
    if [ -f "$file" ]; then
        # Extract the file name without the path and extension
        filename=$(basename "$file" .html)
        
        # Run your Perl script on each file and redirect the output to a new HTML file in the extracted_tables folder
        perl not_my_scripts/extract_results.pl "$file" > "extracted_tables/${filename}.html"
    fi
done
