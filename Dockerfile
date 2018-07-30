FROM alpine:latest

RUN apk add --no-cache supervisor postfix syslog-ng bash



ENTRYPOINT [ "/entrypoint.sh" ]
