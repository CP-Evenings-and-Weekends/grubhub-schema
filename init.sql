-- This file runs against the default `postgres` database when the container
-- first starts. Build your schema here, then re-run ./setup.sh.
--
-- Typical pattern (see cars-database for a fuller example):
--
CREATE DATABASE grubhub;
\connect grubhub

CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
    CHECK(name !~ '\s'),
	CHECK (email ~* '^\w+@\w+[.]\w+$'),
	CHECK (char_length(password)>=8)
  
);

CREATE TABLE Restaurant (
rest_id SERIAL PRIMARY KEY,
rest_name TEXT NOT NULL,
rest_address TEXT NOT NULL,
cuisine_type TEXT NOT NULL
);

CREATE TABLE Orders (
order_id SERIAL PRIMARY KEY,
user_id INT NOT NULL REFERENCES Users(user_id),
rest_id INT NOT NULL REFERENCES Restaurant(rest_id)
    
);

CREATE TABLE Categories (
    cat_id SERIAL PRIMARY KEY,
    cat_type TEXT NOT NULL UNIQUE
);

CREATE TABLE Items (
    item_id SERIAL PRIMARY KEY,
    item_name TEXT NOT NULL,
    cat_id INT NOT NULL REFERENCES Categories(cat_id),
    price NUMERIC(6,2) NOT NULL
);

CREATE TABLE ItemOrder (
item_order_id SERIAL PRIMARY KEY,
item_id INT NOT NULL REFERENCES Items(item_id), 
order_id INT NOT NULL REFERENCES Orders(order_id)

);


INSERT INTO Users (name, email, password)
VALUES
('Duchess', 'duchess@email.com', '$2b$12$Jk9mN4xTqP8sYvLUvWxYz1234567890'),
('Thomas', 'thomas@email.com', '$2b$12$Lp8vQ2nRs7XyZaBVwXyZaBc123456789'),
('Marie', 'marie@email.com', '$2b$12$QwErTyUiOpAsDfGhJk890AbCdEfGhIjKl'),
('Toulouse', 'toulouse@email.com', '$2b$12$MnOpQrStUvWxYzAbCd890LmNoPqRsTuVw'),
('Berlioz', 'berlioz@email.com', '$2b$12$ZaXsDcFvGbHnJmKqWeR890AsDfGhJkLzX');




INSERT INTO Restaurant (rest_name, rest_address, cuisine_type)
VALUES
('Chick-fil-A', '2432 Highway 6 and 50, Grand Junction, CO 81505', 'American'),
('Guru''s Kitchen', '2504 Highway 6 and 50, Grand Junction, CO 81505', 'Indian'),
('Arin Krin Garlic House', '2531 N 12th St, Grand Junction, CO 81501', 'Japanese'),
('Pint House', '2470 Patterson Rd, Grand Junction, CO 81505', 'American'),
('VIP Tacos', '710 North Ave, Grand Junction, CO 81501', 'Mexican');

INSERT INTO Categories (cat_type)
VALUES
('Entree'),
('Side'),
('Drink'),
('Dessert'),
('Appetizer');


-- Restaurants: IDs 1–5

-- 1 = Chick-fil-A
-- 2 = Guru's Kitchen
-- 3 = Arin Krin Garlic House
-- 4 = Pint House
-- 5 = VIP Tacos

-- Item IDs
-- 1  = Chicken Sandwich
-- 2  = Waffle Fries
-- 3  = Sweet Tea
-- 4  = Butter Chicken
-- 5  = Garlic Naan
-- 6  = Mango Lassi
-- 7  = Garlic Fried Rice
-- 8  = Spring Rolls
-- 9  = Thai Iced Tea
-- 10 = Classic Burger
-- 11 = Onion Rings
-- 12 = Chocolate Brownie
-- 13 = Carne Asada Taco
-- 14 = Chips and Salsa
-- 15 = Horchata
-- 16 = Spicy Chicken Sandwich
-- 17 = Mac and Cheese
-- 18 = Chocolate Milkshake
-- 19 = Chicken Tikka Masala
-- 20 = Samosa
-- 21 = Cucumber Raita
-- 22 = Pad Thai
-- 23 = Garlic Chicken Wings
-- 24 = Root Beer
-- 25 = Taco Bowl



INSERT INTO Item (item_name, cat_id, price)
VALUES
('Chicken Sandwich',1,5.99),
('Waffle Fries',2,2.99),
('Sweet Tea',3,2.49),

('Butter Chicken',1,15.99),
('Garlic Naan',2,3.99),
('Mango Lassi',3,4.99),

('Garlic Fried Rice',1,12.99),
('Spring Rolls',5,5.99),
('Thai Iced Tea',3,3.99),

('Classic Burger',1,13.99),
('Onion Rings',2,4.99),
('Chocolate Brownie',4,6.49),

('Carne Asada Taco',1,3.99),
('Chips and Salsa',2,3.49),
('Horchata',3,2.99),

('Spicy Chicken Sandwich',1,6.49),
('Mac and Cheese',2,3.49),
('Chocolate Milkshake',3,4.99),

('Chicken Tikka Masala',1,16.99),
('Samosa',5,5.99),
('Cucumber Raita',2,3.99),

('Pad Thai',1,13.99),
('Garlic Chicken Wings',5,9.99),
('Root Beer',3,2.49),

('Taco Bowl',1,10.99);


INSERT INTO Orders (user_id, rest_id)
VALUES
(1,1),
(2,2),
(3,5),
(4,4),
(5,3),
(1,2),
(2,1),
(3,4),
(4,5),
(5,1),
(2,3),
(1,5);


INSERT INTO ItemOrder (item_id, order_id)
VALUES

-- Order 1 Chick-fil-A (4 items)
(1,1),
(2,1),
(3,1),
(16,1),

-- Order 2 Guru's Kitchen (3 items)
(4,2),
(5,2),
(6,2),

-- Order 3 VIP Tacos (3 items)
(13,3),
(14,3),
(15,3),

-- Order 4 Pint House (3 items)
(10,4),
(11,4),
(12,4),

-- Order 5 Arin Krin Garlic House (4 items)
(7,5),
(8,5),
(9,5),
(22,5),

-- Order 6 Guru's Kitchen (2 items)
(19,6),
(20,6),

-- Order 7 Chick-fil-A (3 items)
(16,7),
(17,7),
(18,7),

-- Order 8 Pint House (4 items)
(10,8),
(11,8),
(12,8),
(24,8),

-- Order 9 VIP Tacos (3 items)
(13,9),
(14,9),
(25,9),

-- Order 10 Chick-fil-A (2 items)
(1,10),
(18,10),

-- Order 11 Arin Krin Garlic House (3 items)
(7,11),
(22,11),
(23,11),

-- Order 12 VIP Tacos (4 items)
(13,12),
(14,12),
(15,12),
(25,12);
