## Lab 1 - PPPoE Server and Client with CHAP

> **GNS3 Project:** [`Module 7 - PPPoE (CCNP) | Lab 1 - PPPoE Server and Client with CHAP.gns3`](./Module%207%20-%20PPPoE%20%28CCNP%29%20%7C%20Lab%201%20-%20PPPoE%20Server%20and%20Client%20with%20CHAP.gns3)

![topology](topology.png)

## Scenario
Configure R2 as a PPPoE server. Create a BBA group that uses Virtual-Template 1. Clients authenticate with CHAP and get an address from the pool 10.255.0.10 – 10.255.0.50. Create the user CPE1 with the password PPPoE123 and enable PPPoE on E 0/0.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/1: `203.0.113.1` (255.255.255.252)
  - `R2` Virtual-Template1: `10.255.0.1` (255.255.255.255)
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `R3` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure R2 as a PPPoE server.
  - Create a BBA group that uses Virtual-Template 1.
  - Clients authenticate with CHAP and get an address from the pool 10.255.0.10 – 10.255.0.50.
  - Create the user CPE1 with the password PPPoE123 and enable PPPoE on E 0/0.

Task 2 - Configure R1 as the PPPoE client.
  - Authenticate with CHAP using the hostname CPE1 and the password PPPoE123.
  - R1 must get its IP address through PPP negotiation.

Task 3 - Verify the PPPoE session on both routers.

## Action
Task 1 - Configure R2 as a PPPoE server.

**R2:**
```cisco
username CPE1 password PPPoE123
ip local pool PPPOE-POOL 10.255.0.10 10.255.0.50
bba-group pppoe BBA1
virtual-template 1
interface Virtual-Template1
ip address 10.255.0.1 255.255.255.255
peer default ip address pool PPPOE-POOL
ppp authentication chap
interface Ethernet0/0
no ip address
pppoe enable group BBA1
no shutdown
```

Task 2 - Configure R1 as the PPPoE client.

**R1:**
```cisco
interface Ethernet0/0
no ip address
pppoe-client dial-pool-number 1
no shutdown
interface Dialer1
ip address negotiated
encapsulation ppp
dialer pool 1
ppp chap hostname CPE1
ppp chap password PPPoE123
```

Task 3 - Verify the PPPoE session on both routers.

## Note
1. Verification commands: `Show pppoe session`, `Show ip interface brief`
2. One session should be in the UP state.
3. One session should be listed in the LOCALLY_TERMINATED state.
4. Dialer1 should have an address from 10.255.0.10 – 10.255.0.50.
5. On R1, change the CHAP password to WRONG and restart Dialer1. Check the PPPoE session. — The PPP authentication fails. Dialer1 does not get an IP address. Note: Fix it with ppp chap password PPPoE123.
6. On R2, remove pppoe enable from E 0/0. Check the PPPoE session on R1. R2 — R2 ignores the PPPoE discovery packets. R1 shows no session. Note: Fix it with pppoe enable group BBA1.