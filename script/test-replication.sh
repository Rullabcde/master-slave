#!/bin/bash

GREEN="\033[0;32m"
NC="\033[0m"

# Cek data di Slave 1
echo -e "${Green}Cek data di Slave 1 sebelum insert${NC}"
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo -e "${Green}Cek data di Slave 2 sebelum insert${NC}"
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Insert data di Master
echo -e "${Green}Insert data baru di Master${NC}"
docker exec -i mysql-master mysql -uroot -psiswa -e "USE testdb; INSERT INTO employees (name, email, department, salary) VALUES ('Test User', 'user@company.com', 'ID', 55000.00);"

sleep 2

# Cek data di Slave 1
echo -e "${Green}Cek data di Slave 1 setelah insert${NC}"
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo -e "${Green}Cek data di Slave 2 setelah insert${NC}"
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Coba delete data di Slave 1
echo -e "${Green}Coba delete data di Slave 1${NC}"
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "USE testdb; DELETE FROM employees WHERE name='Test User';"
echo -e "${Green}Pasti gagal karena Slave hanya untuk read-only${NC}"

# Coba delete data di Slave 2
echo -e "${Green}Coba delete data di Slave 1${NC}"
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "USE testdb; DELETE FROM employees WHERE name='Test User';"
echo -e "${Green}Pasti gagal karena Slave hanya untuk read-only${NC}"

