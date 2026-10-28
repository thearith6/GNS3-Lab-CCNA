## Lab 5 - AAA with RADIUS and Local Fallback

> **GNS3 Project:** [`Module 4 - Layer 2 Security (CCNA) | Lab 5 - AAA.gns3`](./Module%204%20-%20Layer%202%20Security%20%28CCNA%29%20%7C%20Lab%205%20-%20AAA.gns3)

![topology](topology.png)

## Scenario
Configure R1 to use the RADIUS server 192.168.100.50 (SRV). Use the shared key RadKey123 and the standard ports 1812 and 1813. Put the server in a server group.

- **Devices:** PC1 (PC), R1 (IOU L3), SRV (PC), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.100.11` (GW: 192.168.100.1)
  - `SRV` Ethernet0: `192.168.100.50` (GW: 192.168.100.1)

Task 1 - Configure R1 to use the RADIUS server 192.168.100.50 (SRV).
  - Use the shared key RadKey123 and the standard ports 1812 and 1813.
  - Put the server in a server group.

Task 2 - Enable AAA for the remote logins.
  - Users authenticate with RADIUS first and with the local database if the server cannot be reached.
  - The console always uses the local database, so the router stays reachable if the server fails.
  - Create the local user backup.

Task 3 - Test the RADIUS server and verify the AAA status.
  - Configure on R1

## Action
Task 1 - Configure R1 to use the RADIUS server 192.168.100.50 (SRV).

**R1:**
```cisco
radius server RAD-SRV
address ipv4 192.168.100.50 auth-port 1812 acct-port 1813
key RadKey123
aaa new-model
aaa group server radius RAD-GROUP
server name RAD-SRV
```

Task 2 - Enable AAA for the remote logins.

**R1:**
```cisco
username backup privilege 15 secret Local123
aaa authentication login default group RAD-GROUP local
aaa authentication login CONSOLE local
aaa authorization exec default group RAD-GROUP local if-authenticated
line con 0
login authentication CONSOLE
```

Task 3 - Test the RADIUS server and verify the AAA status.

**R1:**
```cisco
test aaa group RAD-GROUP user1 Password123 new-code
```

## Note
1. The result should say User successfully authenticated. Show aaa servers
2. The server 192.168.100.50 should be in the state UP.
3. On R1, change the RADIUS key to WRONG. Test the server and try an SSH login with a RADIUS user. — The server rejects the requests because the shared key does not match. The test fails and the RADIUS users cannot log in. Note: Fix it with key RadKey123.
4. On R1, change the server address to 192.168.100.99. Log in through SSH with the local user backup. — The server does not answer. After the timeout the login falls back to the local database and the user backup can log in. Note: Fix it with the address 192.168.100.50.