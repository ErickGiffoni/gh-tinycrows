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

# Set ZAP version and download link
ENV ZAP_VERSION="2.15.0"
ENV ZAP_URL="https://github.com/zaproxy/zaproxy/releases/download/v${ZAP_VERSION}/ZAP_${ZAP_VERSION}_Linux.tar.gz"

# Download and extract OWASP ZAP directly
RUN curl -L "${ZAP_URL}" -o zap.tar.gz && \
    mkdir /zap && \
    tar -xvzf zap.tar.gz -C /zap --strip-components=1 && \
    rm zap.tar.gz && \
    export PATH="/zap:$PATH"

# Install Dastardly
RUN docker pull dastardly-ci/dastardly

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
