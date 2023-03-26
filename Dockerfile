FROM alpine:3.17.2 AS builder

WORKDIR /src

RUN apk update \
    && apk add --no-cache \
        wget \
        tar \
        make \
        gcc \
        curl \
        libc-dev \
    && wget https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_3.0.0-beta.6.tar.gz \
    && tar xf noip-duc_3.0.0-beta.6.tar.gz \
    # To change directory to noip directory,
    # we need to delete zip file first
    && rm -f noip-duc_3.0.0-beta.6.tar.gz \
    # Due to version are named in folder name,
    # we need to get folder name first then change to that folder
    && cd "$(ls ./| grep noip)" \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ~/.cargo/bin/cargo build --release \
    && mkdir /noip_build \
    && mv target/release/noip-duc /noip_build

FROM alpine:3.17.2

WORKDIR /usr/local/bin

COPY --from=builder /noip_build/noip-duc ./
COPY . .

RUN chmod +x ./scripts/start_noip2.sh

CMD ["scripts/start_noip2.sh"]
