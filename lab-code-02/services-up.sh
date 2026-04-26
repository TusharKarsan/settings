#!/usr/bin/env bash

# 1. Essential for OpenSearch stability in WSL2
sudo sysctl -w vm.max_map_count=262144

# 2. Define the data root
export BASE_DIR=/home/tushar/data

# 3. Launch the stack
cd /home/tushar/settings/lab-code-02
docker compose up -d

# 4. Quick status check
echo "Waiting for services to settle..."
sleep 5
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

cd /home/tushar
