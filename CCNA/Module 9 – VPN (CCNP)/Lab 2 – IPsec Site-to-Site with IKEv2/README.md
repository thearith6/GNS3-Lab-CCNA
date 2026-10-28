## Lab 2 - IPsec Site-to-Site with IKEv2

> **GNS3 Project:** [`Module 9 - VPN (CCNP) | Lab 2 – IPsec Site-to-Site with IKEv2.gns3`](./Module%209%20-%20VPN%20%28CCNP%29%20%7C%20Lab%202%20%E2%80%93%20IPsec%20Site-to-Site%20with%20IKEv2.gns3)

![topology](topology.png)

## Scenario
Starting from the default routes of Lab 1, configure IKEv2 between R1 and R3. Use AES-256, SHA-256, DH group 14 and the pre-shared key Cisco123PSK. The profile of each router matches the public address of the other router.

- **Devices:** PC1 (PC), PC3 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0: `203.0.113.1` (255.255.255.252)
  - `R1` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `R3` Ethernet0/0: `198.51.100.2` (255.255.255.252)
  - `R3` Ethernet0/1: `192.168.3.1` (255.255.255.0)
  - `R2` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R2` Ethernet0/1: `198.51.100.1` (255.255.255.252)
  - `PC1` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC3` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - Starting from the default routes of Lab 1, configure IKEv2 between R1 and R3.
  - Use AES-256, SHA-256, DH group 14 and the pre-shared key Cisco123PSK.
  - The profile of each router matches the public address of the other router.

Task 2 - Create the IPsec profile with ESP AES-256 and SHA-256 in tunnel mode.
  - Use an IPsec virtual tunnel interface between the routers (tunnel mode ipsec ipv4) and protect it with the profile.

Task 3 - Route the LAN traffic through the tunnel and verify the security associations after a ping from PC1 to PC3.
  - Configure on R1
  - Configure on R3

## Action
Task 1 - Starting from the default routes of Lab 1, configure IKEv2 between R1 and R3.

**R1:**
```cisco
crypto ikev2 proposal PROP
encryption aes-cbc-256
integrity sha256
group 14
crypto ikev2 policy POL
proposal PROP
crypto ikev2 keyring KEYS
peer BRANCH
address 198.51.100.2
pre-shared-key Cisco123PSK
crypto ikev2 profile PROF
match identity remote address 198.51.100.2
255.255.255.255
authentication remote pre-share
authentication local pre-share
keyring local KEYS
```

**R3:**
```cisco
crypto ikev2 proposal PROP
encryption aes-cbc-256
integrity sha256
group 14
crypto ikev2 policy POL
proposal PROP
crypto ikev2 keyring KEYS
peer HQ
address 203.0.113.1
pre-shared-key Cisco123PSK
crypto ikev2 profile PROF
match identity remote address 203.0.113.1
255.255.255.255
authentication remote pre-share
authentication local pre-share
keyring local KEYS
```

Task 2 - Create the IPsec profile with ESP AES-256 and SHA-256 in tunnel mode.

**R1:**
```cisco
crypto ipsec transform-set TS esp-aes 256
esp-sha256-hmac
mode tunnel
crypto ipsec profile IPSEC-PROF
set transform-set TS
set ikev2-profile PROF
interface Tunnel0
ip address 172.16.0.1 255.255.255.252
tunnel source Ethernet0/0
tunnel destination 198.51.100.2
tunnel mode ipsec ipv4
tunnel protection ipsec profile IPSEC-PROF
```

**R3:**
```cisco
crypto ipsec transform-set TS esp-aes 256
esp-sha256-hmac
mode tunnel
crypto ipsec profile IPSEC-PROF
set transform-set TS
set ikev2-profile PROF
interface Tunnel0
ip address 172.16.0.2 255.255.255.252
tunnel source Ethernet0/0
tunnel destination 203.0.113.1
tunnel mode ipsec ipv4
tunnel protection ipsec profile IPSEC-PROF
```

Task 3 - Route the LAN traffic through the tunnel and verify the security associations after a ping from PC1 to PC3.

**R1:**
```cisco
ip route 192.168.3.0 255.255.255.0
172.16.0.2
```

**R3:**
```cisco
ip route 192.168.1.0 255.255.255.0
172.16.0.1
```

## Note
1. Verification commands: `Show crypto ikev2 sa`
2. The status of the IKEv2 SA should be READY. Show crypto ipsec sa
3. The counters for encaps and decaps should increase.
4. On R3, change the pre-shared key to WrongKey123. Restart the tunnel with shutdown and no shutdown on both routers. — The IKEv2 authentication fails. No security association is created and PC1 cannot reach PC3. Note: Fix it by entering the key Cisco123PSK.
5. On R3, change the transform set to esp-aes 128 esp-sha-hmac. Restart the tunnel on both routers. — The IKEv2 SA is READY, but the IPsec SA cannot be created because the proposals do not match. The tunnel does not pass traffic. Note: Fix it by using the same transform set on both routers.