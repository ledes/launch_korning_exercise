-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS employees, customers, products, frecuency, sales;
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name varchar(100),
  email varchar(100)
);

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer varchar(100),
  account_no varchar(100)
);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name varchar(100)
);

CREATE TABLE frecuency (
  frecuency_id SERIAL PRIMARY KEY,
  name varchar(100)
);

CREATE TABLE sales(
  invoice_no int,
  id integer references employees(id),
  customer_id integer references customers(customer_id),
  product_id integer references products(product_id),
  frecuency_id integer references frecuency(frecuency_id),
  sales_amount int,
  sale_date varchar(100),
  units_sold int
);
