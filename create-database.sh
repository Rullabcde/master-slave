#!/bin/bash

# Create Database for Replication
echo "Creating Database..."
docker exec -it mysql-master bash
mysql -uroot -psiswa -e "CREATE DATABASE IF NOT EXISTS testdb;"
mysql -uroot -psiswa -e "USE testdb; CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);"
mysql -uroot -psiswa -e "INSERT INTO testdb.employees (name, email, department, salary) VALUES ('John Doe', 'john@company.com', 'IT', 75000.00);"
mysql -uroot -psiswa -e "INSERT INTO testdb.employees (name, email, department, salary) VALUES ('Jane Smith', 'jane@company.com', 'HR', 65000.00);"
echo "Database and table created successfully."

