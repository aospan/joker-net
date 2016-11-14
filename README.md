# WiFi client inside Docker container. Based on wpa_supplicant.
### (c) http://jokersys.com


Build container by following command: `make`

and then you can start container (change WiFi credentials):

`docker run --name net-joker --dns=8.8.8.8 -e "JOKER_SSID=isp" -e "JOKER_PASSWORD=123456789" -e "JOKER_IFACE=wlp0s20u4" --privileged -v /dev:/dev --net host joker/net`

use `iwconfig` command. If your wireless adapter connected to AP then you should see following information:

```
wlp0s20u4  IEEE 802.11  ESSID:"isp"  
          Mode:Managed  Frequency:5.2 GHz  Access Point: 54:A0:50:EF:0A:B4   
          Bit Rate=390 Mb/s   Tx-Power=12 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=70/70  Signal level=0 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
```

if your host OS automatically obtain IP-address by DHCP then you should see IP-address in `ifconfig wlp0s20u4` output. Otherwise you need to run `dhclient wlp0s20u4`.

For automatic start on machine boot you can create systemd service file `/etc/systemd/system/net-isp.service` (tested in CoreOS):

```
[Unit]
Description=WiFi client
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill net-isp
ExecStartPre=-/usr/bin/docker rm net-isp
ExecStart=/usr/bin/docker run --name net-isp --dns=8.8.8.8 -e "JOKER_SSID=isp" -e "JOKER_PASSWORD=123456789" -e "JOKER_IFACE=wlp0s20u4" --privileged -v /dev:/dev --net host joker/net
ExecStop=/usr/bin/docker kill net-isp

[Install]
WantedBy=multi-user.target
```

and enable them by following command:

`systemctl enable /etc/systemd/system/net-isp.service`
