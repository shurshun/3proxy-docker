FROM shurshun/alpine-moscow

LABEL author "Korviakov Andrey"
LABEL maintainer "4lifenet@gmail.com"

LABEL SERVICE_NAME "3proxy"

ENV PROXY_PORT=3128
ENV SOCKS_PORT=3129

HEALTHCHECK --interval=30s --timeout=2s \
  CMD nc -zv $(cat /etc/healthcheck) 3128 && nc -zv $(cat /etc/healthcheck) 3129 || exit 1

RUN \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache --update 3proxy@testing
#    && CONSUL_TEMPLATE_VERSION=$(curl -s https://api.github.com/repos/hashicorp/consul-template/tags | jq -r ".[0] .name" | tr -d v) \
#    && curl -fSl https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz | tar -C /bin -zx

COPY bin/ /bin/
COPY conf/ /etc/

CMD ["entrypoint.sh"]