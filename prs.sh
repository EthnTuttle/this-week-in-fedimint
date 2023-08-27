#!/bin/bash

# Check if a token is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <Your GitHub personal access token>"
    exit 1
fi

TOKEN="$1"

API_KEY=""
API_URL="https://api.openai.com/v1/engines/text-davinci-004/completions"

# Variables
OWNER="fedimint"
REPO="fedimint"

# Ensure the "prs" directory exists
mkdir -p "prs"

# Get dates for macOS `date` command
START_DATE=$(date -v-7d +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
FOLDER_NAME="prs/${START_DATE}_to_${END_DATE}"

# Create directory for the date range
mkdir -p "$FOLDER_NAME"

# Start the Table of Contents file
TOC_FILE="${FOLDER_NAME}/TOC.md"
echo "# Table of Contents for PRs from ${START_DATE} to ${END_DATE}" > $TOC_FILE
echo "" >> $TOC_FILE

# Fetch pull request URLs that were created in the last 7 days
RESPONSE=$(curl -s -H "Authorization: token $TOKEN" \
          -H "Accept: application/vnd.github.v3+json" \
          "https://api.github.com/repos/$OWNER/$REPO/pulls?state=all")

PR_ENTRIES=$(echo "$RESPONSE" | jq -c '.[] | select(.created_at > "'$(date -v-7d -u +"%Y-%m-%dT%H:%M:%SZ")'") | {diff_url: .diff_url, number: .number, title: .title, body: .body, html_url: .html_url}')

# Process each PR
while IFS= read -r line; do
    PR_NUM=$(echo "$line" | jq -r '.number')
    PR_TITLE=$(echo "$line" | jq -r '.title')
    PR_DESC=$(echo "$line" | jq -r '.body')
    PR_LINK=$(echo "$line" | jq -r '.html_url')
    PR_FILE_NAME="PR_${PR_NUM}.md"
    OUTFILE="${FOLDER_NAME}/${PR_FILE_NAME}"
    
    # Add to Table of Contents
    echo "- [PR #${PR_NUM}: ${PR_TITLE}](${PR_FILE_NAME}) - [View on GitHub](${PR_LINK})" >> $TOC_FILE
    
    # Markdown Summary
    echo "## SUMMARY" > $OUTFILE
    echo "- **PR #${PR_NUM}:** [$PR_TITLE]($PR_LINK)" >> $OUTFILE
    echo "" >> $OUTFILE

    # Detailed Information
    echo "## DETAILS" >> $OUTFILE
    echo "### Description:" >> $OUTFILE
    echo "$PR_DESC" >> $OUTFILE
    echo "" >> $OUTFILE
    
    # Fetch and dump comments
    echo "### Comments:" >> $OUTFILE
    COMMENTS=$(curl -s -H "Authorization: token $TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "https://api.github.com/repos/$OWNER/$REPO/issues/$PR_NUM/comments" | \
    jq -r '.[] | "- **" + .user.login + ":** " + .body')
    
    TEXT_TO_SUMMARIZE=$(<"$PR_DESC")
    if [[ -z "$COMMENTS" ]]; then
        echo "No comments for this PR." >> $OUTFILE
    else
        TEXT_TO_SUMMARIZE=$(<<"$COMMENTS")
        echo "$COMMENTS" >> $OUTFILE
    fi


    # Construct the JSON payload
    PAYLOAD=$(cat <<EOF
    {
        "prompt": "Summarize the following text: \"$TEXT_TO_SUMMARIZE\"",
        "max_tokens": 150
    }
EOF
)
    # Make the API request
    SUMMARY=$(curl -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "$PAYLOAD" \
    "$API_URL" | jq -r .choices[0].text)

    echo "GPT SUMMARY:" >> $OUTFILE
    echo $SUMMARY >> $OUTFILE
    
    echo "" >> $OUTFILE

done <<< "$PR_ENTRIES"

echo "Finished dumping PR details to $FOLDER_NAME in Markdown format and created Table of Contents."
