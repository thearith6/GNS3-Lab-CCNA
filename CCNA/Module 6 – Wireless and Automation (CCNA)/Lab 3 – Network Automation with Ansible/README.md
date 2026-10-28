## Lab 3 - Network Automation with Ansible

> **GNS3 Project:** [`Module 6 - Automation (CCNA) | Lab 3 - Ansible.gns3`](./Module%206%20-%20Automation%20%28CCNA%29%20%7C%20Lab%203%20-%20Ansible.gns3)

![topology](topology.png)

## Scenario
Prepare R2 for SSH like R1, and create the inventory file on the control node SRV. Both routers are in the group routers and use the network_cli connection with the Cisco IOS collection.

- **Devices:** R1 (IOU L3), R2 (IOU L3), SRV (PC), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `SRV` Ethernet0: `192.168.100.50` (GW: 192.168.100.1)

Task 1 - Prepare R2 for SSH like R1, and create the inventory file on the control node SRV.
  - Both routers are in the group routers and use the network_cli connection with the Cisco IOS collection.

Task 2 - Create a playbook that sends the logs of both routers to the syslog server 192.168.100.50 and adds millisecond timestamps.
  - Run it.
  - SRV (logging.yml) --- name: Configure logging hosts: routers gather_facts: false tasks: - name: Set logging cisco.ios.ios_config: lines: - service timestamps log datetime msec - logging host 192.168.100.50 ansible-playbook -i inventory.ini logging.yml Note: Both routers should show changed=1.

Task 3 - Run the playbook a second time and check the result on the routers with an ad hoc command.
  - Configure on SRV

## Action
Task 1 - Prepare R2 for SSH like R1, and create the inventory file on the control node SRV.

**R2:**
```cisco
SRV (inventory.ini)

ip domain-name lab.local
crypto key generate rsa modulus 2048
username admin privilege 15 secret Cisco123
ip ssh version 2
line vty 0 4
login local
transport input ssh

[routers]
R1 ansible_host=192.168.100.1
R2 ansible_host=192.168.100.2
[routers:vars]
ansible_connection=ansible.netcommon.netw
ork_cli
ansible_network_os=cisco.ios.ios
ansible_user=admin
ansible_password=Cisco123
```

Task 2 - Create a playbook that sends the logs of both routers to the syslog server 192.168.100.50 and adds millisecond timestamps.

Task 3 - Run the playbook a second time and check the result on the routers with an ad hoc command.

**SRV:**
```cisco
ansible-playbook -i inventory.ini logging.yml
```

## Note
1. The result should be ok=1 changed=0 for both routers. The playbook is idempotent: it only changes what is not configured yet. ansible -i inventory.ini routers -m cisco.ios.ios_command -a "commands='show logging | include host'"
2. The output of both routers lists the logging host 192.168.100.50.
3. In logging.yml, remove the indentation of the line - name: Set logging. Run the playbook. — Ansible stops with a YAML syntax error before it connects to any router. YAML depends on the indentation.
4. In inventory.ini, change the password to Cisco124. Run the playbook. SRV — The result is UNREACHABLE with an authentication failure for both routers. Note: Fix it by entering the password Cisco123 again.