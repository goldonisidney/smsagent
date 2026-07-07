FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV THEOS=/theos

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git curl wget python3 python3-dev \
    build-essential clang llvm ldid \
    libssl-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone THEOS
RUN git clone --recursive https://github.com/theos/theos.git /theos

# Set working directory
WORKDIR /project

# Add THEOS to PATH
ENV PATH=$PATH:/theos/bin

CMD ["bash"]
