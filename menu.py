import sqlite3

# Function to connect to the database
def connect_to_db():
    return sqlite3.connect('bookstore.sqlite3')

# Function to close the database connection
def close_connection(conn):
    conn.close()

# Function to display the menu
def display_menu():
    print("\nBookstore Management System")
    print("1. View Books")
    print("2. Add Book")
    print("3. View Customers")
    print("4. Add Customer")
    print("5. View Orders")
    print("6. View Orders by Customer")
    print("7. Add Order")
    print("8. View Sales")
    print("9. View Sales by Book")
    print("10. Add Sale")
    print("11. Create OrderItems Table")
    print("12. Exit")

# Function to create the 'Book' table
def create_book_table(conn):
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS Book (
                        book_id INTEGER PRIMARY KEY,
                        title TEXT NOT NULL,
                        author TEXT NOT NULL,
                        genre TEXT NOT NULL,
                        price REAL NOT NULL,
                        stock_quantity INTEGER NOT NULL)''')
    conn.commit()
    print("Book table created successfully!")

# Function to create the 'Customer' table
def create_customer_table(conn):
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS Customer (
                        customer_id INTEGER PRIMARY KEY,
                        first_name TEXT NOT NULL,
                        last_name TEXT NOT NULL,
                        email TEXT NOT NULL,
                        phone TEXT NOT NULL)''')
    conn.commit()
    print("Customer table created successfully!")

# Function to create the 'Orders' table
def create_orders_table(conn):
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS Orders (
                        order_id INTEGER PRIMARY KEY,
                        order_date TEXT NOT NULL,
                        customer_id INTEGER NOT NULL,
                        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id))''')
    conn.commit()
    print("Orders table created successfully!")

# Function to create the 'OrderItems' table (to associate orders with books)
def create_order_items_table(conn):
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS OrderItems (
                        oi_order_id INTEGER,
                        oi_book_id INTEGER,
                        oi_quantity INTEGER,
                        PRIMARY KEY (oi_order_id, oi_book_id),
                        FOREIGN KEY (oi_order_id) REFERENCES Orders(order_id),
                        FOREIGN KEY (oi_book_id) REFERENCES Book(book_id))''')
    conn.commit()
    print("OrderItems table created successfully!")

# Function to create the 'Sales' table
def create_sales_table(conn):
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS Sales (
                        sale_id INTEGER PRIMARY KEY,
                        sale_date TEXT NOT NULL,
                        customer_id INTEGER NOT NULL,
                        total_amount REAL NOT NULL,
                        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id))''')
    conn.commit()
    print("Sales table created successfully!")

# Function to view all books
def view_books(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Book")
    books = cursor.fetchall()
    print("\nBooks:")
    for book in books:
        print(f"ID: {book[0]}, Title: {book[1]}, Author: {book[2]}, Genre: {book[3]}, Price: {book[4]}, Stock: {book[5]}")

# Function to add a new book
def add_book(conn):
    title = input("Enter book title: ")
    author = input("Enter book author: ")
    genre = input("Enter book genre: ")
    price = float(input("Enter book price: "))
    stock_quantity = int(input("Enter stock quantity: "))
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Book (title, author, genre, price, stock_quantity) VALUES (?, ?, ?, ?, ?)",
                   (title, author, genre, price, stock_quantity))
    conn.commit()
    print("Book added successfully!")

# Function to view all customers
def view_customers(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Customer")
    customers = cursor.fetchall()
    print("\nCustomers:")
    for customer in customers:
        print(f"ID: {customer[0]}, Name: {customer[1]} {customer[2]}, Email: {customer[3]}, Phone: {customer[4]}")

# Function to add a new customer
def add_customer(conn):
    first_name = input("Enter first name: ")
    last_name = input("Enter last name: ")
    email = input("Enter email: ")
    phone = input("Enter phone number: ")
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Customer (first_name, last_name, email, phone) VALUES (?, ?, ?, ?)",
                   (first_name, last_name, email, phone))
    conn.commit()
    print("Customer added successfully!")

# Function to view all orders
def view_orders(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Orders")
    orders = cursor.fetchall()
    print("\nOrders:")
    for order in orders:
        print(f"Order ID: {order[0]}, Date: {order[1]}, Customer ID: {order[2]}")

# Function to view orders made by a specific customer
def view_orders_by_customer(conn):
    customer_id = int(input("Enter customer ID to view orders: "))
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Orders WHERE customer_id = ?", (customer_id,))
    orders = cursor.fetchall()
    print(f"\nOrders for Customer ID {customer_id}:")
    for order in orders:
        print(f"Order ID: {order[0]}, Date: {order[1]}")

# Function to add a new order
def add_order(conn):
    order_date = input("Enter order date (YYYY-MM-DD): ")
    customer_id = int(input("Enter customer ID: "))
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Orders (order_date, customer_id) VALUES (?, ?)",
                   (order_date, customer_id))
    conn.commit()
    print("Order added successfully!")

# Function to view all sales
def view_sales(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Sales")
    sales = cursor.fetchall()
    print("\nSales:")
    for sale in sales:
        print(f"Sale ID: {sale[0]}, Date: {sale[1]}, Customer ID: {sale[2]}, Total Amount: {sale[3]}")

# Function to view sales for a specific book
def view_sales_by_book(conn):
    book_id = int(input("Enter book ID to view sales: "))
    cursor = conn.cursor()
    
    cursor.execute('''SELECT SUM(OrderItems.oi_quantity * Book.price) AS total_sales
                      FROM OrderItems
                      JOIN Book ON OrderItems.oi_book_id = Book.book_id
                      WHERE OrderItems.oi_book_id = ?''', (book_id,))
    total_sales = cursor.fetchone()[0] or 0
    print(f"\nTotal sales for Book ID {book_id}: ${total_sales:.2f}")

# Function to add a new sale
def add_sale(conn):
    sale_date = input("Enter sale date (YYYY-MM-DD): ")
    customer_id = int(input("Enter customer ID: "))
    total_amount = float(input("Enter total sale amount: "))
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Sales (sale_date, customer_id, total_amount) VALUES (?, ?, ?)",
                   (sale_date, customer_id, total_amount))
    conn.commit()
    print("Sale added successfully!")

# Main function to run the application
def main():
    conn = connect_to_db()

    while True:
        display_menu()
        choice = input("Choose an option (1-12): ")

        if choice == '1':
            view_books(conn)
        elif choice == '2':
            add_book(conn)
        elif choice == '3':
            view_customers(conn)
        elif choice == '4':
            add_customer(conn)
        elif choice == '5':
            view_orders(conn)
        elif choice == '6':
            view_orders_by_customer(conn)
        elif choice == '7':
            add_order(conn)
        elif choice == '8':
            view_sales(conn)
        elif choice == '9':
            view_sales_by_book(conn)
        elif choice == '10':
            add_sale(conn)
        elif choice == '11':
            create_order_items_table(conn)
        elif choice == '12':
            close_connection(conn)
            print("Exiting the application.")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    conn = connect_to_db()

    # Create necessary tables if they don't exist
    create_book_table(conn)
    create_customer_table(conn)
    create_orders_table(conn)
    create_order_items_table(conn)
    create_sales_table(conn)

    main()

