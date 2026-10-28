## Lab 6 - Application-Aware Routing with SLA Classes

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 6 - Application-Aware Routing with SLA Classes.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%206%20-%20Application-Aware%20Routing%20with%20SLA%20Classes.gns3)

![topology](topology.png)

## Scenario
On vSmart, create the SLA class VOICE (maximum loss 2 percent, latency 150 ms, jitter 30 ms), an application list for audio and video traffic, a VPN list for VPN 10 and a site list for all sites.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)

Task 1 - On vSmart, create the SLA class VOICE (maximum loss 2 percent, latency 150 ms, jitter 30 ms), an application list for audio and video traffic, a VPN list for VPN 10 and a site list for all sites.
  - Configure on vSmart

Task 2 - Create the application-aware routing policy VOICE-POLICY.
  - Voice traffic must use the MPLS transport as long as it meets the SLA class VOICE.

Task 3 - Apply the policy to all sites and verify the SLA measurements and the policy on vEdge2.
  - Configure on vSmart

## Action
Task 1 - On vSmart, create the SLA class VOICE (maximum loss 2 percent, latency 150 ms, jitter 30 ms), an application list for audio and video traffic, a VPN list for VPN 10 and a site list for all sites.

**vSmart:**
```cisco
policy
sla-class VOICE
loss 2
latency 150
jitter 30
!
lists
app-list VOICE-APPS
app-family audio_video
!
vpn-list VPN-10
vpn 10
!
site-list ALL-SITES
site-id 1-3
```

Task 2 - Create the application-aware routing policy VOICE-POLICY.

**vSmart:**
```cisco
policy
app-route-policy VOICE-POLICY
vpn-list VPN-10
sequence 10
match
app-list VOICE-APPS
!
action
sla-class VOICE preferred-color mpls
!
!
!
```

Task 3 - Apply the policy to all sites and verify the SLA measurements and the policy on vEdge2.

**vSmart:**
```cisco
apply-policy
site-list ALL-SITES
app-route-policy VOICE-POLICY
```

## Note
1. Verification commands: `Show app-route stats`
2. The loss, latency and jitter values of every tunnel should be listed. Show policy from-vsmart
3. The application-aware routing policy VOICE-POLICY should be listed.
4. In the policy, change the preferred color to lte, which no site uses. Check where the voice traffic goes. — No tunnel has the color lte, so the preference has no effect. The voice traffic is not pinned to MPLS. Note: Fix it with preferred-color mpls.
5. Make the SLA class very strict: loss 0 percent and latency 1 ms. Check the app-route statistics. — No tunnel can meet the SLA class. The traffic is no longer steered by the SLA. Note: Fix it by restoring loss 2 and latency 150.