---
title: 3A6000上搭建gogs
author: Ayden Meng
categories: 3. 应用
toc: true
---

```
pacman -S mariadb
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysql
mariadb --initialize-insecure --user=mysql --datadir='./data'
mysql -u root

[root@mxd gitrepo]# mysql -u root
mysql: Deprecated program name. It will be removed in a future release, use '/usr/bin/mariadb' instead
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 11.0.2-MariaDB Arch Linux

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create user 'gogs'@'localhost' identified by 'passwd';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> select user,host from mysql.user;
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| PUBLIC      |           |
|             | localhost |
| gogs        | localhost |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
|             | mxd       |
+-------------+-----------+
7 rows in set (0.001 sec)

MariaDB [(none)]> CREATE DATABASE gogs;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| gogs               |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
6 rows in set (0.000 sec)

MariaDB [(none)]> grant all privileges on gogs.* to 'gogs'@'%' identified by 'passwd' with grant option;
Query OK, 0 rows affected (0.001 sec)

```

build gogs:
```
pacman -S go node npm
git clone --depth 1 https://github.com/gogs/gogs.git gogs
cd gogs
go build -o gogs
./gogs web
```
