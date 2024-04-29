FROM debian:bookworm-slim AS graalvm17

# Install dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ca-certificates \
#     curl \
#     gcc \
#     libc6-dev \
#     libzstd-dev \
#     zlib1g-dev \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/download_graalvm.sh /usr/local/bin/download_graalvm.sh
#RUN cat /usr/local/bin/download_graalvm.sh
RUN chmod +x /usr/local/bin/download_graalvm.sh

RUN /usr/local/bin/download_graalvm.sh