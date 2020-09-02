FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get -y install \
    net-tools \
    tini \
    rinetd

ENV DESTINATIONS=''
ENV LOGFILE=''
ENV LOGCOMMON=''

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["tini", "/usr/local/bin/run.sh"]
