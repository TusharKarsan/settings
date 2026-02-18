#!/usr/bin/env bash

export BASE_DIR=/home/tushar/data
cd /home/tushar/settings/combined
docker compose logs -f openwebui
