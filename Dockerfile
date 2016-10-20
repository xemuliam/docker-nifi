FROM       xemuliam/nifi-base
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
LABEL      VERSION="1.0.0" \
           RUN="docker run -d -p 8080:8080 -p 8443:8443 xemuliam/nifi"
ENV        INSTANCE_ROLE=single-node \
           NODES_LIST=localhost:2181,localhost:2182,localhost:2183 \
           MYID=1
COPY       start_nifi.sh /${NIFI_HOME}/
COPY       zookeeper.properties /${NIFI_HOME}/conf/
VOLUME     /opt/datafiles \
           /opt/scriptfiles \
           /opt/certs
WORKDIR    ${NIFI_HOME}
RUN        chmod +x ./start_nifi.sh
CMD        ./start_nifi.sh
