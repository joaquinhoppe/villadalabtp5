# 2026-09-06 22:54:48 by RouterOS 7.21.5
# system id = aZG86pYvlCE
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/interface wireguard
add listen-port=13231 mtu=1420 name=wg-site
/ip pool
add name=rogue-pool ranges=10.66.66.100-10.66.66.110
/interface wireguard peers
add allowed-address=10.200.200.1/32 endpoint-address=10.255.255.1 \
    endpoint-port=13231 interface=wg-site name=peer1 persistent-keepalive=25s \
    public-key="BYxzNn0OJNSgselGfHpw0LR2l76AxwJY8DvMj4GvJTY="
/ip address
add address=10.255.255.2/30 interface=ether1 network=10.255.255.0
add address=10.200.200.2/30 interface=wg-site network=10.200.200.0
add address=198.51.100.1 interface=lo network=198.51.100.1
add address=203.0.113.1/24 interface=ether2 network=203.0.113.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=rogue-pool disabled=yes interface=ether1 lease-time=10m \
    name=rogue-dhcp
/ip dhcp-server network
add address=10.66.66.0/24 dns-server=1.1.1.1 gateway=10.66.66.1
/ip firewall nat
add action=dst-nat chain=dstnat comment="TP5 VPS forward via WireGuard" \
    dst-address=198.51.100.1 dst-port=8080 protocol=tcp to-addresses=\
    10.200.200.1 to-ports=8080
add action=src-nat chain=srcnat comment="TP5 VPS SNAT toward WireGuard" \
    dst-address=10.200.200.1 dst-port=8080 out-interface=wg-site protocol=tcp \
    to-addresses=10.200.200.2
/ip route
add dst-address=172.18.2.224/28 gateway=10.255.255.1
