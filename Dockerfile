FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install -y wget && \
    wget http://dl.ubnt.com/unifi/5.5.20/unifi_sysvinit_all.deb && \
    apt-get install -y ./unifi_sysvinit_all.deb && \
    rm unifi_sysvinit_all.deb

VOLUME /var/lib/unifi
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

COPY start.sh /start.sh
CMD /start.sh
