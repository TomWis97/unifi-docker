FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y gnupg curl && \
    echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ubnt.com/unifi/unifi-repo.gpg && \
    sudo apt-get clean

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
