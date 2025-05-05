#!/bin/bash
# Script to test the installer in a Docker container

set -e

IMAGE_NAME="debian:bookworm-slim"
CONTAINER_NAME="linux_configs_test"

echo "=== Testing Linux Configs installer in Docker ==="
echo "Using image: $IMAGE_NAME"

# Remove any existing container with the same name
echo "Cleaning up any existing test container..."
docker rm -f "$CONTAINER_NAME" &>/dev/null || true

# Run Docker container with the repository mounted
echo "Starting Docker container..."
docker run --name "$CONTAINER_NAME" -d \
    -v "$(pwd):/linux_configs" \
    "$IMAGE_NAME" \
    sleep infinity

echo "Container started."

# Make sure we have essential packages in the container
echo "Installing required packages in container..."
docker exec "$CONTAINER_NAME" bash -c "apt-get update && apt-get install -y sudo locales"

# Run the installer in dry-run mode
echo "Running installer in dry-run mode..."
docker exec "$CONTAINER_NAME" bash -c "cd /linux_configs && ./installer.sh --dry-run"

# Optional: Also run with a specific module only
echo "Running the system-setup module only in dry-run mode..."
docker exec "$CONTAINER_NAME" bash -c "cd /linux_configs && ./installer.sh --dry-run --module system-setup"

# Clean up
echo "Cleaning up test container..."
docker stop "$CONTAINER_NAME"
docker rm "$CONTAINER_NAME"

echo "Test completed."