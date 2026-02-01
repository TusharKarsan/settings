# Server Settings & Docker Orchestration

This repository contains the configuration and orchestration scripts for my local services, including ComfyUI and networking tools.

## 🏗 Structure

- `/data`: Persistent storage for all services (ignored by git).
- `/old_2_dc`: Archive of previous configuration files for reference.
- `services-up.sh`: Bootstraps the environment and starts containers.
- `services-down.sh`: Safely stops all active services.

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose
- Tailscale (for remote access)

### Usage
To start the services with the correct environment variables (setting the `BASE_DIR` for volume persistence):

```bash
chmod +x services-up.sh services-down.sh
./services-up.sh
