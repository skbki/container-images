# Container Images

This repository contains Docker images for testing and development environments.

## Available Images

- **molecule-ubuntu-22.04**: Ubuntu 22.04 LTS with Python, Git, and development tools for Molecule testing
- **molecule-ubuntu-24.04**: Ubuntu 24.04 LTS with Python, Git, and development tools for Molecule testing
- **molecule-ubuntu-22.04-systemd**: Ubuntu 22.04 LTS with systemd init system and development tools for testing systemd services
- **molecule-ubuntu-24.04-systemd**: Ubuntu 24.04 LTS with systemd init system and development tools for testing systemd services

## Automated Builds

The Docker images are automatically built and pushed to the GitHub Container Registry (GHCR) using GitHub Actions:

- **Daily builds**: Images are built every day at 2 AM UTC to ensure they have the latest security updates
- **On code changes**: Images are rebuilt when Dockerfiles are modified
- **Manual trigger**: Workflows can be manually triggered from the Actions tab

## Using the Images

Pull the images from the GitHub Container Registry:

```bash
# For Ubuntu 22.04
docker pull ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-22.04:latest

# For Ubuntu 24.04
docker pull ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-24.04:latest

# For Ubuntu 22.04 with systemd
docker pull ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-22.04-systemd:latest

# For Ubuntu 24.04 with systemd
docker pull ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-24.04-systemd:latest
```

Replace `$GITHUB_REPOSITORY` with the actual repository name (e.g., `username/container-images`).

## Using Systemd Images

The systemd images require special configuration to run properly. They need privileged mode and the cgroup filesystem mounted:

```bash
# Run Ubuntu 22.04 with systemd
docker run -d --privileged --name test-systemd-22 \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-22.04-systemd:latest

# Run Ubuntu 24.04 with systemd
docker run -d --privileged --name test-systemd-24 \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  ghcr.io/$(echo $GITHUB_REPOSITORY | tr '[:upper:]' '[:lower:]')/molecule-ubuntu-24.04-systemd:latest

# Connect to the running container
docker exec -it test-systemd-22 /bin/bash
```

**Note**: Systemd containers are primarily intended for testing systemd services and should be used with caution in production environments.

## Image Tags

Each image is tagged with:
- `latest`: The most recent build from the default branch
- `YYYYMMDD`: Date-based tags for daily builds
- `branch-sha`: Branch and commit-based tags for development builds

## Supported Platforms

Images are built for multiple architectures:
- `linux/amd64` (x86_64)
- `linux/arm64` (ARM64/AArch64)