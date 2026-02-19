#!/usr/bin/env bash

set -e

echo "=== Starting WSL Cleanup ==="

echo
echo "--- Before cleanup ---"
df -h /

echo
echo "--- Cleaning apt caches ---"
sudo apt autoremove -y
sudo apt clean

echo
echo "--- Cleaning system logs ---"
sudo journalctl --vacuum-size=100M

echo
echo "--- Cleaning user caches ---"
rm -rf ~/.cache/* 2>/dev/null || true

echo
echo "--- Cleaning pip cache ---"
pip cache purge 2>/dev/null || true

echo
echo "--- Cleaning npm cache ---"
npm cache clean --force 2>/dev/null || true

echo
echo "--- Cleaning conda cache (if installed) ---"
conda clean --all -y 2>/dev/null || true

echo
echo "--- Docker cleanup (images, containers, build cache — NOT volumes) ---"
docker system prune -af 2>/dev/null || true
docker builder prune -af 2>/dev/null || true

echo
echo "--- After cleanup ---"
df -h /

echo
echo "=== Cleanup complete ==="
