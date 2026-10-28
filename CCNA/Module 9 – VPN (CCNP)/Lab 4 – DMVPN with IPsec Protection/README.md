## Lab 4 - DMVPN with IPsec Protection

> **GNS3 Project:** [`Module 9 - VPN (CCNP) | Lab 4 – DMVPN with IPsec Protection.gns3`](./Module%209%20-%20VPN%20%28CCNP%29%20%7C%20Lab%204%20%E2%80%93%20DMVPN%20with%20IPsec%20Protection.gns3)

![topology](topology.png)

## Scenario
Starting from Lab 3, configure IKEv2 on the hub and on both spokes. The spokes have changing addresses in practice, so use a wildcard keyring and profile with the pre-shared key DmvpnKey123. HUB, SPOKE1 and SPOKE2 crypto ikev2 proposal DM-PROP encryption aes-cbc-256 integrity sha256 group 14 crypto ikev2 policy DM-POL proposal DM-PROP crypto ikev2 keyring DM-KEYS peer ANY address 0.0.0.0 0.0.0.0 pre-shared-key DmvpnKey123 crypto ikev2 profile DM-PROF match identity remote address 0.0.0.0 authentication remote pre-share authentication local pre-share keyring local DM-KEYS

- **Devices:** HUB (IOU L3), SPOKE1 (IOU L3), SPOKE2 (IOU L3), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `SPOKE2` Ethernet0/0: `203.0.113.3` (255.255.255.0)
  - `SPOKE2` Loopback1: `192.168.3.1` (255.255.255.0)
  - `SPOKE1` Ethernet0/0: `203.0.113.2` (255.255.255.0)
  - `SPOKE1` Loopback1: `192.168.2.1` (255.255.255.0)
  - `HUB` Ethernet0/0: `203.0.113.1` (255.255.255.0)
  - `HUB` Loopback1: `192.168.1.1` (255.255.255.0)

Task 1 - Starting from Lab 3, configure IKEv2 on the hub and on both spokes.
  - The spokes have changing addresses in practice, so use a wildcard keyring and profile with the pre-shared key DmvpnKey123.
  - HUB, SPOKE1 and SPOKE2 crypto ikev2 proposal DM-PROP encryption aes-cbc-256 integrity sha256 group 14 crypto ikev2 policy DM-POL proposal DM-PROP crypto ikev2 keyring DM-KEYS peer ANY address 0.0.0.0 0.0.0.0 pre-shared-key DmvpnKey123 crypto ikev2 profile DM-PROF match identity remote address 0.0.0.0 authentication remote pre-share authentication local pre-share keyring local DM-KEYS

Task 2 - Create the IPsec profile with ESP in transport mode (GRE already adds the tunnel header) and protect the tunnel interface on all three routers.
  - HUB, SPOKE1 and SPOKE2 crypto ipsec transform-set DM-TS esp-aes 256 esp-sha256-hmac mode transport crypto ipsec profile DM-IPSEC set transform-set DM-TS set ikev2-profile DM-PROF interface Tunnel0 tunnel protection ipsec profile DM-IPSEC

Task 3 - Verify the IKEv2 sessions and the DMVPN status on the hub, and the connectivity from SPOKE1.

## Action
Task 1 - Starting from Lab 3, configure IKEv2 on the hub and on both spokes.

Task 2 - Create the IPsec profile with ESP in transport mode (GRE already adds the tunnel header) and protect the tunnel interface on all three routers.

Task 3 - Verify the IKEv2 sessions and the DMVPN status on the hub, and the connectivity from SPOKE1.

## Note
1. Verification commands: `Show crypto ikev2 sa`, `Ping 192.168.3.1 source loopback1`, `Show dmvpn`
2. Two IKEv2 SAs with the status READY should be listed, one for each spoke.
3. The ping should succeed.
4. Both spokes should be in the state UP.
5. On SPOKE2, change the key in the keyring to WrongKey. Check the sessions on the hub. — The authentication fails. The hub only has the IKEv2 SA of SPOKE1, and the NHRP registration of SPOKE2 does not complete. Note: Fix it with the key DmvpnKey123.
6. On SPOKE1, change the transform set mode to tunnel (mode tunnel). Restart the tunnel. — The hub uses transport mode. The IPsec proposals do not match and no IPsec SA is created for SPOKE1. Note: Fix it with mode transport.