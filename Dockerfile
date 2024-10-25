# Use the Ubuntu 20.04 image
FROM ubuntu:20.04

# Set frontend to noninteractive to prevent tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    openjdk-11-jdk \
    unzip \
    bash \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Install Horusec CLI
RUN curl -fsSL https://github.com/ZupIT/horusec/releases/latest/download/horusec_linux_amd64 -o horusec && \
    chmod +x horusec && \
    mv horusec /usr/local/bin/horusec

# Install Dependency-Check
RUN curl -LO https://github.com/jeremylong/DependencyCheck/releases/download/v6.5.0/dependency-check-6.5.0-release.zip \
    && unzip dependency-check-6.5.0-release.zip -d dependency-check

# Install OWASP ZAP (via Docker)
RUN docker pull owasp/zap2docker-stable

# Install Dastardly
RUN docker pull dastardly-ci/dastardly

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
