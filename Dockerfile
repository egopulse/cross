FROM alpine

RUN apk add -U docker dropbear openssh-client bind-tools jq bash
RUN mkdir -p /etc/dropbear/

ENV RSA_KEYFILE=/etc/dropbear/dropbear_rsa_host_key
ENV DSS_KEYFILE=/etc/dropbear/dropbear_dss_host_key
RUN dropbearkey -t dss -f $DSS_KEYFILE && \
    dropbearkey -t rsa -f $RSA_KEYFILE && \
    chmod 700 /etc/dropbear

RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

RUN touch /var/log/lastlog
RUN touch /var/log/wtmp

RUN mkdir -p /usr/bin
ADD enter /usr/bin/enter
ADD enter-node /usr/bin/enter-node
RUN chmod +x /usr/bin/enter
RUN chmod +x /usr/bin/enter-node

CMD dropbear -FBEa