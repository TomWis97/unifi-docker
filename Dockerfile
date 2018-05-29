FROM ubuntu:18.04

RUN apt update && \
    apt install -y wget supervisor && \
    wget -q http://dl.ubnt.com/unifi/5.6.37/unifi_sysvinit_all.deb && \
    apt remove -y wget && \
    apt install -y ./unifi_sysvinit_all.deb && \
    rm unifi_sysvinit_all.deb && \
    apt clean

RUN apt update && \
    apt install apt-utils software-properties-common -y && \
    add-apt-repository ppa:webupd8team/java -y && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | \
        debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
        debconf-set-selections && \
    apt install oracle-java8-installer -y && \
    apt install oracle-java8-set-default -y && \
    apt remove apt-utils software-properties-common -y && \
    apt clean

VOLUME /var/lib/unifi
VOLUME /var/lib/mongodb
# Logs are located in /var/log/unifi

# Ports for Unifi software
# TCP/8080  HTTP access (UAP to inform controller)
# TCP/8443  HTTPS access (controller GUI)
# TCP/8880  HTTP portal redirect
# TCP/8843  HTTPS portal redirect
# TCP/6789  Throughput measurement
# UDP/3478  Port used for STUN
# UDP/10001 AP discovery
#
# TCP/27117 Local port for database server. Internal usage.
# Source: https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used

EXPOSE 8080 \
       8443 \
       8880 \
       8843 \
       6789 \
       3478/udp \
       10001/udp

COPY supervisord.conf /etc/supervisord.conf
CMD /usr/bin/supervisord -c /etc/supervisord.conf 
