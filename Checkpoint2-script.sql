-- Create the Bookstore Database Schema
-- Drop tables if they already exist
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Bookstore;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orderitem;

-- Create tables for the entities
-- Book Table
CREATE TABLE Book (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,    -- Unique identifier for the Book
    title TEXT NOT NULL,                          -- Title of the Book
    author TEXT NOT NULL,                         -- Author of the Book
    genre TEXT,                                   -- Genre of the Book
    price REAL NOT NULL,                          -- Price of the Book
    stock_quantity INTEGER NOT NULL               -- Quantity available in inventory
);

-- Customer Table
CREATE TABLE Customer (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for the Customer
    first_name TEXT NOT NULL,                     -- Customer's first name
    last_name TEXT NOT NULL,                      -- Customer's last name
    email TEXT,                                   -- Customer's email
    phone TEXT                                    -- Customer's phone number
);

-- Bookstore Table
CREATE TABLE Bookstore (
    bookstore_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for the Bookstore
    name TEXT NOT NULL,                            -- Name of the Bookstore
    location TEXT NOT NULL,                        -- Location of the Bookstore
    contact_info TEXT                              -- Contact info of the Bookstore
);

-- Supplier Table
CREATE TABLE Supplier (
    Supplier_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for the Supplier
    name TEXT NOT NULL,                            -- Name of the Supplier
    contact_info TEXT                              -- Contact info of the Supplier
);

-- Orders Table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,    -- Unique identifier for the order
    order_date TEXT NOT NULL,                      -- Date when the order was placed
    customer_id INTEGER,                           -- Customer who placed the order (FK)
    bookstore_id INTEGER,                          -- Bookstore where the order was placed (FK)
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id),
    FOREIGN KEY (bookstore_id) REFERENCES Bookstore (bookstore_id)
);

-- OrderItem Table (Many-to-One relationship between Orders and Books)
CREATE TABLE Orderitem (
    orderitem_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique identifier for the order item
    order_id INTEGER NOT NULL,                       -- Associated order (FK)
    book_id INTEGER NOT NULL,                        -- Book associated with the order (FK)
    quantity INTEGER NOT NULL,                       -- Quantity of books ordered
    FOREIGN KEY (order_id) REFERENCES Orders (order_id),
    FOREIGN KEY (book_id) REFERENCES Book (book_id)
);

-- Sales Table
CREATE TABLE Sales (
    sale_id INTEGER PRIMARY KEY AUTOINCREMENT,      -- Unique identifier for the sale
    sale_date TEXT NOT NULL,                         -- Date of the sale
    customer_id INTEGER,                             -- Customer who made the sale (FK)
    bookstore_id INTEGER,                            -- Bookstore where the sale occurred (FK)
    total_amount REAL NOT NULL,                      -- Total amount of the sale
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id),
    FOREIGN KEY (bookstore_id) REFERENCES Bookstore (bookstore_id)
);

-- Create the Many-to-Many relationship between Suppliers and Books
CREATE TABLE Supplier_book (
    Supplier_id INTEGER NOT NULL,                   -- Supplier (FK)
    book_id INTEGER NOT NULL,                       -- Book (FK)
    PRIMARY KEY (Supplier_id, book_id),
    FOREIGN KEY (Supplier_id) REFERENCES Supplier (Supplier_id),
    FOREIGN KEY (book_id) REFERENCES Book (book_id)
);

-- Create the Many-to-Many relationship between Suppliers and Bookstores
CREATE TABLE Supplier_bookstore (
    Supplier_id INTEGER NOT NULL,                   -- Supplier (FK)
    bookstore_id INTEGER NOT NULL,                   -- Bookstore (FK)
    PRIMARY KEY (Supplier_id, bookstore_id),
    FOREIGN KEY (Supplier_id) REFERENCES Supplier (Supplier_id),
    FOREIGN KEY (bookstore_id) REFERENCES Bookstore (bookstore_id)
);

-- Insert sample data into the tables

-- Insert Books
INSERT INTO Book (title, author, genre, price, stock_quantity) VALUES
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 10.99, 100),
('1984', 'George Orwell', 'Dystopian', 8.99, 50),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 12.99, 75),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 9.99, 60);

-- Insert Customers
INSERT INTO Customer (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'johndoe@example.com', '123-456-7890'),
('Jane', 'Smith', 'janesmith@example.com', '987-654-3210'),
('Bob', 'Johnson', 'bobjohnson@example.com', '555-123-4567');

-- Insert Bookstores
INSERT INTO Bookstore (name, location, contact_info) VALUES
('The Book Nook', '123 Main St, Springfield', 'booknook@example.com'),
('Readers’ Haven', '456 Elm St, Springfield', 'readershaven@example.com');

-- Insert Suppliers
INSERT INTO Supplier (name, contact_info) VALUES
('Penguin Books', 'contact@penguinbooks.com'),
('HarperCollins', 'contact@harpercollins.com');

-- Insert Orders
INSERT INTO Orders (order_date, customer_id, bookstore_id) VALUES
('2024-11-01', 1, 1),
('2024-11-02', 2, 2),
('2024-11-03', 3, 1);

-- Insert OrderItems
INSERT INTO Orderitem (order_id, book_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(3, 4, 2);

-- Insert Sales
INSERT INTO Sales (sale_date, customer_id, bookstore_id, total_amount) VALUES
('2024-11-01', 1, 1, 32.97),
('2024-11-02', 2, 2, 27.96),
('2024-11-03', 3, 1, 39.98);

-- Insert Supplier-Book Relations
INSERT INTO Supplier_book (Supplier_id, book_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);

-- Insert Supplier-Bookstore Relations
INSERT INTO Supplier_bookstore (Supplier_id, bookstore_id) VALUES
(1, 1),
(2, 2);

