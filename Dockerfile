FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    git curl wget python3 python3-dev ldid \
    build-essential clang llvm && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/theos/theos.git /theos

WORKDIR /project
ENV THEOS=/theos
ENV PATH=$PATH:/theos/bin

CMD ["bash"]
