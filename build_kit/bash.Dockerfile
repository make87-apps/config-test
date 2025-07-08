FROM ghcr.io/make87/debian:bookworm-slim

# Install jq
RUN apt-get update && apt-get install -y --no-install-recommends jq ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script into image
COPY entrypoint.sh /entrypoint.sh

# Make sure it's executable
RUN chmod +x /entrypoint.sh

# Set as entrypoint
ENTRYPOINT ["/entrypoint.sh"]
