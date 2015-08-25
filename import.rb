

require "pg"
require "pry"
require "csv"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end


 #insert data to employees table
CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|
    email = row['employee'].scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)[0]
    name_email = row['employee'].split
    name_email.pop
    name = name_email.join(" ")
    array = conn.exec_params("SELECT name FROM employees WHERE name = $1",[name]).to_a
      if array.length == 0
        conn.exec("INSERT INTO employees (name, email) VALUES ($1, $2)", [name, email])
      end
  end
end

#insert data to customers table

CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|
    customer_and_account = row["customer_and_account_no"].split
    account_no = customer_and_account.pop
    customer = customer_and_account.join(" ")
    array = conn.exec_params("select customer from customers where customer = $1", [customer]).to_a
    if array.length == 0
      conn.exec("INSERT INTO customers (customer, account_no) VALUES ($1, $2)", [customer, account_no])
    end
  end
end

#insert data to product table

CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|
    product_name = row['product_name']
    array = conn.exec_params("select product_name from products where product_name = $1", [product_name]).to_a
    if array.length == 0
      conn.exec("INSERT INTO products (product_name) VALUES ($1)", [product_name])
    end
  end
end


#insert data to frecuency table

CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|
    frecuency = row['invoice_frequency']

    array = conn.exec_params("SELECT name FROM frecuency where name = $1", [frecuency]).to_a
    if array.length == 0
      conn.exec("INSERT INTO frecuency (name) VALUES ($1)", [frecuency])
    end
  end
end

#insert data to sales table

CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|
    amount = row["sale_amount"].gsub(/\D/,'').to_i
    units =row['units_sold'].to_i
    date = row['sale_date']

    customer_and_account = row["customer_and_account_no"].split
    customer_and_account.pop
    customer_name = customer_and_account.join(" ")

    name_email = row['employee'].split
    name_email.pop
    employee_name = name_email.join(" ")

    product_name = row['product_name']
    frecuency_name = row['invoice_frequency']

    #selects the ids from the row in order to insert them in the sales table.
    product_id = conn.exec_params("SELECT product_id FROM products WHERE product_name= $1",[product_name]).to_a[0]["product_id"]
    frecuency_id = conn.exec_params("SELECT frecuency_id FROM frecuency WHERE name= $1",[frecuency_name]).to_a[0]["frecuency_id"]
    employee_id = conn.exec_params("SELECT id FROM employees WHERE name = $1",[employee_name]).to_a[0]["id"]
    customer_id = conn.exec_params("SELECT customer_id FROM customers WHERE customer= $1",[customer_name]).to_a[0]["customer_id"]
    invoice_no = row['invoice_no']

    array = conn.exec_params("SELECT invoice_no FROM sales where invoice_no = $1", [invoice_no]).to_a
    if array.length == 0
      conn.exec_params("INSERT INTO sales (invoice_no, id, customer_id, product_id, frecuency_id, sales_amount, sale_date, units_sold) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [invoice_no, employee_id, customer_id, product_id, frecuency_id, amount, date, units])
    end
  end
end
