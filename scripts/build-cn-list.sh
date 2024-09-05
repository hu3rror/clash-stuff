#!/bin/sh
download_cn_list() {
    # Enable immediate exit if any command fails
    set -e

    # Define the URLs for the fake IP filter list and the BT tracker list
    domestic_list="https://ruleset.skk.moe/Clash/non_ip/domestic.txt"

    # Define the output file path
    cn_txt_file="./dnsmasq-skk-cn.txt"

    echo "Now updating domestic list..."
    curl -SsL --connect-timeout 30 --retry 3 --retry-delay 8 "$domestic_list" \
        | grep -v -E '^#|^PROCESS-|^DOMAIN,this_ruleset' | awk -F'[,]' '{print $2}' | sed 's/^/server=\//' | sed 's/$/\/114.114.114.114/' > "$cn_txt_file"

    # Disable immediate exit if any command fails
    set +e
}

download_cn_list