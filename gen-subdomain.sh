#!/usr/bin/env bash

# Function to display usage and banner
display_usage() {
    echo "+-+-+-+-+-+-+-+-+-+-+-+-+-+"
    echo " |G|e|n|-|S|u|b|d|o|m|a|i|n|"
    echo " +-+-+-+-+-+-+-+-+-+-+-+-+-+"
    echo " |b|y| |H|a|d|e|s|          "
    echo " +-+-+ +-+-+-+-+-+   "
    echo ""
    echo "Usage:"
    echo "  $0 [OPTIONS]"
    echo ""
    echo "Example:"
    echo "  $0 -d example.com -s subdomains.txt -o full_subdomains.txt -r resolvers.txt -w result.txt"
    echo ""
    echo "Options:"
    echo "  -d <domain>         Set the main domain (e.g., example.com)"
    echo "  -s <subdomains.txt> Path to the wordlist-subdomain list file (e.g., subdomains.txt)"
    echo "  -o <output.txt>     Output file for full subdomains"
    echo "  -r <resolvers.txt>  Path to the resolver file (e.g., resolvers.txt)"
    echo "  -w <result.txt>     Output file for results (e.g., result.txt)"
    echo ""
}

# If no arguments are provided, show usage and exit
if [ $# -eq 0 ]; then
    display_usage
    exit 1
fi

# Check if massdns is installed
if ! command -v massdns &> /dev/null; then
    echo "[ERROR] massdns is not installed. Installing now..."
    # Install massdns
    # On Ubuntu/Debian-based systems
    if [ -x "$(command -v apt)" ]; then
        sudo apt update && sudo apt install -y massdns
    # On RedHat/CentOS/Fedora-based systems
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y massdns
    # On macOS (using Homebrew)
    elif [ -x "$(command -v brew)" ]; then
        brew install massdns
    else
        echo "[ERROR] Unsupported operating system. Please install massdns manually."
        exit 1
    fi
    if ! command -v massdns &> /dev/null; then
        echo "[ERROR] Failed to install massdns. Exiting..."
        exit 1
    else
        echo "[SUCCESS] massdns installed successfully."
    fi
fi

# Parsing arguments
while getopts ":d:s:o:r:w:" opt; do
  case $opt in
    d) domain=$OPTARG ;;    # Main domain
    s) subdomain_file=$OPTARG ;; # Subdomain list file
    o) output_file=$OPTARG ;; # Output file
    r) resolver_file=$OPTARG ;; # Resolver file for massdns
    w) result_file=$OPTARG ;; # Result output file for massdns
    *) display_usage; exit 1 ;;  # Invalid option
  esac
done

# Check if all required parameters are provided
if [[ -z "${domain// }" || -z "${subdomain_file// }" || -z "${output_file// }" || -z "${resolver_file// }" || -z "${result_file// }" ]]; then
    echo "[ERROR] All options are required. Please refer to the usage instructions."
    display_usage
    exit 1
fi

# Check if the subdomain file exists
if [[ ! -f "$subdomain_file" ]]; then
    echo "[ERROR] Subdomain wordlist file '$subdomain_file' not found!"
    exit 1
fi

# Check if the resolver file exists
if [[ ! -f "$resolver_file" ]]; then
    echo "[ERROR] Resolver file '$resolver_file' not found!"
    exit 1
fi

# Generate full subdomains list
while read -r subdomain; do
    echo "$subdomain.$domain" >> "$output_file"
done < "$subdomain_file"

echo "[SUCCESS] Subdomains saved to '$output_file'"

# Run massdns
massdns -r "$resolver_file" -q -t A -o S -w "$result_file" "$output_file"

# Filter and sort the results
awk -F ". " '{print $1}' "$result_file" | sort -u > filtered.txt

echo "[SUCCESS] MassDNS output saved to '$result_file' and filtered.txt"
