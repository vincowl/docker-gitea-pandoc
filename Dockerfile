FROM gitea/gitea:latest 

ENV BUILD_DEPS \
    alpine-sdk \
    cabal \
    coreutils \
    ghc \
    libffi \
    musl-dev \
    zlib-dev
ENV PERSISTENT_DEPS \
    gmp \
    graphviz \
    openjdk17-jre \
    python3 \
    py3-pip \
    sed \
    ttf-droid \
    ttf-droid-nonlatin

# ENV PLANTUML_VERSION 1.2019.8
ENV PLANTUML_DOWNLOAD_URL https://sourceforge.net/projects/plantuml/files/plantuml.jar/download

ENV PANDOC_VERSION 2.19.2
ENV PANDOC_DOWNLOAD_URL https://hackage.haskell.org/package/pandoc-$PANDOC_VERSION/pandoc-$PANDOC_VERSION.tar.gz
ENV PANDOC_ROOT /usr/local/pandoc

ENV PATH $PATH:$PANDOC_ROOT/bin

# Install/Build Packages
RUN apk upgrade --update && \
    apk add --virtual .build-deps $BUILD_DEPS && \
    apk add --virtual .persistent-deps $PERSISTENT_DEPS && \
    curl -fsSL "$PLANTUML_DOWNLOAD_URL" -o /usr/local/plantuml.jar && \
    chmod a+r /usr/local/plantuml.jar && \
    mkdir -p /pandoc-build \
             /var/docs && \
    cd /pandoc-build && \
    curl -fsSL "$PANDOC_DOWNLOAD_URL" | tar -xzf - && \
    cd pandoc-$PANDOC_VERSION && \
    cabal update && \
    cabal install --only-dependencies && \
    cabal configure --prefix=$PANDOC_ROOT && \
    cabal build && \
    cabal copy && \
    cd / && \
    rm -Rf /pandoc-build \
           $PANDOC_ROOT/lib \
           /root/.cabal \
           /root/.ghc && \
    set -x && \
    addgroup -g 82 -S pandoc && \
    adduser -u 1000 -D -S -G pandoc pandoc && \
    apk del .build-deps

COPY plantuml /usr/local/bin/

# Set to non root user
#USER pandoc

# Reset the work dir
#WORKDIR /var/docs


