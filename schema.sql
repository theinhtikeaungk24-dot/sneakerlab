-- SneakerLab Database Setup
-- Run this script once in MySQL before starting the app.
-- Admin password: admin123  (SHA-256 hashed below)

CREATE DATABASE IF NOT EXISTS sneakerlab CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sneakerlab;

-- USERS
CREATE TABLE IF NOT EXISTS users (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(64)  NOT NULL,   -- SHA-256 hex (64 chars)
    email    VARCHAR(100) NOT NULL,
    role     ENUM('admin','customer') NOT NULL DEFAULT 'customer'
);

-- Default admin account  (password = admin123)
INSERT IGNORE INTO users (username, password, email, role)
VALUES ('admin',
        '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
        'admin@sneakerlab.com',
        'admin');

-- SNEAKERS
CREATE TABLE IF NOT EXISTS sneakers (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    brand     VARCHAR(50)    NOT NULL,
    model     VARCHAR(100)   NOT NULL,
    size      DECIMAL(4,1)   NOT NULL,
    color     VARCHAR(50),
    price     DECIMAL(10,2)  NOT NULL,
    stock     INT            NOT NULL DEFAULT 0,
    image_url VARCHAR(255)
);

-- Sample data
INSERT IGNORE INTO sneakers (id, brand, model, size, color, price, stock, image_url) VALUES
(1, 'Nike',        'Air Max 270',       42.0, 'White/Black',  129.99, 15, ''),
(2, 'Adidas',      'Ultraboost 22',     41.5, 'Core Black',   159.99, 10, ''),
(3, 'New Balance', '574 Classic',       43.0, 'Navy Blue',     89.99,  8, '');

-- ORDERS
CREATE TABLE IF NOT EXISTS orders (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT            NOT NULL,
    sneaker_id  INT            NOT NULL,
    quantity    INT            NOT NULL DEFAULT 1,
    total       DECIMAL(10,2)  NOT NULL,
    status      ENUM('pending','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
    order_date  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)    REFERENCES users(id),
    FOREIGN KEY (sneaker_id) REFERENCES sneakers(id)
);
