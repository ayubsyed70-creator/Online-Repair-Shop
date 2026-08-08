# Online Repair Shop — Products Table & Queries

**Source:** `products.sql`
**Tested against:** SQLite 3 (portable — same syntax works in MySQL/Postgres with minor type tweaks)

## Schema

Two tables, so the JOIN query has something real to join against:
- `suppliers` — who each product is sourced from
- `products` — the repair parts inventory, each linked to a supplier

## Sample data (5 rows in `products`)

| product_id | product_name | category | price | stock_quantity | supplier_id |
|---|---|---|---|---|---|
| 1 | iPhone 13 Screen | Screen | 89.99 | 25 | 1 |
| 2 | Samsung Galaxy Battery | Battery | 24.50 | 60 | 2 |
| 3 | USB-C Charging Port | Charging | 12.75 | 100 | 1 |
| 4 | Laptop Keyboard (15in) | Keyboard | 34.00 | 15 | 3 |
| 5 | Tablet Digitizer | Screen | 45.20 | 20 | 2 |

---

## 1. SELECT — products priced over $20, cheapest first

```sql
SELECT product_name, category, price
FROM products
WHERE price > 20
ORDER BY price ASC;
```

| product_name | category | price |
|---|---|---|
| Samsung Galaxy Battery | Battery | 24.5 |
| Laptop Keyboard (15in) | Keyboard | 34 |
| Tablet Digitizer | Screen | 45.2 |
| iPhone 13 Screen | Screen | 89.99 |

*(4 rows — the $12.75 charging port is correctly excluded)*

---

## 2. GROUP BY — total stock and average price per category

```sql
SELECT category,
       COUNT(*)             AS num_products,
       SUM(stock_quantity)  AS total_stock,
       ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
ORDER BY total_stock DESC;
```

| category | num_products | total_stock | avg_price |
|---|---|---|---|
| Charging | 1 | 100 | 12.75 |
| Battery | 1 | 60 | 24.5 |
| Screen | 2 | 45 | 67.59 |
| Keyboard | 1 | 15 | 34.0 |

*(Screen is the only category with 2 products, so it's the only row where `avg_price` isn't just that single product's price)*

---

## 3. JOIN — each product with its supplier

```sql
SELECT p.product_name, p.category, p.price, s.supplier_name
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY s.supplier_name, p.product_name;
```

| product_name | category | price | supplier_name |
|---|---|---|---|
| Laptop Keyboard (15in) | Keyboard | 34 | GadgetCore Ltd. |
| Samsung Galaxy Battery | Battery | 24.5 | MobileFix Supplies |
| Tablet Digitizer | Screen | 45.2 | MobileFix Supplies |
| USB-C Charging Port | Charging | 12.75 | TechParts Inc. |
| iPhone 13 Screen | Screen | 89.99 | TechParts Inc. |

*(5 rows — every product has a supplier, so INNER JOIN doesn't drop anything here; if a product had a NULL `supplier_id`, INNER JOIN would silently exclude it — worth testing with LEFT JOIN to compare, per the AI-twist below)*

---

## AI-twist checklist (do this part yourself)

1. Ask an AI tool to generate each of the 3 queries above from a plain-English description only (e.g. *"products over $20, cheapest first"*) — don't show it your SQL.
2. Run its version and **diff the row count** against the results here.
   - SELECT should return **4 rows**
   - GROUP BY should return **4 rows** (one per category)
   - JOIN should return **5 rows**
3. Common mismatches to watch for:
   - AI using `>=` instead of `>` on the price filter (would return 5 rows, not 4)
   - AI using `LEFT JOIN` instead of `INNER JOIN` (harmless here since every product has a supplier, but would matter with incomplete data)
   - AI rounding `avg_price` differently or omitting `ROUND()`
