FROM       xemuliam/nifi-base
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
ENV        NIFI_HOME /opt/nifi \
           BANNER_TEXT Docker-Nifi-1.0.0 \
           INSTANCE_ROLE single-node \
           NODES_LIST N/A \
           MYID N/A
COPY       start_nifi.sh /${NIFI_HOME}/
COPY       zookeeper.properties /${NIFI_HOME}/conf/
VOLUME     /opt/datafiles \
           /opt/scriptfiles \
           /opt/certs
WORKDIR    ${NIFI_HOME}
RUN        chmod +x ./start_nifi.sh
CMD        ./start_nifi.sh
