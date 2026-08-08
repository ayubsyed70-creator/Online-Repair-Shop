-- Online Repair Shop — Products table, sample data, and practice queries
-- Run with: sqlite3 repair_shop.db < products.sql   (or paste into any SQL client)

CREATE TABLE suppliers (
    supplier_id   INTEGER PRIMARY KEY,
    supplier_name TEXT NOT NULL,
    contact_email TEXT
);

CREATE TABLE products (
    product_id     INTEGER PRIMARY KEY,
    product_name   TEXT NOT NULL,
    category       TEXT NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    supplier_id    INTEGER,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

INSERT INTO suppliers (supplier_id, supplier_name, contact_email) VALUES
    (1, 'TechParts Inc.',      'orders@techparts.com'),
    (2, 'MobileFix Supplies',  'sales@mobilefix.com'),
    (3, 'GadgetCore Ltd.',     'contact@gadgetcore.com');

INSERT INTO products (product_id, product_name, category, price, stock_quantity, supplier_id) VALUES
    (1, 'iPhone 13 Screen',       'Screen',   89.99, 25, 1),
    (2, 'Samsung Galaxy Battery', 'Battery',  24.50, 60, 2),
    (3, 'USB-C Charging Port',    'Charging', 12.75, 100, 1),
    (4, 'Laptop Keyboard (15in)', 'Keyboard', 34.00, 15, 3),
    (5, 'Tablet Digitizer',       'Screen',   45.20, 20, 2);

-- ============================================================
-- 1. SELECT — products priced over $20, cheapest first
-- ============================================================
SELECT product_name, category, price
FROM products
WHERE price > 20
ORDER BY price ASC;

-- ============================================================
-- 2. GROUP BY — total stock and average price per category
-- ============================================================
SELECT category,
       COUNT(*)             AS num_products,
       SUM(stock_quantity)  AS total_stock,
       ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
ORDER BY total_stock DESC;

-- ============================================================
-- 3. JOIN — each product with its supplier
-- ============================================================
SELECT p.product_name, p.category, p.price, s.supplier_name
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY s.supplier_name, p.product_name;
