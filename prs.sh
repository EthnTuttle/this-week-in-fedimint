#!/bin/bash

# Check if a token is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <Your GitHub personal access token>"
    exit 1
fi

TOKEN="$1"
# Variables
OWNER="fedimint"
REPO="fedimint"

# Get dates for macOS `date` command
START_DATE=$(date -v-7d +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
FOLDER_NAME="${START_DATE}_to_${END_DATE}"

# Create directory for the date range
mkdir -p "$FOLDER_NAME"

# Fetch pull request URLs that were created in the last 7 days
RESPONSE=$(curl -s -H "Authorization: token $TOKEN" \
          -H "Accept: application/vnd.github.v3+json" \
          "https://api.github.com/repos/$OWNER/$REPO/pulls?state=all")

PR_ENTRIES=$(echo "$RESPONSE" | jq -c '.[] | select(.created_at > "'$(date -v-7d -u +"%Y-%m-%dT%H:%M:%SZ")'") | {diff_url: .diff_url, number: .number}')

# Process each PR
while IFS= read -r line; do
    DIFF_URL=$(echo "$line" | jq -r '.diff_url')
    PR_NUM=$(echo "$line" | jq -r '.number')
    OUTFILE="${FOLDER_NAME}/PR_${PR_NUM}.txt"
    
    echo "Processing PR #$PR_NUM" > $OUTFILE
    
    # Fetch and dump comments
    echo "Comments:" >> $OUTFILE
    curl -s -H "Authorization: token $TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "https://api.github.com/repos/$OWNER/$REPO/issues/$PR_NUM/comments" | \
    jq -r '.[] | "- " + .user.login + ": " + .body' >> $OUTFILE
    echo "" >> $OUTFILE

    # Fetch and dump diffs
    echo "Fetching diff for PR #$PR_NUM"
    echo "Diffs:" >> $OUTFILE
    curl -Ls -H "Authorization: token $TOKEN" "$DIFF_URL" >> $OUTFILE
    echo "" >> $OUTFILE
done <<< "$PR_ENTRIES"

echo "Finished dumping PR details to $FOLDER_NAME"
