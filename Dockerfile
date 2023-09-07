ARG TUIC_VERSION=1.0.0

FROM rust:alpine as builder

ARG TUIC_VERSION

RUN set -ex \
  && apk update \
  && apk add wget build-base\
  && wget https://github.com/EAimTY/tuic/archive/refs/tags/tuic-server-${TUIC_VERSION}.tar.gz -O tuic-server-${TUIC_VERSION}.tar.gz \
  && tar -zxvf tuic-server-${TUIC_VERSION}.tar.gz

WORKDIR /tuic-tuic-server-${TUIC_VERSION}/tuic-server

RUN cargo build --release

FROM alpine:latest AS dist

ARG TUIC_VERSION

COPY --from=builder /tuic-tuic-server-${TUIC_VERSION}/target/release/tuic-server /usr/local/bin/

RUN set -ex \
    && chmod +x /usr/local/bin/tuic-server \
    && apk update \
    && apk upgrade \
    && apk add tzdata ca-certificates \
    && rm -rf /var/cache/apk/*

VOLUME [ "/etc/tuic/" ]

ENTRYPOINT ["/usr/local/bin/tuic-server"]

CMD ["--help"]
