import sqlite3

# Function to connect to the database
def connect_to_db():
    return sqlite3.connect('bookstore.sqlite3')

# Function to close the database connection
def close_connection(conn):
    conn.close()

# Function to display a menu
def display_menu():
    print("\nBookstore Management System")
    print("1. View Books")
    print("2. Add Book")
    print("3. View Customers")
    print("4. Add Customer")
    print("5. View Orders")
    print("6. Add Order")
    print("7. View Sales")
    print("8. Add Sale")
    print("9. Exit")

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
        print(f"Order ID: {order[0]}, Date: {order[1]}, Customer ID: {order[2]}, Bookstore ID: {order[3]}")

# Function to add a new order
def add_order(conn):
    order_date = input("Enter order date (YYYY-MM-DD): ")
    customer_id = int(input("Enter customer ID: "))
    bookstore_id = int(input("Enter bookstore ID: "))
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Orders (order_date, customer_id, bookstore_id) VALUES (?, ?, ?)",
                   (order_date, customer_id, bookstore_id))
    conn.commit()
    print("Order added successfully!")

# Function to view all sales
def view_sales(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Sales")
    sales = cursor.fetchall()
    print("\nSales:")
    for sale in sales:
        print(f"Sale ID: {sale[0]}, Date: {sale[1]}, Customer ID: {sale[2]}, Bookstore ID: {sale[3]}, Total Amount: {sale[4]}")

# Function to add a new sale
def add_sale(conn):
    sale_date = input("Enter sale date (YYYY-MM-DD): ")
    customer_id = int(input("Enter customer ID: "))
    bookstore_id = int(input("Enter bookstore ID: "))
    total_amount = float(input("Enter total sale amount: "))
    
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Sales (sale_date, customer_id, bookstore_id, total_amount) VALUES (?, ?, ?, ?)",
                   (sale_date, customer_id, bookstore_id, total_amount))
    conn.commit()
    print("Sale added successfully!")

# Main function to run the application
def main():
    conn = connect_to_db()
    
    while True:
        display_menu()
        choice = input("Choose an option (1-9): ")
        
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
            add_order(conn)
        elif choice == '7':
            view_sales(conn)
        elif choice == '8':
            add_sale(conn)
        elif choice == '9':
            close_connection(conn)
            print("Exiting the application.")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()

