# Generate-Subdomain
A simple and efficient Bash script for subdomain enumeration. This tool takes a list of subdomains and a main domain, combines them to generate a list of potential subdomains, and uses massdns to resolve and filter valid subdomains. It supports the use of custom DNS resolvers for large-scale subdomain scanning.

![image](https://github.com/user-attachments/assets/eef644a9-d87a-4944-be96-5ad2aa34a87b)

# Features:
Generate subdomains from a provided wordlist and main domain.Resolve subdomains using custom DNS resolvers.Filter and sort valid subdomains into a clean output.

# Usage:
  `./gen-subdo.sh -d example.com -s subdomains.txt -o full_subdomains.txt -r resolvers.txt -w result.txt`

# Options:
> -d <domain>: Main domain (e.g., example.com)

> -s <subdomains.txt>: Wordlist of subdomains to test (e.g., subdomains.txt)

> -o <output.txt>: Output file for full subdomain list

> -r <resolvers.txt>: File containing DNS resolvers

> -w <result.txt>: Output file for resolved subdomains

# Requirements:
*massdns: A fast DNS resolver for high-performance subdomain enumeration.*
