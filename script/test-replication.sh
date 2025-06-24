#!/bin/bash


# Cek data di Slave 1
echo "Cek data di Slave 1 sebelum insert..."
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo "Cek data di Slave 2 sebelum insert..."
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Insert data di Master
echo "Insert data baru di Master..."
docker exec -i mysql-master mysql -uroot -psiswa -e "USE testdb; INSERT INTO employees (name, email, department, salary) VALUES ('Test User', 'user@company.com', 'ID', 55000.00);"

sleep 2

# Cek data di Slave 1
echo "Cek data di Slave 1 setelah insert..."
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Cek data di Slave 2
echo "Cek data di Slave 2 setelah insert..."
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "SELECT * FROM testdb.employees;"

# Coba delete data di Slave 1
echo "Coba delete data di Slave 1..."
docker exec -i mysql-slave1 mysql -urullabcd -prullabcd -e "USE testdb; DELETE FROM employees WHERE name='Test User';"
echo "Pasti gagal karena Slave tidak bisa melakukan operasi write."

# Coba delete data di Slave 2
echo "Coba delete data di Slave 2..."
docker exec -i mysql-slave2 mysql -urullabcd -prullabcd -e "USE testdb; DELETE FROM employees WHERE name='Test User';"
echo "Pasti gagal karena Slave tidak bisa melakukan operasi write."
