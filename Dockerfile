FROM ubuntu:20.04

ARG OTP_VERSION=28.0.1
ARG ELIXIR_VERSION=1.19.0-rc.0
ARG NERVES_BOOTSTRAP_VERSION=1.13.0

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

# We run as root to avoid permissions issues with the GitHub Actions runner.

# Install required repositories and packages, excluding cmake for now
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test
COPY vendor/packages.txt /tmp/packages.txt
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    xargs -a /tmp/packages.txt apt-get install -y --no-install-recommends && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 60 && \
    pip3 install --no-cache-dir jinja2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install cmake 3.16.5 manually
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5-Linux-x86_64.tar.gz && \
    tar --strip-components=1 -xz -C /usr/local -f cmake-3.16.5-Linux-x86_64.tar.gz && \
    rm cmake-3.16.5-Linux-x86_64.tar.gz

# Make python3 available as python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Erlang/OTP directly
RUN wget https://github.com/erlang/otp/releases/download/OTP-${OTP_VERSION}/otp_src_${OTP_VERSION}.tar.gz && \
    tar -xzf otp_src_${OTP_VERSION}.tar.gz && \
    cd otp_src_${OTP_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf otp_src_${OTP_VERSION} otp_src_${OTP_VERSION}.tar.gz

# Install Elixir directly
RUN wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-28.zip && \
    unzip elixir-otp-28.zip -d /usr/local && \
    rm elixir-otp-28.zip

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex nerves_bootstrap --force

# Install fwup directly
RUN wget https://github.com/fwup-home/fwup/releases/download/v${NERVES_BOOTSTRAP_VERSION}/fwup_${NERVES_BOOTSTRAP_VERSION}_amd64.deb && \
    dpkg -i fwup_${NERVES_BOOTSTRAP_VERSION}_amd64.deb && \
    rm fwup_${NERVES_BOOTSTRAP_VERSION}_amd64.deb

# Update PATH to include Elixir binaries
ENV PATH="/usr/local/bin:${PATH}"
ENV FORCE_UNSAFE_CONFIGURE=1