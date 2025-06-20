#!/bin/bash


# Cek data di Slave 1
echo "Cek data di Slave 1 sebelum insert..."
docker exec -i mysql-slave1 mysql -uroot -psiswa -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo "Cek data di Slave 2 sebelum insert..."
docker exec -i mysql-slave2 mysql -uroot -psiswa -e "SELECT * FROM testdb.employees;"

# Insert data di Master
echo "Insert data baru di Master..."
docker exec -i mysql-master mysql -uroot -psiswa -e "USE testdb; INSERT INTO employees (name, email, department, salary) VALUES ('Test User', 'user@company.com', 'ID', 55000.00);"

sleep 2

# Cek data di Slave 1
echo "Cek data di Slave 1 setelah insert..."
docker exec -i mysql-slave1 mysql -uroot -psiswa -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo "Cek data di Slave 2 setelah insert..."
docker exec -i mysql-slave2 mysql -uroot -psiswa -e "SELECT * FROM testdb.employees;"
