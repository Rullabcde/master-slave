#!/bin/bash

# Test 1: Insert data di Master
echo "1. Insert data baru di Master..."
docker exec mysql-master mysql -uroot -psiswa -e "
USE testdb;
INSERT INTO employees (name, email, department, salary)
VALUES ('Test User', 'test@company.com', 'QA', 55000.00);
"

sleep 2

# Test 2: Cek data di Slave 1
echo "2. Cek data di Slave 1..."
SLAVE1_COUNT=$(docker exec mysql-slave1 mysql -uroot -psiswa -se "SELECT COUNT(*) FROM testdb.employees;")
echo "Total records di Slave 1: $SLAVE1_COUNT"

# Test 3: Cek data di Slave 2
echo "3. Cek data di Slave 2..."
SLAVE2_COUNT=$(docker exec mysql-slave2 mysql -uroot -psiswa -se "SELECT COUNT(*) FROM testdb.employees;")
echo "Total records di Slave 2: $SLAVE2_COUNT"

