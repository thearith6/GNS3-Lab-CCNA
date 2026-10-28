## Lab 4 - Dual-WAN Failover with IP SLA

> **GNS3 Project:** [`Module 7 - PPPoE (CCNP) | Lab 4 - Dual-WAN Failover with IP SLA.gns3`](./Module%207%20-%20PPPoE%20%28CCNP%29%20%7C%20Lab%204%20-%20Dual-WAN%20Failover%20with%20IP%20SLA.gns3)

![topology](topology.png)

## Scenario
Use the PPPoE configuration of Lab 1 between R1 and R2. Configure the routing so that R1 can reach the loopback of R4 over the PPPoE link and over the backup link to R3.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/1: `203.0.113.1` (255.255.255.252)
  - `R2` Virtual-Template1: `10.255.0.1` (255.255.255.255)
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `R1` Ethernet0/2: `10.13.0.1` (255.255.255.252)
  - `R3` Ethernet0/0: `10.13.0.2` (255.255.255.252)
  - `R3` Ethernet0/1: `192.0.2.1` (255.255.255.252)
  - `R4` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R4` Ethernet0/1: `192.0.2.2` (255.255.255.252)
  - `R4` Loopback0: `198.51.100.1` (255.255.255.255)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Use the PPPoE configuration of Lab 1 between R1 and R2.
  - Configure the routing so that R1 can reach the loopback of R4 over the PPPoE link and over the backup link to R3.

Task 2 - Use Dialer1 as the primary exit.
  - Create an IP SLA probe that pings 198.51.100.1 from Dialer1 every 5 seconds, and track it.
  - Install the default route via Dialer1 only while the track is up.
  - Add a floating default route via R3 with an administrative distance of 10.

Task 3 - Verify the tracking and the default route.

## Action
Task 1 - Use the PPPoE configuration of Lab 1 between R1 and R2.

**R1:**
```cisco
interface Ethernet0/2
ip address 10.13.0.1 255.255.255.252
no shutdown
ip route 198.51.100.1 255.255.255.255 203.0.113.2
ip route 198.51.100.1 255.255.255.255 192.0.2.2
ip route 10.255.0.0 255.255.255.0 203.0.113.1
ip route 10.13.0.0 255.255.255.252 192.0.2.1
```

Task 2 - Use Dialer1 as the primary exit.

**R1:**
```cisco
ip sla 1
icmp-echo 198.51.100.1 source-interface Dialer1
frequency 5
ip sla schedule 1 life forever start-time now
track 1 ip sla 1 reachability
ip route 0.0.0.0 0.0.0.0 Dialer1 track 1
ip route 0.0.0.0 0.0.0.0 10.13.0.2 10
```

Task 3 - Verify the tracking and the default route.

## Note
1. Verification commands: `Show track 1`
2. The reachability should be Up. Show ip route 0.0.0.0
3. The default route should be via Dialer1.
4. On R2, shut down E 0/1 (the link to R4). The PPPoE session stays up. Check the track and the default route on R1. — After a few probes the reachability changes to Down. Show ip route 0.0.0.0 Note: The default route is now the floating route via 10.13.0.2 [10/0].
5. With E 0/1 on R2 still shut down, remove the source-interface from the IP SLA probe. Check the track on R1. — The probe now follows the routing table and can use the backup path. The track stays Up, and R1 keeps sending traffic into the broken PPPoE path. Note: Fix it by adding source-interface Dialer1 again.