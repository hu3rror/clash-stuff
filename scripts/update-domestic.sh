#!/bin/bash
set -e

# URL of the domestic.ts file
DOMESTIC_TS_URL="https://raw.githubusercontent.com/SukkaW/Surge/master/Source/non_ip/domestic.ts"

# Download the domestic.ts file
echo "Downloading domestic.ts file..."
if curl -s -o domestic.ts "$DOMESTIC_TS_URL"; then
    echo "domestic.ts file downloaded successfully."
else
    echo "Failed to download domestic.ts file. Please check your internet connection and the URL."
    exit 1
fi

# Function to extract domains for a given company
extract_domains() {
    company=$1
    output_file=$(echo "${company,,}_domainset.txt")  # Convert to lowercase and add _domainset.txt
    awk -v company="$company" '
        $0 ~ company ": {" {
            in_company = 1
            next
        }
        in_company && $0 ~ /domains: \[/ {
            in_domains = 1
            next
        }
        in_domains && $0 ~ /\]/ {
            in_domains = 0
            in_company = 0
            next
        }
        in_domains {
            gsub(/^[ \t]+|[ \t]+$/, "")  # Trim whitespace
            sub(/\/\/.*$/, "")  # Remove comments
            gsub(/[ \t]+$/, "")  # Trim trailing whitespace after removing comments
            gsub(/^["\x27]|["\x27],?$/, "")  # Remove quotes and optional comma at the end
            if (length($0) > 0) {
                print "+." $0
            }
        }
    ' domestic.ts > "$output_file"
}

# Extract domains for each company
extract_domains "ALIBABA"
extract_domains "TENCENT"
extract_domains "BILIBILI_ALI"
extract_domains "BILIBILI_BD"
extract_domains "BILIBILI"
extract_domains "XIAOMI"
extract_domains "BYTEDANCE"
extract_domains "BAIDU"
extract_domains "QIHOO360"

echo "Domain extraction complete. Check the generated _domainset.txt files."

# Clean up: remove the downloaded domestic.ts file
rm domestic.ts

echo "Cleaned up temporary files."