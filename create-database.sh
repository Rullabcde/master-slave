#!/bin/bash

# Create Database for Replication
echo "Creating Database..."
docker exec -i mysql-master mysql -uroot -psiswa -e "
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);
INSERT INTO employees (name, email, department, salary) VALUES 
('John Doe', 'john@company.com', 'IT', 75000.00),
('Jane Smith', 'jane@company.com', 'HR', 65000.00);
"
echo "Database and table created successfully."

