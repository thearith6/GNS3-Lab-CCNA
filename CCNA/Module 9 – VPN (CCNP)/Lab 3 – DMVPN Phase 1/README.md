## Lab 3 - DMVPN Phase 1

> **GNS3 Project:** [`Module 9 - VPN (CCNP) | Lab 3 – DMVPN Phase 1.gns3`](./Module%209%20-%20VPN%20%28CCNP%29%20%7C%20Lab%203%20%E2%80%93%20DMVPN%20Phase%201.gns3)

![topology](topology.png)

## Scenario
Configure the hub as an mGRE tunnel endpoint with NHRP. Use the tunnel network 172.16.100.0/24 (hub .1), the NHRP network ID 1 and the NHRP password NHRPKEY. The hub must replicate multicast traffic to every spoke that registers.

- **Devices:** HUB (IOU L3), SPOKE1 (IOU L3), SPOKE2 (IOU L3), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `SPOKE1` Ethernet0/0: `203.0.113.2` (255.255.255.0)
  - `SPOKE1` Loopback1: `192.168.2.1` (255.255.255.0)
  - `HUB` Ethernet0/0: `203.0.113.1` (255.255.255.0)
  - `HUB` Loopback1: `192.168.1.1` (255.255.255.0)
  - `SPOKE2` Ethernet0/0: `203.0.113.3` (255.255.255.0)
  - `SPOKE2` Loopback1: `192.168.3.1` (255.255.255.0)

Task 1 - Configure the hub as an mGRE tunnel endpoint with NHRP.
  - Use the tunnel network 172.16.100.0/24 (hub .1), the NHRP network ID 1 and the NHRP password NHRPKEY.
  - The hub must replicate multicast traffic to every spoke that registers.

Task 2 - Configure the spokes with a normal point-to-point GRE tunnel to the hub (Phase 1).
  - They register with the hub as the NHRP server.
  - SPOKE1 uses 172.16.100.2 and SPOKE2 uses 172.16.100.3.

Task 3 - Run EIGRP AS 100 over the tunnel and the LAN loopbacks.
  - On the hub, disable split horizon on the tunnel so that the routes of one spoke reach the other.
  - Verify the DMVPN and the routes.

## Action
Task 1 - Configure the hub as an mGRE tunnel endpoint with NHRP.

**HUB:**
```cisco
interface Tunnel0
ip address 172.16.100.1 255.255.255.0
ip nhrp network-id 1
ip nhrp authentication NHRPKEY
ip nhrp map multicast dynamic
tunnel source Ethernet0/0
tunnel mode gre multipoint
```

Task 2 - Configure the spokes with a normal point-to-point GRE tunnel to the hub (Phase 1).

**SPOKE1:**
```cisco
interface Tunnel0
ip address 172.16.100.2 255.255.255.0
ip nhrp network-id 1
ip nhrp authentication NHRPKEY
ip nhrp nhs 172.16.100.1
ip nhrp map 172.16.100.1 203.0.113.1
ip nhrp map multicast 203.0.113.1
tunnel source Ethernet0/0
tunnel destination 203.0.113.1
```

**SPOKE2:**
```cisco
interface Tunnel0
ip address 172.16.100.3 255.255.255.0
ip nhrp network-id 1
ip nhrp authentication NHRPKEY
ip nhrp nhs 172.16.100.1
ip nhrp map 172.16.100.1 203.0.113.1
ip nhrp map multicast 203.0.113.1
tunnel source Ethernet0/0
tunnel destination 203.0.113.1
```

Task 3 - Run EIGRP AS 100 over the tunnel and the LAN loopbacks.

**HUB:**
```cisco
router eigrp 100
network 172.16.100.0 0.0.0.255
network 192.168.1.0 0.0.0.255
no auto-summary
interface Tunnel0
no ip split-horizon eigrp 100
```

**SPOKE1 and SPOKE2:**
```cisco
router eigrp 100
network 172.16.100.0 0.0.0.255
network 192.168.2.0 0.0.0.255
```

## Note
1. Verification commands: `Show ip route eigrp`, `Show dmvpn`
2. SPOKE1 and SPOKE2 should be listed with the state UP and the attribute D (dynamic).
3. In Phase 1 the next hop for the other networks is always the hub (172.16.100.1). The traffic between the spokes goes through the hub.
4. On the hub, remove ip nhrp map multicast dynamic from Tunnel0. Check the EIGRP neighbors of the hub. — The EIGRP hello packets are not replicated to the spokes. The hub loses its EIGRP neighbors. Note: Fix it with ip nhrp map multicast dynamic.
5. On SPOKE1, change the NHRP authentication to WRONGKEY. Check the registration on the hub. — The registration is rejected because the password does not match. SPOKE1 is no longer listed in show dmvpn on the hub. Note: Fix it with ip nhrp authentication NHRPKEY.