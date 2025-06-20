#!/bin/bash

# Master Status
echo "Mendapatkan Master Status..."
MASTER_STATUS=$(docker exec mysql-master mysql -uroot -psiswa -e "SHOW MASTER STATUS\G")
echo "$MASTER_STATUS"

# Extract binary log file dan position
MASTER_LOG_FILE=$(echo "$MASTER_STATUS" | grep "File:" | awk '{print $2}')
MASTER_LOG_POS=$(echo "$MASTER_STATUS" | grep "Position:" | awk '{print $2}')

echo "Master Log File: $MASTER_LOG_FILE"
echo "Master Log Position: $MASTER_LOG_POS"

# Setup Slave 1
echo "Konfigurasi Slave 1"
docker exec mysql-slave1 mysql -uroot -psiswa -e "
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='mysql-master',
    MASTER_USER='slave1',
    MASTER_PASSWORD='siswa',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
"

# Setup Slave 2
echo "Konfigurasi Slave 2"
docker exec mysql-slave2 mysql -uroot -psiswa -e "
STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='mysql-master',
    MASTER_USER='slave1',
    MASTER_PASSWORD='siswa',
    MASTER_LOG_FILE='$MASTER_LOG_FILE',
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
"

# Cek status replikasi
echo "Status Replikasi Slave 1"
docker exec mysql-slave1 mysql -uroot -psiswa -e "SHOW SLAVE STATUS\G" | grep -E "(Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master)"

echo "Status Replikasi Slave 2"
docker exec mysql-slave2 mysql -uroot -psiswa -e "SHOW SLAVE STATUS\G" | grep -E "(Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master)"
