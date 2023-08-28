#!/bin/bash

# Check if both arguments are provided
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: $0 <Your GitHub personal access token> <Your OpenAI API Key>"
    exit 1
fi

TOKEN="$1"
API_KEY="$2"

./issues.sh "$TOKEN" "$API_KEY"
./prs.sh "$TOKEN" "$API_KEY"
