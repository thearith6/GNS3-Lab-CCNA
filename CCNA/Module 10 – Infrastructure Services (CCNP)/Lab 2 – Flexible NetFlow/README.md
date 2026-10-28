## Lab 2 - Flexible NetFlow

> **GNS3 Project:** [`Module 10 - Services (CCNP) | Lab 2 - NetFlow.gns3`](./Module%2010%20-%20Services%20%28CCNP%29%20%7C%20Lab%202%20-%20NetFlow.gns3)

![topology](topology.png)

## Scenario
Create a flow record that collects the source and destination addresses, the protocol, the source and destination ports, and the number of bytes and packets.

- **Devices:** PC1 (PC), R1 (IOU L3), SRV1 (PC)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `R1` Ethernet0/1: `192.168.20.1` (255.255.255.0)
  - `SRV1` Ethernet0: `192.168.20.80` (GW: 192.168.20.1)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Create a flow record that collects the source and destination addresses, the protocol, the source and destination ports, and the number of bytes and packets.
  - Configure on R1

Task 2 - Create a flow exporter that sends the data in NetFlow v9 format to the collector SRV1 (192.168.20.80) on UDP port 2055.
  - Create a flow monitor with the record and the exporter and apply it to the traffic entering E 0/0.

Task 3 - Send traffic from PC1 and PC2 to SRV1 and verify the flow cache and the exporter.

## Action
Task 1 - Create a flow record that collects the source and destination addresses, the protocol, the source and destination ports, and the number of bytes and packets.

**R1:**
```cisco
flow record REC-IPV4
match ipv4 source address
match ipv4 destination address
match ipv4 protocol
match transport source-port
match transport destination-port
collect counter bytes
collect counter packets
```

Task 2 - Create a flow exporter that sends the data in NetFlow v9 format to the collector SRV1 (192.168.20.80) on UDP port 2055.

**R1:**
```cisco
flow exporter EXP
destination 192.168.20.80
source Ethernet0/1
transport udp 2055
export-protocol netflow-v9
flow monitor MON
record REC-IPV4
exporter EXP
interface Ethernet0/0
ip flow monitor MON input
```

Task 3 - Send traffic from PC1 and PC2 to SRV1 and verify the flow cache and the exporter.

## Note
1. Verification commands: `Show flow monitor MON cache`
2. The cache should contain the flows of PC1 and PC2 with the addresses, ports and the byte and packet counters. Show flow exporter EXP statistics
3. The number of packets sent to 192.168.20.80 should increase.
4. On R1, remove the monitor from E 0/0. Send traffic from PC1 and check the cache. R1 — No new flows are added to the cache, because no interface uses the monitor. Note: Fix it with ip flow monitor MON input.
5. On R1, change the exporter destination to 192.168.20.99. Check the exporter statistics. — The router keeps exporting, but the collector at 192.168.20.80 receives nothing, because the destination does not exist. Note: Fix it with destination 192.168.20.80.