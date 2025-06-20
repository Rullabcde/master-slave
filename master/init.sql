CREATE USER 'slave1'@'%' IDENTIFIED WITH mysql_native_password BY 'siswa';
GRANT REPLICATION SLAVE ON *.* TO 'slave1'@'%';
FLUSH PRIVILEGES;
