FROM       xemuliam/nifi-base:1.1.1
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
ENV        BANNER_TEXT="" \
           S2S_PORT=""
COPY       start_nifi.sh /${NIFI_HOME}/
RUN        addgroup -S nifi && adduser -S -g nifi nifi && \
           chown -R nifi:nifi $NIFI_HOME
VOLUME     /opt/datafiles \
           /opt/scriptfiles \
           /opt/certfiles
WORKDIR    ${NIFI_HOME}
RUN        chmod +x ./start_nifi.sh
USER       nifi
CMD        ./start_nifi.sh
