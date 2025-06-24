#!/bin/bash

GREEN="\033[0;32m"
NC="\033[0m"

# Tunggu container siap
sleep 30

echo -e "${Green}Mendapatkan Master Status${NC}"
MASTER_STATUS=$(docker exec -i mysql-master mysql -uroot -psiswa -e "SHOW MASTER STATUS\G")
echo "$MASTER_STATUS"

# Extract binary log file dan position
MASTER_LOG_FILE=$(echo "$MASTER_STATUS" | grep "File:" | awk '{print $2}')
MASTER_LOG_POS=$(echo "$MASTER_STATUS" | grep "Position:" | awk '{print $2}')

echo "Master Log File: $MASTER_LOG_FILE"
echo "Master Log Position: $MASTER_LOG_POS"

# Setup Slave 1
echo -e "${Green}Konfigurasi Slave 1${NC}"
docker exec -i mysql-slave1 mysql -uroot -psiswa -e "
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='mysql-master',
    MASTER_USER='slave1',
    MASTER_PASSWORD='siswa',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
"
# Buat user untuk akses baca
docker exec -i mysql-slave1 mysql -uroot -psiswa -e "
CREATE USER 'rullabcd'@'%' IDENTIFIED BY 'rullabcd';
GRANT SELECT ON *.* TO 'rullabcd'@'%';
FLUSH PRIVILEGES;
"

# Setup Slave 2
echo -e "${Green}Konfigurasi Slave 2${NC}"
docker exec -i mysql-slave2 mysql -uroot -psiswa -e "
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='mysql-master',
    MASTER_USER='slave1',
    MASTER_PASSWORD='siswa',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
"
# Buat user untuk akses baca
docker exec -i mysql-slave2 mysql -uroot -psiswa -e "
CREATE USER 'rullabcd'@'%' IDENTIFIED BY 'rullabcd';
GRANT SELECT ON *.* TO 'rullabcd'@'%';
FLUSH PRIVILEGES;
"

# Cek status replikasi
echo -e "${Green}Status Replikasi Slave 1${NC}"
docker exec -i mysql-slave1 mysql -uroot -psiswa -e "SHOW SLAVE STATUS\G" | grep -E "(Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master)"

echo -e "${Green}Status Replikasi Slave 2${NC}"
docker exec -i mysql-slave2 mysql -uroot -psiswa -e "SHOW SLAVE STATUS\G" | grep -E "(Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master)"
