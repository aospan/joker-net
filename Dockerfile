FROM debian:jessie
MAINTAINER aospan@jokersys.com

RUN apt-get update && apt-get install -y \
    hostapd vim iw wireless-tools \
    dnsmasq net-tools wpasupplicant \
    kmod iptables

#hack: rtl8812 wifi adapter driver 
# !compiled for specific version of kernel
COPY ./8812au.ko /

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
