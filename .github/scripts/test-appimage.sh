#!/bin/bash
# Test AppImage compatibility on a Linux distribution

set -e

APPIMAGE="$1"
DISTRO_NAME="$2"

if [ -z "$APPIMAGE" ] || [ -z "$DISTRO_NAME" ]; then
  echo "Usage: $0 <appimage-file> <distro-name>"
  exit 1
fi

if [ ! -f "$APPIMAGE" ]; then
  echo "Error: AppImage file not found: $APPIMAGE"
  exit 1
fi

chmod +x "$APPIMAGE"

echo "=========================================="
echo "Testing: $APPIMAGE"
echo "Distribution: $DISTRO_NAME"
echo "=========================================="
echo ""

# Test 1: Version
echo "=== Test 1: --version ==="
if OUTPUT=$("$APPIMAGE" --appimage-extract-and-run --version 2>&1); then
  echo "$OUTPUT"
  echo "✅ PASS: --version"
else
  echo "❌ FAIL: --version"
  echo "Error output:"
  echo "$OUTPUT"
  exit 1
fi
echo ""

# Test 2: Help
echo "=== Test 2: --help ==="
if OUTPUT=$("$APPIMAGE" --appimage-extract-and-run --help 2>&1); then
  echo "✅ PASS: --help"
else
  echo "❌ FAIL: --help"
  echo "Error output:"
  echo "$OUTPUT"
  exit 1
fi
echo ""

# Test 3: Add task
echo "=== Test 3: Add task ==="
TASK_DIR=$(mktemp -d)
if OUTPUT=$("$APPIMAGE" --appimage-extract-and-run rc.data.location="$TASK_DIR" rc.confirmation=no add "Test task from CI" 2>&1); then
  echo "$OUTPUT"
  echo "✅ PASS: Add task"
else
  echo "❌ FAIL: Add task"
  echo "Error output:"
  echo "$OUTPUT"
  rm -rf "$TASK_DIR"
  exit 1
fi
echo ""

# Test 4: List tasks
echo "=== Test 4: List tasks ==="
if OUTPUT=$("$APPIMAGE" --appimage-extract-and-run rc.data.location="$TASK_DIR" list 2>&1); then
  echo "$OUTPUT"
  echo "✅ PASS: List tasks"
else
  echo "❌ FAIL: List tasks"
  echo "Error output:"
  echo "$OUTPUT"
  rm -rf "$TASK_DIR"
  exit 1
fi
echo ""

# Cleanup
rm -rf "$TASK_DIR"

echo "=========================================="
echo "✅ All tests passed on $DISTRO_NAME"
echo "=========================================="
