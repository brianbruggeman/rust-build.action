FROM rust:1.68-alpine3.17

LABEL "name"="Automate publishing Rust build artifacts for GitHub releases through GitHub Actions"
LABEL "version"="1.4.3"
LABEL "repository"="http://github.com/rust-build/rust-build.action"
LABEL "maintainer"="Douile <25043847+Douile@users.noreply.github.com>"

# Add dependencies
RUN apk add --no-cache --virtual .standard-deps \
      bash \
      build-base \
      curl \
      git \
      jq \
      openssh \
      tar \
      upx \
      xz \
      zip \
      zstd \
 && apk add --no-cache --virtual .darwin-deps \
      bsd-compat-headers \
      clang \
      cmake \
      libxml2-dev \
      musl-fts-dev \
      openssl-dev \
 && git clone https://github.com/tpoechtrager/osxcross /opt/osxcross \
 && curl -Lo /opt/osxcross/tarballs/MacOSX10.10.sdk.tar.xz "https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz" \
 && /bin/bash -c "cd /opt/osxcross && UNATTENDED=yes OSX_VERSION_MIN=10.8 ./build.sh" \
 && echo "Done."

# Add project files
COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh
RUN chmod +x /entrypoint.sh /build.sh

ENTRYPOINT ["/entrypoint.sh"]
