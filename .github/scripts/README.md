# AppImage Test Scripts

## test-appimage.sh

Tests an AppImage for compatibility on a Linux distribution.

### Usage

```bash
./test-appimage.sh <appimage-file> <distro-name>
```

### What it tests

1. **--version**: Verifies the AppImage executes and shows version
2. **--help**: Checks help output works
3. **add task**: Creates a task in a temporary location
4. **list tasks**: Lists tasks to verify database operations

### Exit codes

- **0**: All tests passed
- **1**: One or more tests failed

### Testing locally

Test with Docker:

```bash
# Download an AppImage (or use one you built)
APPIMAGE="taskwarrior-3.4.1-abc123-x86_64.AppImage"

# Test on Ubuntu 22.04
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ubuntu:22.04 \
  bash /workspace/.github/scripts/test-appimage.sh "/workspace/$APPIMAGE" "Ubuntu 22.04"

# Test on Fedora 41
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  fedora:41 \
  bash /workspace/.github/scripts/test-appimage.sh "/workspace/$APPIMAGE" "Fedora 41"
```

### Why --appimage-extract-and-run?

AppImages normally use FUSE to mount themselves, but FUSE is not available in
Docker containers. The `--appimage-extract-and-run` option extracts the
AppImage contents to a temporary directory and runs from there, which works
in containerized environments.

### Integration with GitHub Actions

The workflow uses this script to test the AppImage across multiple
distributions in parallel. Each matrix job:

1. Checks out the repository (to get this script)
2. Downloads the built AppImage
3. Runs the script inside a Docker container for the target distro
4. The job **fails** if the script exits with non-zero status

GitHub Actions automatically tracks pass/fail for each matrix job.
