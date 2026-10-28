## Lab 8 - QoS and Localized Policy

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 8 - QoS and Localized Policy.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%208%20-%20QoS%20and%20Localized%20Policy.gns3)

![topology](topology.png)

## Scenario
On vEdge2, create the localized policy. Define the classes VOICE (queue 0) and BEST-EFFORT (queue 2). Create a low latency scheduler for VOICE (30 percent of the bandwidth) and a weighted round robin scheduler for BEST-EFFORT (70 percent). Add both schedulers to the QoS map WAN-QOS.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - On vEdge2, create the localized policy.
  - Define the classes VOICE (queue 0) and BEST-EFFORT (queue 2).
  - Create a low latency scheduler for VOICE (30 percent of the bandwidth) and a weighted round robin scheduler for BEST-EFFORT (70 percent).
  - Add both schedulers to the QoS map WAN-QOS.

Task 2 - Apply the QoS map to the INET interface ge0/0 of vEdge2 in VPN 0 and shape the interface to 5000 kbps.
  - Configure on vEdge2

Task 3 - Classify the voice traffic: traffic that is marked with DSCP 46 must be placed in the class VOICE.
  - Apply the access list inbound on the LAN interface in VPN 10 and verify the counters.

## Action
Task 1 - On vEdge2, create the localized policy.

**vEdge2:**
```cisco
policy
class-map
class VOICE queue 0
class BEST-EFFORT queue 2
!
qos-scheduler VOICE-SCHED
class VOICE
bandwidth-percent 30
buffer-percent 30
scheduling llq
drops tail-drop
!
qos-scheduler BE-SCHED
class BEST-EFFORT
bandwidth-percent 70
buffer-percent 70
scheduling wrr
drops red-drop
!
qos-map WAN-QOS
qos-scheduler VOICE-SCHED
qos-scheduler BE-SCHED
```

Task 2 - Apply the QoS map to the INET interface ge0/0 of vEdge2 in VPN 0 and shape the interface to 5000 kbps.

**vEdge2:**
```cisco
vpn 0
interface ge0/0
qos-map WAN-QOS
shaping-rate 5000
```

Task 3 - Classify the voice traffic: traffic that is marked with DSCP 46 must be placed in the class VOICE.

**vEdge2:**
```cisco
policy
access-list VOICE-ACL
sequence 10
match
dscp 46
!
action accept
class VOICE
!
!
default-action accept
vpn 10
interface ge0/2
access-list VOICE-ACL in
```

## Note
1. Verification commands: `Show policy access-list-counters`
2. The counter of sequence 10 should increase when voice traffic passes.
3. On vEdge2, remove the QoS map from ge0/0. Check the interface. vEdge2 — The voice traffic is not placed in a priority queue anymore, so it is not protected against congestion. Note: Fix it with qos-map WAN-QOS.