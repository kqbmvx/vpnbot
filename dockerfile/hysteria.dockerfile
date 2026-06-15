FROM apernet/hysteria:app-latest
RUN apk add --no-cache openssh iptables \
    && mkdir -p /root/.ssh
ENV ENV="/root/.ashrc"
ENTRYPOINT []
