#!/bin/bash

idx=1

(
    for file in extracted_tables/*; do
        if [ $idx -gt 1 ]; then
            temp/db/data/extract_results.pl "$file" |
                temp/db/data/parse_results.pl "$file" 2>/dev/null |
                tail -n +2
        else
            temp/db/data/extract_results.pl "$file" |
                temp/db/data/parse_results.pl "$file" 2>/dev/null
        fi

        idx=$((idx + 1))
    done
) >results_in_generated.csv
