#!/bin/bash
# (c) Abylay Ospan, 2016
# jokersys.com

set -e

if [ -s $JOKER_SSID ] || [ -s $JOKER_PASSWORD ] || [ -s $JOKER_IFACE ] || [ -s $JOKER_NET ]; then
  echo "Please define JOKER_SSID, JOKER_PASSWORD, JOKER_IFACE env variables ! exiting ... "
  /bin/false
fi

#temporary hack: coreos 4.8.6 kernel required
if ! lsmod | grep 8812au >/dev/null 2>&1 ; then
    insmod /8812au.ko
fi

cat <<EOF > /etc/wpa_supplicant.conf
  network={
  ssid="$JOKER_SSID"
  key_mgmt=WPA-PSK
  psk="$JOKER_PASSWORD"
}
EOF

echo "wifi configuration:"
cat /etc/wpa_supplicant.conf

# NAT all traffic from internal network
/sbin/iptables -t nat -I POSTROUTING 1 -o $JOKER_IFACE -s $JOKER_NET -j MASQUERADE

/sbin/wpa_supplicant -Dnl80211 -i $JOKER_IFACE -c /etc/wpa_supplicant.conf
