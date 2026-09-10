# 2026-09-06 23:15:09 by RouterOS 7.21.5
# system id = NQMm0wH9XaF
#
/interface bridge
add dhcp-snooping=yes name=bridge-vlans priority=0xF000 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/interface wireguard
add listen-port=13231 mtu=1420 name=wg-vps
/interface vlan
add interface=bridge-vlans name=vlan70-mgmt vlan-id=70
/queue simple
add max-limit=5M/5M name=TP5-VLAN80-LIMIT target=172.18.2.224/28
/interface bridge port
add bridge=bridge-vlans frame-types=admit-only-vlan-tagged interface=ether1 \
    trusted=yes
add bpdu-guard=yes bridge=bridge-vlans edge=yes frame-types=\
    admit-only-untagged-and-priority-tagged interface=ether3 pvid=80
add bpdu-guard=yes bridge=bridge-vlans edge=yes frame-types=\
    admit-only-untagged-and-priority-tagged interface=ether4 pvid=10
/interface bridge vlan
add bridge=bridge-vlans tagged=ether1 untagged=ether4 vlan-ids=10
add bridge=bridge-vlans tagged=ether1 vlan-ids=20
add bridge=bridge-vlans tagged=ether1 vlan-ids=30
add bridge=bridge-vlans tagged=ether1 vlan-ids=40
add bridge=bridge-vlans tagged=bridge-vlans,ether1 vlan-ids=70
add bridge=bridge-vlans tagged=ether1 untagged=ether3 vlan-ids=80
add bridge=bridge-vlans tagged=ether1 vlan-ids=99
/interface wireguard peers
add allowed-address=10.200.200.2/32 endpoint-address=10.255.255.2 \
    endpoint-port=13231 interface=wg-vps name=peer1 persistent-keepalive=25s \
    public-key="eGYKnxbgFK+FA3B6W7c/FcaYq9Df07x4bma31BPb9jY="
/ip address
add address=172.18.2.91/29 interface=vlan70-mgmt network=172.18.2.88
add address=10.255.255.1/30 interface=ether5 network=10.255.255.0
add address=10.200.200.1/30 interface=wg-vps network=10.200.200.0
/ip dhcp-client
# DHCP client can not run on slave or passthrough interface!
add interface=ether1
/ip firewall filter
add action=accept chain=input comment="TP5 allow established-related" \
    connection-state=established,related
add action=drop chain=input comment="TP5 drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="TP5 allow WireGuard" dst-port=13231 \
    in-interface=ether5 protocol=udp src-address=10.255.255.2
add action=drop chain=input comment="TP5 block unsolicited WAN" in-interface=\
    ether5
add action=accept chain=forward comment="TP5 forward established-related" \
    connection-state=established,related
add action=drop chain=forward comment="TP5 forward drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment="TP5 block unsolicited WAN forward" \
    connection-nat-state=!dstnat connection-state=new in-interface=ether5
/ip firewall nat
add action=masquerade chain=srcnat comment="TP5 masquerade WAN simulada" \
    out-interface=ether5
add action=dst-nat chain=dstnat comment="TP5 port-forward HTTP simulado" \
    dst-port=8080 in-interface=ether5 protocol=tcp src-address=10.255.255.2 \
    to-addresses=172.18.2.226 to-ports=80
add action=masquerade chain=srcnat comment="TP5 return NAT port-forward" \
    dst-address=172.18.2.226 dst-port=80 out-interface=vlan70-mgmt protocol=\
    tcp src-address=10.255.255.2
add action=dst-nat chain=dstnat comment="TP5 WG to internal HTTP" dst-port=\
    8080 in-interface=wg-vps protocol=tcp to-addresses=172.18.2.226 to-ports=\
    80
add action=masquerade chain=srcnat comment="TP5 WG return NAT" dst-address=\
    172.18.2.226 dst-port=80 out-interface=vlan70-mgmt protocol=tcp \
    src-address=10.200.200.2
/ip route
add dst-address=0.0.0.0/0 gateway=172.18.2.94
add dst-address=198.51.100.1/32 gateway=10.255.255.2
/tool netwatch
add down-script="/log warning \"TP5: VLAN80 gateway DOWN\"" host=172.18.2.225 \
    interval=10s timeout=2s type=simple up-script=\
    "/log info \"TP5: VLAN80 gateway UP\""
add down-script="/log warning \"TP5: WireGuard DOWN\"" host=10.200.200.2 \
    interval=10s timeout=2s type=simple up-script=\
    "/log info \"TP5: WireGuard UP\""
add down-script=":log warning \"TP5: WAN DOWN\"" host=198.51.100.1 interval=\
    10s timeout=2s type=simple up-script=":log warning \"TP5: WAN UP\""
add down-script=":log warning \"TP5: DHCP PRIMARY DOWN\"" host=172.18.2.227 \
    interval=10s timeout=2s type=simple up-script=\
    ":log warning \"TP5: DHCP PRIMARY UP\""
add down-script=":log warning \"TP5: DHCP SECONDARY DOWN\"" host=172.18.2.228 \
    interval=10s timeout=2s type=simple up-script=\
    ":log warning \"TP5: DHCP SECONDARY UP\""
