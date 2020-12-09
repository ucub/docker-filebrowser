FROM alpine as builder

ARG VERSION
RUN apk add curl
COPY get.sh get.sh

RUN apk add bash \
    && ./get.sh $VERSION

FROM alpine:3

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="mang_ucub"


COPY --from=builder /usr/local/bin/filebrowser /filebrowser

RUN mkdir -p -m 777 /config \
    && mkdir -p -m 777 /data

EXPOSE 8080

ENTRYPOINT ["/filebrowser"]
CMD ["--root=/repo", "--address=0.0.0.0", "--database=/config/filebrowser.db"]
