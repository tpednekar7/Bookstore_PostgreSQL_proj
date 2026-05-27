# 📚 Online Bookstore — SQL Project

A structured SQL project built on a simulated online bookstore database using PostgreSQL and pgAdmin. The project spans 59 queries across 3 related tables, covering everything from basic filtering to advanced window functions, CTEs, and business insights.

---

## 🗃️ Database Schema

Three tables connected via foreign keys:

### `books`
| Column | Type | Description |
|--------|------|-------------|
| `book_id` | SERIAL PK | Unique book identifier |
| `title` | VARCHAR(100) | Title of the book |
| `author` | VARCHAR(100) | Author name |
| `genre` | VARCHAR(50) | Genre (e.g., Fiction, Fantasy, Mystery) |
| `published_year` | INT | Year of publication |
| `price` | NUMERIC(10,2) | Price in dollars |
| `stock` | INT | Available stock units |

### `customers`
| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | SERIAL PK | Unique customer identifier |
| `name` | VARCHAR(100) | Customer full name |
| `email` | VARCHAR(100) | Email address |
| `phone` | VARCHAR(15) | Phone number |
| `city` | VARCHAR(50) | City |
| `country` | VARCHAR(150) | Country |

### `orders`
| Column | Type | Description |
|--------|------|-------------|
| `order_id` | SERIAL PK | Unique order identifier |
| `customer_id` | INT FK | References `customers(customer_id)` |
| `book_id` | INT FK | References `books(book_id)` |
| `order_date` | DATE | Date the order was placed |
| `quantity` | INT | Number of units ordered |
| `total_amount` | NUMERIC(10,2) | Total order value |

---

## 🛠️ Tools Used

- **PostgreSQL** — Relational database
- **pgAdmin 4** — GUI for database management and query execution

---

## 🚀 Getting Started

### 1. Prerequisites
- PostgreSQL installed (v13 or above recommended)
- pgAdmin 4

### 2. Create the Tables

```sql
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    book_id        SERIAL PRIMARY KEY,
    title          VARCHAR(100),
    author         VARCHAR(100),
    genre          VARCHAR(50),
    published_year INT,
    price          NUMERIC(10,2),
    stock          INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100),
    phone       VARCHAR(15),
    city        VARCHAR(50),
    country     VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers(customer_id),
    book_id      INT REFERENCES books(book_id),
    order_date   DATE,
    quantity     INT,
    total_amount NUMERIC(10,2)
);
```

### 3. Import the Data

**Option A — pgAdmin Import (Recommended):**
1. Right-click the table → **Import/Export Data**
2. Select the corresponding CSV file, enable the header toggle, set delimiter to `,`
3. Click OK
4. Repeat for all three tables: `books`, `customers`, `orders`

> ⚠️ **Encoding Issue Fix:** If you get a UTF-8 error, open the CSV in Excel → Save As → choose **CSV UTF-8 (Comma delimited)** format, then re-import.

**Option B — COPY Command:**
```sql
COPY books FROM 'C:/your/path/books.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY customers FROM 'C:/your/path/customers.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
COPY orders FROM 'C:/your/path/orders.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
```

---

## 🔍 Analysis Breakdown

### 1. 📋 Basic Queries
- Total number of books, customers, and orders
- Filter books by genre, author, and published year
- Find books priced above a certain value
- List customers from a specific city or country
- Average price of books in a genre (e.g., Fantasy)
- Total books sold per genre

### 2. 🔗 Joins & Relationships
- Order details with customer name, book title, quantity, and total amount
- Books that were never ordered
- Customers who ordered more than one different book
- Most frequently ordered book
- Customers who placed at least 2 orders

### 3. 📊 Business Insights

| # | Query | Insight |
|---|-------|---------|
| 26 | Authors with total quantity sold > 10 | Best-selling authors |
| 27 | Top 3 customers by total spending | High-value customers |
| 28 | Second highest priced book | Pricing analysis |
| 30 | Average order amount per customer | Customer spend pattern |
| 34 | Day with highest total sales | Peak sales day |
| 37 | Books priced higher than every Fiction book | Cross-genre pricing |
| 40 | Each customer's % contribution to total revenue | Revenue share |
| 48 | Month-wise total revenue | Sales trend by month |
| 56 | Total books sold per genre | Genre performance |

### 4. 🪟 Advanced Queries (Window Functions & CTEs)

| # | Query |
|---|-------|
| 35 | Running total of sales by order date |
| 36 | Customer ranking by total spending |
| 38 | Customer who placed the first-ever order |
| 39 | Latest order per customer |
| 41 | Top 3 most expensive books in each genre |
| 44 | CTE — genres with total revenue > $100 |
| 45 | Most recent order date per customer |
| 46 | Customers whose first order was in 2024 |
| 47 | Customer rank by total spending (RANK) |
| 50 | CTE — customers with above-average order value |
| 51 | Each book's % contribution to total quantity sold |
| 53 | Customer value labels — High / Medium / Low |
| 55 | Previous order date and gap in days (LAG) |

---

## 💡 Key SQL Concepts Used

- `JOIN` (INNER, LEFT)
- Subqueries (correlated and non-correlated)
- `CTE` — Common Table Expressions (`WITH`)
- **Window Functions** — `RANK()`, `ROW_NUMBER()`, `LAG()`, `LEAD()`, `SUM() OVER()`
- `CASE WHEN` for conditional labels
- Date functions — `EXTRACT()`, `TO_CHAR()`, `DATE_PART()`
- String functions — pattern matching with `LIKE`
- Aggregate functions — `SUM()`, `AVG()`, `COUNT()`, `MAX()`

---

## 📂 Repository Structure

```
bookstore-sql-project/
│
├── bookstore_project.sql     # All 59 SQL queries
├── README.md                 # Project documentation
```

---

## 🙋 About

This project was built to strengthen core and advanced SQL skills using a realistic multi-table bookstore database. It simulates common business questions around sales performance, customer behavior, and inventory — the kind of analysis done in real data analyst roles.
