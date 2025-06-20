CREATE USER 'slave1'@'%' IDENTIFIED WITH mysql_native_password BY 'siswa';
GRANT REPLICATION SLAVE ON *.* TO 'slave1'@'%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees (name, email, department, salary) VALUES
('John Doe', 'john@company.com', 'IT', 75000.00),
('Jane Smith', 'jane@company.com', 'HR', 65000.00),
('Bob Johnson', 'bob@company.com', 'Finance', 70000.00),
('Alice Brown', 'alice@company.com', 'Marketing', 60000.00),
('Charlie Wilson', 'charlie@company.com', 'IT', 80000.00);
