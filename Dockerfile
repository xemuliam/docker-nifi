FROM       xemuliam/nifi-base:1.1.1
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
ARG        UID=1000
ARG        GID=50
ENV        BANNER_TEXT="" \
           S2S_PORT=""
COPY       start_nifi.sh /${NIFI_HOME}/
RUN        groupadd -g $GID nifi || groupmod -n nifi `getent group $GID | cut -d: -f1` && \
           useradd --shell /bin/bash -u $UID -g $GID -m nifi && \
           chown -R nifi:nifi $NIFI_HOME
VOLUME     /opt/datafiles \
           /opt/scriptfiles \
           /opt/certfiles
WORKDIR    ${NIFI_HOME}
RUN        chmod +x ./start_nifi.sh
USER       nifi
CMD        ./start_nifi.sh
