#!/bin/bash

create_index_md() {
    local DIR="$1"
    local TITLE="$2"

    echo "+++" > "${DIR}/_index.md"
    echo "title = \"${TITLE}\"" >> "${DIR}/_index.md"
    echo "+++" >> "${DIR}/_index.md"
}

# Check if a token is provided
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: $0 <Your GitHub personal access token> <Your OpenAI API Key>"
    exit 1
fi

TOKEN="$1"
API_KEY="$2"

API_URL="https://api.openai.com/v1/chat/completions"  # Updated the URL

# Variables
OWNER="fedimint"
REPO="fedimint"

# Ensure the "content" directory exists and create _index.md
mkdir -p "content"
create_index_md "content" "Content Overview"

# Get dates for macOS `date` command
START_DATE=$(date -v-7d +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)

# New base directory based on the date range
BASE_DIR="content/${START_DATE}_to_${END_DATE}"
mkdir -p "$BASE_DIR"
create_index_md "$BASE_DIR" "Issues from ${START_DATE} to ${END_DATE}"

# Function to process issues (either open or closed)
process_issues() {
    local STATE="$1"
    FOLDER_NAME="${BASE_DIR}/issues/${STATE}"
    mkdir -p "$FOLDER_NAME"
    
    create_index_md "$FOLDER_NAME" "List of ${STATE} Issues"
 
    TOC_FILE="${FOLDER_NAME}/TOC.md"
    echo "# Table of Contents for ${STATE} Issues from ${START_DATE} to ${END_DATE}" > "$TOC_FILE"
    echo "" >> "$TOC_FILE"
    
    # Extract only those issues which match the given state
    ISSUE_ENTRIES=$(echo "$RESPONSE" | jq -c ".[] | select(.state == \"$STATE\" and (.created_at > \"$(date -v-7d -u +"%Y-%m-%dT%H:%M:%SZ")\" or .updated_at > \"$(date -v-7d -u +"%Y-%m-%dT%H:%M:%SZ")\"))")
    
    # Process each Issue
    while IFS= read -r line; do
        ISSUE_NUM=$(echo "$line" | jq -r '.number')
        ISSUE_TITLE=$(echo "$line" | jq -r '.title')
        ISSUE_DESC=$(echo "$line" | jq -r '.body')
        ISSUE_LINK=$(echo "$line" | jq -r '.html_url')
        ISSUE_FILE_NAME="ISSUE_${ISSUE_NUM}.md"
        OUTFILE="${FOLDER_NAME}/${ISSUE_FILE_NAME}"
        
        # Fetch and dump comments
        COMMENTS=$(curl -s -H "Authorization: token $TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/$OWNER/$REPO/issues/$ISSUE_NUM/comments" | \
        jq -r '.[] | select(.user.login != "codecov[bot]") | "- **" + .user.login + ":** " + .body')
        
        if [[ -z "$COMMENTS" ]]; then
            TEXT_TO_SUMMARIZE="$ISSUE_DESC"
        else
            TEXT_TO_SUMMARIZE="${ISSUE_DESC}\n${COMMENTS}"
        fi

        TEXT_TO_SUMMARIZE=$(echo "$TEXT_TO_SUMMARIZE" | sed 's/"/\\"/g')
        JSON_SAFE_TEXT=$(echo "$TEXT_TO_SUMMARIZE" | jq -Rs .)
        ESCAPED_TEXT=$(echo "$JSON_SAFE_TEXT" | sed 's/"/\\"/g')

        # Construct the JSON payload
        PAYLOAD=$(cat <<EOF
{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "Summarize the following text: $ESCAPED_TEXT"}],
    "temperature": 0.7
}
EOF
)
        # Make the API request
        API_RESPONSE=$(curl -s \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$PAYLOAD" \
        "$API_URL")

        # Extract summary from the response
        SUMMARY=$(echo "$API_RESPONSE" | jq -r '.choices[0].message.content')

        # Continue with the rest of the details
        echo "## SUMMARY" > "$OUTFILE"
        echo "- **Issue #${ISSUE_NUM}:** [$ISSUE_TITLE]($ISSUE_LINK)" >> "$OUTFILE"
        echo "" >> "$OUTFILE"

        # Start the Markdown file with the GPT Summary
        echo "### GPT SUMMARY:" >> "$OUTFILE"
        echo "$SUMMARY" >> "$OUTFILE"
        echo "" >> "$OUTFILE"
        
        # Detailed Information
        echo "## DETAILS" >> "$OUTFILE"
        echo "### Description:" >> "$OUTFILE"
        echo "$ISSUE_DESC" >> "$OUTFILE"
        echo "" >> "$OUTFILE"
        
        echo "### Comments:" >> "$OUTFILE"
        if [[ -z "$COMMENTS" ]]; then
            echo "No comments for this issue." >> "$OUTFILE"
        else
            echo "$COMMENTS" >> "$OUTFILE"
        fi
        echo "" >> "$OUTFILE"

        # Add to Table of Contents
        echo "- [Issue #${ISSUE_NUM}: ${ISSUE_TITLE}](${ISSUE_FILE_NAME}) - [View on GitHub](${ISSUE_LINK})" >> "$TOC_FILE"

    done <<< "$ISSUE_ENTRIES"

    echo "Finished dumping ${STATE} Issue details to $FOLDER_NAME in Markdown format and created Table of Contents."
}

# Fetch all issues that were created or updated in the last 7 days
RESPONSE=$(curl -s -H "Authorization: token $TOKEN" \
          -H "Accept: application/vnd.github.v3+json" \
          "https://api.github.com/repos/$OWNER/$REPO/issues?state=all")

# Process open and closed issues separately
process_issues "open"
process_issues "closed"