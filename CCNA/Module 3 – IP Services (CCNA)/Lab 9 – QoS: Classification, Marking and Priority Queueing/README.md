## Lab 9 - QoS: Classification, Marking and Priority Queueing

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 9 - QoS.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%209%20-%20QoS.gns3)

![topology](topology.png)

## Scenario
Classify the voice traffic on R1. Voice uses UDP ports 16384 – 32767. Mark it with DSCP EF on the inbound LAN interface and mark everything else with the default DSCP.

- **Devices:** PC1 (PC), PC2 (PC), R1 (IOU L3), R2 (IOU L3), SRV (PC), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R2` Ethernet0/0: `10.0.12.2` (255.255.255.252)
  - `R2` Ethernet0/1: `192.168.20.1` (255.255.255.0)
  - `R1` Ethernet0/0: `10.0.12.1` (255.255.255.252)
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `SRV` Ethernet0: `192.168.20.80` (GW: 192.168.20.1)

Task 1 - Classify the voice traffic on R1.
  - Voice uses UDP ports 16384 – 32767.
  - Mark it with DSCP EF on the inbound LAN interface and mark everything else with the default DSCP.

Task 2 - Protect the voice traffic on the WAN link.
  - Create a policy that gives the packets with DSCP EF a priority queue of 30 percent of the bandwidth, and treats all other traffic with fair queueing.
  - Apply it outbound on E 0/0 of R1.

Task 3 - Send voice and data traffic from PC1 and PC2 and verify the policies.

## Action
Task 1 - Classify the voice traffic on R1.

**R1:**
```cisco
ip access-list extended VOICE-TRAFFIC
permit udp any any range 16384 32767
class-map match-all VOICE
match access-group name VOICE-TRAFFIC
policy-map MARK-IN
class VOICE
set dscp ef
class class-default
set dscp default
interface Ethernet0/1
service-policy input MARK-IN
```

Task 2 - Protect the voice traffic on the WAN link.

**R1:**
```cisco
class-map match-all EF-CLASS
match dscp ef
policy-map WAN-OUT
class EF-CLASS
priority percent 30
class class-default
fair-queue
interface Ethernet0/0
service-policy output WAN-OUT
```

Task 3 - Send voice and data traffic from PC1 and PC2 and verify the policies.

## Note
1. Verification commands: `Show policy-map interface ethernet0/1 input`
2. The counters of the class VOICE should increase for the UDP traffic of PC1. Show policy-map interface ethernet0/0 output
3. The class EF-CLASS should show matched packets in the priority queue.
4. On R1, remove MARK-IN from the input of E 0/1 and apply it as output. Check the counters. — The traffic of PC1 is not marked when it enters the router, so the class EF-CLASS on the WAN link shows no priority traffic. Note: Apply the policy as input to fix it.
5. In the class EF-CLASS, match DSCP af41 instead of ef. Check the counters on E 0/0. — The voice packets are marked with EF, so they fall into class-default. They are not placed in the priority queue. Note: Fix it with match dscp ef.