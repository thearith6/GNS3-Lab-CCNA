## Lab 1 - Installing the Zabbix Server

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 1 – Installing the Zabbix Server.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%201%20%E2%80%93%20Installing%20the%20Zabbix%20Server.gns3)

![topology](topology.png)

## Scenario
Install the Zabbix 7.0 LTS repository package for your Ubuntu version (from repo.zabbix.com) on the server ZABBIX. Install the server, the web frontend, the Apache configuration, the SQL scripts, the agent and the MariaDB database.

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Install the Zabbix 7.0 LTS repository package for your Ubuntu version (from repo.zabbix.com) on the server ZABBIX.
  - Install the server, the web frontend, the Apache configuration, the SQL scripts, the agent and the MariaDB database.

Task 2 - Create the database zabbix and the user zabbix.
  - Import the initial schema, then enter the database password in the server configuration and start the services.

Task 3 - Finish the installation in the web interface and verify the server.
  - ZABBIX (Web GUI)

## Action
Task 1 - Install the Zabbix 7.0 LTS repository package for your Ubuntu version (from repo.zabbix.com) on the server ZABBIX.

**ZABBIX:**
```cisco
apt update
apt install -y mariadb-server
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts
zabbix-agent
```

Task 2 - Create the database zabbix and the user zabbix.

**ZABBIX:**
```cisco
mysql -uroot
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'ZbxPass123';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
quit
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql
--default-character-set=utf8mb4 -uzabbix -p zabbix
mysql -uroot
set global log_bin_trust_function_creators = 0;
quit
/etc/zabbix/zabbix_server.conf
DBPassword=ZbxPass123
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
```

Task 3 - Finish the installation in the web interface and verify the server.

**ZABBIX:**
```cisco
Open http://192.168.100.50/zabbix
Database type: MySQL
Database host: localhost
Database name: zabbix
User / Password: zabbix / ZbxPass123
Zabbix server name: LAB-NOC

systemctl status zabbix-server

Log in with the user Admin and the password
zabbix, then change the password.
Monitoring > Hosts
```

## Note
1. The service should be active (running).
2. The host Zabbix server should be listed with a green ZBX availability icon.
3. In /etc/zabbix/zabbix_server.conf, enter the wrong password (DBPassword=WrongPass) and restart zabbix-server. — The service fails to start. tail /var/log/zabbix/zabbix_server.log Note: The log says that the server cannot connect to the database. Note: Fix it with DBPassword=ZbxPass123.
4. Stop the web server with systemctl stop apache2. Open the web interface. ZABBIX — The web interface is not reachable. The monitoring keeps running because zabbix-server is a separate service. Note: Fix it with systemctl start apache2.