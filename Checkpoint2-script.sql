.headers on

-- Drop tables if they already exist
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Bookstore;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Supplier; 
DROP TABLE IF EXISTS Supplier_book;
DROP TABLE IF EXISTS Supplier_bookstore; 
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
    supplier_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for the Supplier
    name TEXT NOT NULL,                            -- Name of the Supplier
    contact_info TEXT                              -- Contact info of the Supplier
);

-- Orders Table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,    -- Unique identifier for the order
    order_date TEXT NOT NULL,                      -- Date when the order was placed
    supplier_id INTEGER,                           -- Supplier who placed the order (FK)
    bookstore_id INTEGER,                          -- Bookstore where the order was placed (FK)
    FOREIGN KEY (supplier_id) REFERENCES Supplier (supplier_id),
    FOREIGN KEY (bookstore_id) REFERENCES Bookstore (bookstore_id)
);

-- OrderItem Table (Many-to-One relationship between Orders and Books)
CREATE TABLE Orderitem (
    orderitem_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique identifier for the order item
    order_id INTEGER NOT NULL,                       -- Associated order (FK)
    book_id INTEGER NOT NULL,                        -- Book associated with the order (FK)
    quantity INTEGER NOT NULL,                       -- Quantity of books ordered
    FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Book (book_id)
);

-- Sales Table
CREATE TABLE Sales (
    sale_id INTEGER PRIMARY KEY AUTOINCREMENT,      -- Unique identifier for the sale
    sale_date TEXT NOT NULL,                         -- Date of the sale
    customer_id INTEGER,                             -- Customer who made the sale (FK)
    bookstore_id INTEGER,                            -- Bookstore where the sale occurred (FK)
    total_amount REAL NOT NULL,                      -- Total amount of the sale
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id) ON DELETE CASCADE,
    FOREIGN KEY (bookstore_id) REFERENCES Bookstore (bookstore_id) ON DELETE CASCADE
);

-- Create the Many-to-Many relationship between Suppliers and Books
CREATE TABLE Supplier_book (
    supplier_id INTEGER NOT NULL,                   -- Supplier (FK)
    book_id INTEGER NOT NULL,                       -- Book (FK)
    PRIMARY KEY (supplier_id, book_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier (supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Book (book_id)
);

-- Create the Many-to-Many relationship between Suppliers and Bookstores
CREATE TABLE Supplier_bookstore (
    supplier_id INTEGER NOT NULL,                   -- Supplier (FK)
    bookstore_id INTEGER NOT NULL,                   -- Bookstore (FK)
    PRIMARY KEY (supplier_id, bookstore_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier (supplier_id) ON DELETE CASCADE,
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
('Harper Collins', 'contact@harpercollins.com'),
('The Book Supplier', 'contact@tbs.com');

-- Insert Orders
INSERT INTO Orders (order_date, supplier_id, bookstore_id) VALUES
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
INSERT INTO Supplier_book (supplier_id, book_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);

-- Insert Supplier-Bookstore Relations
INSERT INTO Supplier_bookstore (supplier_id, bookstore_id) VALUES
(1, 1),
(2, 2);

-- SELECT Customers who made an order from Bookstore "The Book Nook"
SELECT C.first_name AS 'The Book Nook Customers'
FROM Customer C, Sales S, Bookstore B
WHERE B.name = 'The Book Nook' AND B.bookstore_id = S.bookstore_id AND S.customer_id = C.customer_id;

-- SELECT Bookstores who made an order from Supplier "Penguin Books"
SELECT B.name AS 'Bookstores supplied by Penguin Books'
FROM Supplier Su, Orders O, Bookstore B
WHERE Su.name = 'Penguin Books' AND Su.supplier_id = O.supplier_id AND O.bookstore_id = B.bookstore_id;

-- SELECT Customers who made an order on 2024-11-01
SELECT C.first_name AS 'Customers who ordered on 2024-11-01'
FROM Customer C, Sales S
WHERE S.sale_date LIKE '2024-11-01' AND S.customer_id = C.customer_id;

-- SELECT Bookstores who made an order on 2024-11-01
SELECT B.name AS 'Bookstores who ordered on 2024-11-01'
FROM Bookstore B, Orders O
WHERE O.order_date LIKE '2024-11-01' AND O.bookstore_id = B.bookstore_id;

-- SELECT Suppliers who supplied to Bookstore "Reader's Haven"
SELECT S.name AS 'Suppliers who supplied to Reader''s Haven'
FROM Supplier S, Orders O
WHERE O.bookstore_id = 2 AND O.supplier_id = S.supplier_id;

-- SELECT Suppliers who supplied to Bookstore "The Book Nook"
SELECT S.name AS 'Suppliers who supplied to The Book Nook'
FROM Supplier S, Orders O
WHERE O.bookstore_id = 1 AND O.supplier_id = S.supplier_id;

-- SELECT Books with stock quantity > 50
SELECT B.title AS 'Books with stock quantity > 50'
FROM Book B
WHERE B.stock_quantity > 50;

-- SELECT Books that are Classics
SELECT B.title AS Classics
FROM Book B
WHERE B.genre = 'Classic';

-- SELECT Orders that involve multiple books
SELECT O.order_id AS 'Order ID''s involving multiple books'
FROM Orderitem O
GROUP BY O.order_id
HAVING COUNT(DISTINCT O.book_id) > 1;

-- SELECT Books that are part of an order for multiple books
SELECT B.title AS 'Books that are part of orders for multiple books'
FROM Book B, Orderitem O, (SELECT O.order_id AS 'Order_ID'
                           FROM Orderitem O
                           GROUP BY O.order_id
                           HAVING COUNT(DISTINCT O.book_id) > 1) M
WHERE O.order_id = M.Order_ID AND B.book_id = O.book_id;

-- SELECT Customers who made an order for more than $35
SELECT C.first_name AS 'Customers who made an order for more than $35'
FROM Customer C, Sales S
WHERE S.total_amount > 35 AND S.customer_id = C.customer_id;

-- UPDATE quantity of "1984" book available
UPDATE Book
SET stock_quantity = 80
WHERE book_id = 2;

-- DELETE Supplier "Harper Collins"
DELETE FROM Supplier
WHERE Supplier_id = 2;

-- UPDATE contact information for "The Book Supplier"
UPDATE Supplier
SET contact_info = 'newcontact@penguinbooks.com'
WHERE supplier_id = 1;

-- Books that are supplied by Supplier "Penguin Books"
SELECT B.title AS 'Books that are supplied by "Penguin Books"'
FROM Book B, Supplier_book S
WHERE S.supplier_id = 1 AND S.book_id = B.book_id;

-- DELETE Supplier - Book relationship between "1984" and "Penguin Books"
DELETE FROM Supplier_book
WHERE supplier_id = 1 AND book_id = 2;

-- 16 queries done

-- 