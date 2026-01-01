# AppImage Compatibility Testing Scripts

## Overview

This directory contains scripts for dynamically determining which Linux distributions to test the AppImage against.

## get-test-distros.sh

Generates a JSON matrix of currently-supported Linux distributions for compatibility testing.

### Philosophy

**We test only currently-supported distributions** to:
- Save CI time and resources
- Focus on distros users actually run
- Automatically phase out EOL distributions
- Ensure compatibility with modern systems

### Supported Distributions

The script automatically includes:

#### Ubuntu LTS (5 years support)
- **20.04 (Focal)**: Until April 2025
- **22.04 (Jammy)**: Until April 2027
- **24.04 (Noble)**: Until April 2029

#### Debian (typically ~3-5 years)
- **11 (Bullseye)**: oldstable, until ~2026
- **12 (Bookworm)**: current stable, until ~2028

#### Fedora (N and N-1)
- Last two releases (typically ~13 months each)
- Auto-updated as new versions release

#### RHEL/CentOS Family (10 years support)
- **CentOS Stream 9**: Until ~2027
- **Rocky Linux 8/9**: Until 2029/2032
- **AlmaLinux 8/9**: Until 2029/2032

#### Rolling Releases
- **Arch Linux**: Always latest
- **OpenSUSE Tumbleweed**: Always latest

### Maintenance

#### When to Update

Update this script when:
1. A distro reaches EOL (script will auto-skip based on date)
2. New LTS/stable versions are released
3. Fedora releases a new version (twice yearly)

#### How to Update

1. Check current support status:
   - Ubuntu: https://wiki.ubuntu.com/Releases
   - Debian: https://wiki.debian.org/DebianReleases
   - Fedora: https://fedoraproject.org/wiki/Releases
   - RHEL: https://access.redhat.com/support/policy/updates/errata

2. Update the script:
   - Add new versions
   - Update EOL date checks
   - Remove deprecated versions

3. Test locally:
   ```bash
   .github/scripts/get-test-distros.sh | jq .
   ```

4. Commit and push - CI will use the updated matrix automatically

### Example Output

```json
{
  "include": [
    {
      "name": "Ubuntu 22.04 (Jammy)",
      "image": "ubuntu:22.04",
      "category": "ubuntu-lts"
    },
    ...
  ]
}
```

### Benefits of Dynamic Testing

✅ Automatically excludes EOL distros
✅ Easy to update for new releases
✅ Documented support policy
✅ Reduces test time as old versions phase out
✅ Single source of truth for tested distros
