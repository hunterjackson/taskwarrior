#!/bin/bash
# Dynamically determine which distros to test based on current support status

set -e

# Initialize JSON array
distros='{"include":['

# Ubuntu LTS - Only currently supported versions
# Ubuntu LTS gets 5 years standard support
# 18.04: EOL May 2023 - SKIP
# 20.04: EOL April 2025 - INCLUDE
# 22.04: EOL April 2027 - INCLUDE
# 24.04: EOL April 2029 - INCLUDE
CURRENT_YEAR=$(date +%Y)
CURRENT_MONTH=$(date +%m)

# Add Ubuntu 20.04 if still supported (until April 2025)
if [ "$CURRENT_YEAR" -lt 2025 ] || ([ "$CURRENT_YEAR" -eq 2025 ] && [ "$CURRENT_MONTH" -lt 5 ]); then
  distros+='{
    "name": "Ubuntu 20.04 (Focal)",
    "image": "ubuntu:20.04",
    "category": "ubuntu-lts"
  },'
fi

# Ubuntu 22.04 - supported until April 2027
distros+='{
  "name": "Ubuntu 22.04 (Jammy)",
  "image": "ubuntu:22.04",
  "category": "ubuntu-lts"
},'

# Ubuntu 24.04 - supported until April 2029
distros+='{
  "name": "Ubuntu 24.04 (Noble)",
  "image": "ubuntu:24.04",
  "category": "ubuntu-lts"
},'

# Debian - Current stable and oldstable
# Debian 10 Buster: EOL June 2024 - SKIP
# Debian 11 Bullseye: oldstable, supported until ~2026
# Debian 12 Bookworm: current stable, supported until ~2028
distros+='{
  "name": "Debian 11 (Bullseye)",
  "image": "debian:bullseye",
  "category": "debian"
},{
  "name": "Debian 12 (Bookworm)",
  "image": "debian:bookworm",
  "category": "debian"
},'

# Fedora - Last 2 releases (N and N-1)
# Query Fedora's release schedule or use current known versions
# As of Jan 2026: F40 and F41 are supported
# F42 releases ~April 2026
distros+='{
  "name": "Fedora 40",
  "image": "fedora:40",
  "category": "fedora"
},{
  "name": "Fedora 41",
  "image": "fedora:41",
  "category": "fedora"
},'

# RHEL/CentOS family - Currently supported versions
# CentOS Stream 9 - supported until ~2027
# Rocky/Alma 8 - supported until 2029
# Rocky/Alma 9 - supported until 2032
distros+='{
  "name": "CentOS Stream 9",
  "image": "quay.io/centos/centos:stream9",
  "category": "rhel"
},{
  "name": "Rocky Linux 8",
  "image": "rockylinux:8",
  "category": "rhel"
},{
  "name": "Rocky Linux 9",
  "image": "rockylinux:9",
  "category": "rhel"
},{
  "name": "AlmaLinux 8",
  "image": "almalinux:8",
  "category": "rhel"
},{
  "name": "AlmaLinux 9",
  "image": "almalinux:9",
  "category": "rhel"
},'

# Rolling releases - always current
distros+='{
  "name": "Arch Linux",
  "image": "archlinux:latest",
  "category": "rolling"
},{
  "name": "OpenSUSE Tumbleweed",
  "image": "opensuse/tumbleweed:latest",
  "category": "rolling"
}'

# Close JSON array
distros+=']}'

# Output the JSON
echo "$distros" | jq -c .
