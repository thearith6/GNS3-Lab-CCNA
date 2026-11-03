FreeRADIUS docker settings

ip addr add 192.168.100.50/24 dev eth0
ip link set eth0 up
ip route add default via 192.168.100.1
cat >> /etc/freeradius/clients.conf <<'EOF'
client R1 {
    ipaddr = 192.168.100.1
    secret = RadKey123
    require_message_authenticator = no
}
EOF
sed -i '1i user1  Cleartext-Password := "Password123"' /etc/freeradius/mods-config/files/authorize
freeradius -X
