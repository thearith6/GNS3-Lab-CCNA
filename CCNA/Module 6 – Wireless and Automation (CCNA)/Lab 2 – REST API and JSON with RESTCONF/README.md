## Lab 2 - REST API and JSON with RESTCONF

> **GNS3 Project:** [`Module 6 - Automation (CCNA) | Lab 2 - RESTCONF.gns3`](./Module%206%20-%20Automation%20%28CCNA%29%20%7C%20Lab%202%20-%20RESTCONF.gns3)

![topology](topology.png)

## Scenario
Enable RESTCONF on R1. It uses the secure HTTP server and the local user database.

- **Devices:** PC1 (PC), R1 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.100.11` (GW: 192.168.100.1)

Task 1 - Enable RESTCONF on R1.
  - It uses the secure HTTP server and the local user database.

Task 2 - From PC1, read the interface configuration of R1 with a GET request.
  - Ask for JSON.

Task 3 - Change the description of E 0/0 with a PATCH request and verify the change on R1.
  - Configure on PC1

## Action
Task 1 - Enable RESTCONF on R1.

**R1:**
```cisco
username admin privilege 15 secret Cisco123
ip http secure-server
ip http authentication local
restconf
```

Task 2 - From PC1, read the interface configuration of R1 with a GET request.

**PC1:**
```cisco
curl -k -u admin:Cisco123 -H "Accept: application/yang-data+json"
https://192.168.100.1/restconf/data/ietf-interfaces:interfaces
```

Task 3 - Change the description of E 0/0 with a PATCH request and verify the change on R1.

**PC1:**
```cisco
curl -k -u admin:Cisco123 -X PATCH -H
"Content-Type: application/yang-data+json"
-H "Accept: application/yang-data+json" http
s://192.168.100.1/restconf/data/ietf-interfa
ces:interfaces/interface=Ethernet0%2F0 -d '{"
ietf-interfaces:interface":{"name":"Ethernet0/
0","description":"Managed by REST"}}'
```

## Note
1. Verification commands: `Show running-config interface ethernet0/0`
2. The response is a JSON document. The top element is ietf-interfaces:interfaces with a list called interface. Every entry has the keys name, description and enabled.
3. The interface should have the description Managed by REST.
4. The status code is 204 No Content.
5. Repeat the PATCH request with the header Content-Type: application/json. PC1 — The router answers with 415 Unsupported Media Type. RESTCONF needs the type application/yang-data+json.
6. On R1, remove RESTCONF with no restconf. Repeat the GET request. R1 — The request fails because the RESTCONF service is not available any more. Note: Fix it with restconf.