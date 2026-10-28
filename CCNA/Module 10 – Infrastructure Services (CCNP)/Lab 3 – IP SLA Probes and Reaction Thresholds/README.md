## Lab 3 - IP SLA Probes and Reaction Thresholds

> **GNS3 Project:** [`Module 10 - Services (CCNP) | Lab 3 - IP SLA.gns3`](./Module%2010%20-%20Services%20%28CCNP%29%20%7C%20Lab%203%20-%20IP%20SLA.gns3)

![topology](topology.png)

## Scenario
Configure a default route on R1 towards R3 and an IP SLA operation that sends an ICMP echo to the loopback of R3 (198.51.100.1) every 10 seconds, sourced from E 0/1. Start it immediately.

- **Devices:** R1 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `10.0.13.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `R1` Ethernet0/1: `10.0.13.1` (255.255.255.252)

Task 1 - Configure a default route on R1 towards R3 and an IP SLA operation that sends an ICMP echo to the loopback of R3 (198.51.100.1) every 10 seconds, sourced from E 0/1.
  - Start it immediately.

Task 2 - Measure the quality for voice.
  - Enable the IP SLA responder on R3 and create a UDP jitter operation on R1 that uses the G.711 codec every 30 seconds.

Task 3 - Create a reaction for the ICMP operation.
  - When a probe times out, R1 must log an event and send an SNMP trap.

## Action
Task 1 - Configure a default route on R1 towards R3 and an IP SLA operation that sends an ICMP echo to the loopback of R3 (198.51.100.1) every 10 seconds, sourced from E 0/1.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 10.0.13.2
ip sla 1
icmp-echo 198.51.100.1 source-interface Ethernet0/1
frequency 10
ip sla schedule 1 life forever start-time now
```

Task 2 - Measure the quality for voice.

**R3:**
```cisco
ip sla responder
```

**R1:**
```cisco
ip sla 2
udp-jitter 198.51.100.1 16384 codec
g711ulaw
frequency 30
ip sla schedule 2 life forever start-time now
```

Task 3 - Create a reaction for the ICMP operation.

**R1:**
```cisco
ip sla reaction-configuration 1 react timeout threshold-type immediate action-type trapOnly
ip sla logging traps
snmp-server enable traps ipsla
```

## Note
1. Verification commands: `Show ip sla statistics 1`, `Show ip sla statistics 2`, `Show ip sla reaction-configuration 1`
2. The latest operation return code should be OK and the number of successes should increase.
3. The output should show the round-trip time, the jitter, the packet loss and the MOS value.
4. The reaction for timeout should be enabled with the action trapOnly.
5. On R3, shut down E 0/0 (the link to R1). Check the statistics of operation 1. R3 — The return code changes to Timeout and the failure counter increases. A timeout event is logged. Note: Fix it with no shutdown on R3.
6. On R3, remove the responder with no ip sla responder. Check the statistics of operation 2. — The UDP jitter operation fails, because R3 does not answer the control and test packets. Note: Fix it with ip sla responder on R3.