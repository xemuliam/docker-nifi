FROM       xemuliam/nifi-base
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
COPY       start_nifi.sh /${NIFI_HOME}/
VOLUME     /opt/datafiles \
           /opt/scriptfiles \
           /opt/certs
WORKDIR    ${NIFI_HOME}
RUN        chmod +x ./start_nifi.sh
CMD        ./start_nifi.sh
