#!/usr/bin/env bash

# Set your API key here
PERPLEXITY_API="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"

if [ "$#" -eq 0 ]; then
    echo "Usage: $(basename $0) prompt_to_send_to_perplexity"
    exit 1
fi

function p() {
    local json_request
    json_request=$(jq -n \
        --arg content "$*" \
        '{
            "model": "llama-3.1-sonar-small-128k-online",
            "messages": [
                {"role": "system", "content": "Be precise and concise."},
                {"role": "user", "content": $content}
            ],
            "stream": false
        }')

    local json_response
    json_response=$(curl --silent \
        --request POST \
        --url https://api.perplexity.ai/chat/completions \
        --header 'accept: application/json' \
        --header "authorization: Bearer $PERPLEXITY_API" \
        --header 'content-type: application/json' \
        --data "$json_request")

    echo "$json_response" | jq '.choices[0].message.content'
}

p "$@"
