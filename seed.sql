-- ============================================================
-- Seed data for db-first run
-- Load order matches FK dependencies: dims -> fact -> bridge
-- ============================================================

-- ---------- dim_cuisine (8) ----------
INSERT INTO "dim_cuisine" ("cuisine_type") VALUES
('Italian'),
('Mexican'),
('Chinese'),
('Indian'),
('Japanese'),
('Thai'),
('American'),
('Mediterranean');

-- ---------- dim_restaurant (10) ----------
INSERT INTO "dim_restaurant" ("Name", "Address", "Phone") VALUES
('Trattoria Bella', '123 Elm St, Redlands, CA', '909-555-0101'),
('El Sabor Real', '456 Oak Ave, Redlands, CA', '909-555-0102'),
('Golden Dragon', '789 Pine Rd, Redlands, CA', '909-555-0103'),
('Spice Route', '321 Maple Dr, Redlands, CA', '909-555-0104'),
('Sakura Sushi', '654 Cedar Ln, Redlands, CA', '909-555-0105'),
('Bangkok Bites', '987 Birch Blvd, Redlands, CA', '909-555-0106'),
('The Burger Yard', '159 Willow Way, Redlands, CA', '909-555-0107'),
('Mediterraneo Grill', '753 Aspen Ct, Redlands, CA', '909-555-0108'),
('Napoli Pizzeria', '246 Spruce St, Redlands, CA', '909-555-0109'),
('Taco Fiesta', '864 Chestnut Ave, Redlands, CA', '909-555-0110');

-- ---------- dim_user (20) ----------
INSERT INTO "dim_user" ("email", "password", "first_name", "last_name") VALUES
('jsmith01@example.com',  'hashed_pw_01', 'John',    'Smith'),
('mgarcia02@example.com', 'hashed_pw_02', 'Maria',   'Garcia'),
('dlee03@example.com',    'hashed_pw_03', 'David',   'Lee'),
('apatel04@example.com',  'hashed_pw_04', 'Anita',   'Patel'),
('rjones05@example.com',  'hashed_pw_05', 'Robert',  'Jones'),
('kwong06@example.com',   'hashed_pw_06', 'Kevin',   'Wong'),
('lmartin07@example.com', 'hashed_pw_07', 'Laura',   'Martin'),
('cbrown08@example.com',  'hashed_pw_08', 'Chris',   'Brown'),
('sthomas09@example.com', 'hashed_pw_09', 'Sara',    'Thomas'),
('nkim10@example.com',    'hashed_pw_10', 'Nathan',  'Kim'),
('jrivera11@example.com', 'hashed_pw_11', 'Jessica', 'Rivera'),
('twhite12@example.com',  'hashed_pw_12', 'Tyler',   'White'),
('ohall13@example.com',   'hashed_pw_13', 'Olivia',  'Hall'),
('bclark14@example.com',  'hashed_pw_14', 'Brian',   'Clark'),
('ilopez15@example.com',  'hashed_pw_15', 'Isabel',  'Lopez'),
('gwalker16@example.com', 'hashed_pw_16', 'Grace',   'Walker'),
('ayoung17@example.com',  'hashed_pw_17', 'Aaron',   'Young'),
('vturner18@example.com', 'hashed_pw_18', 'Victoria','Turner'),
('mscott19@example.com',  'hashed_pw_19', 'Marcus',  'Scott'),
('ereed20@example.com',   'hashed_pw_20', 'Emma',    'Reed');

-- ---------- dim_item (40, ~5 per cuisine style) ----------
INSERT INTO "dim_item" ("item_name", "category", "price") VALUES
('Margherita Pizza', 'Entree', 14.99), ('Fettuccine Alfredo', 'Entree', 15.49),
('Tiramisu', 'Dessert', 7.99), ('Bruschetta', 'Appetizer', 6.99), ('Minestrone Soup', 'Appetizer', 5.99),
('Chicken Tacos', 'Entree', 11.99), ('Beef Burrito', 'Entree', 12.49), ('Guacamole & Chips', 'Appetizer', 6.49),
('Churros', 'Dessert', 5.99), ('Horchata', 'Beverage', 3.49),
('Kung Pao Chicken', 'Entree', 13.99), ('Vegetable Fried Rice', 'Entree', 10.99),
('Spring Rolls', 'Appetizer', 5.49), ('Hot & Sour Soup', 'Appetizer', 4.99), ('Fortune Cookies', 'Dessert', 1.99),
('Chicken Tikka Masala', 'Entree', 14.49), ('Vegetable Samosas', 'Appetizer', 5.99),
('Garlic Naan', 'Side', 3.99), ('Mango Lassi', 'Beverage', 4.49), ('Gulab Jamun', 'Dessert', 4.99),
('California Roll', 'Entree', 9.99), ('Salmon Nigiri Set', 'Entree', 13.99),
('Miso Soup', 'Appetizer', 3.99), ('Edamame', 'Appetizer', 4.49), ('Mochi Ice Cream', 'Dessert', 5.49),
('Pad Thai', 'Entree', 12.99), ('Green Curry', 'Entree', 13.49), ('Tom Yum Soup', 'Appetizer', 5.99),
('Thai Iced Tea', 'Beverage', 3.99), ('Mango Sticky Rice', 'Dessert', 6.49),
('Classic Cheeseburger', 'Entree', 10.99), ('Bacon BBQ Burger', 'Entree', 12.99),
('Loaded Fries', 'Side', 6.99), ('Chocolate Milkshake', 'Beverage', 5.49), ('Onion Rings', 'Side', 5.99),
('Chicken Gyro', 'Entree', 11.49), ('Falafel Plate', 'Entree', 10.49),
('Hummus & Pita', 'Appetizer', 6.49), ('Greek Salad', 'Appetizer', 7.99), ('Baklava', 'Dessert', 5.49);

-- ---------- fact_order (100) ----------
-- Randomized assignment across users, restaurants, and cuisines;
-- order_date_time spread randomly across the last 6 months
INSERT INTO "fact_order" ("dim_rest_id", "dim_user_id", "dim_cuisine_id", "order_date_time")
SELECT
    (floor(random() * 10) + 1)::int,
    (floor(random() * 20) + 1)::int,
    (floor(random() * 8) + 1)::int,
    now() - (random() * interval '180 days')
FROM generate_series(1, 100);

-- ---------- bridge_order_item_id (spread across the 100 orders) ----------
-- Each order gets 1-4 random line items; duplicates within an order collapse
-- via ON CONFLICT since (fact_order_id, item_id) is the composite PK
INSERT INTO "bridge_order_item_id" ("fact_order_id", "item_id", "quantity")
SELECT
    o.id,
    (floor(random() * 40) + 1)::int,
    (floor(random() * 3) + 1)::int
FROM "fact_order" o
CROSS JOIN generate_series(1, (floor(random() * 4) + 1)::int)
ON CONFLICT ("fact_order_id", "item_id") DO NOTHING;
