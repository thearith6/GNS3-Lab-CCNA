## Lab 4 - HSRP with Interface Tracking

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 3 - HSRP with Interface Tracking.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%203%20-%20HSRP%20with%20Interface%20Tracking.gns3)

![topo](image_4.png)

## Scenario
Configure HSRP version 2 for the 192.168.10.0/24 network. R1 and R2 use group 10 and the virtual IP address 192.168.10.1. R1 must be the active router (priority 110). Enable preemption on both routers.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.2` (255.255.255.0)
  - `R1` Ethernet0/1: `10.0.13.1` (255.255.255.252)
  - `R3` Ethernet0/0: `10.0.13.2` (255.255.255.252)
  - `R3` Ethernet0/1: `10.0.23.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `R2` Ethernet0/0: `192.168.10.3` (255.255.255.0)
  - `R2` Ethernet0/1: `10.0.23.1` (255.255.255.252)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure HSRP version 2 for the 192.168.10.0/24 network.
  - R1 and R2 use group 10 and the virtual IP address 192.168.10.1.
  - R1 must be the active router (priority 110).
  - Enable preemption on both routers.

Task 2 - Configure R1 to track its uplink E 0/1.
  - When the interface goes down, R1 must lower its HSRP priority by 20 so that R2 becomes the active router.

Task 3 - Configure the routing towards R3 and verify that PC1 can reach the loopback of R3.
  - Configure on R1

## Action
Task 1 - Configure HSRP version 2 for the 192.168.10.0/24 network.

**R1:**
```cisco
interface Ethernet0/0
standby version 2
standby 10 ip 192.168.10.1
standby 10 priority 110
standby 10 preempt
```

**R2:**
```cisco
interface Ethernet0/0
standby version 2
standby 10 ip 192.168.10.1
standby 10 preempt
```

Task 2 - Configure R1 to track its uplink E0/1.

**R1:**
```cisco
track 1 interface Ethernet0/1 line-protocol
interface Ethernet0/0
standby 10 track 1 decrement 20
```

Task 3 - Configure the routing towards R3 and verify that PC1 can reach the loopback of R3.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 10.0.13.2
```
**R2:**
```cisco
ip route 0.0.0.0 0.0.0.0 10.0.23.2
```
**R3:**
```cisco
ip route 192.168.10.0 255.255.255.0 10.0.13.1
ip route 192.168.10.0 255.255.255.0 10.0.23.1 10
```
![Task-3](image.png)

## Note
1. Verification commands: `Show standby brief`

![Verification](image_1.png)

  - R1 is Active with priority 110 and R2 should be Standby. PC1: Ping 198.51.100.1 The ping succeed.
2. On R1, shut down E 0/1. Check the HSRP state on R1 and R2. R1 — R2 should now be Active.

![Breakit-1](image_2.png)

PC1 ping R3 loopback failed, because GNS3, R3 still route back via R1.
  - For GNS3, IP SLA or manual shut R3's E0/0.
  - In real hardware, R3 will detect when R1 int shutdown and will install route via R2.
![Breakit-1.1](image_3.png)
