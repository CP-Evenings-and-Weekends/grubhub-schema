# Grubhub Schema

Design and implement a Postgres schema for a simplified Grubhub.

> If you did Saturday's [Schema Design](https://github.com/CP-Evenings-and-Weekends/schema-design) challenge, you already drew an ERD for Grubhub.  **Pull that diagram back up** and use it as your starting point — today's job is to turn that design into actual Postgres tables, seed it with data, and query it.  If you didn't get to it Saturday, do that first.

The included `init.sql`, `Dockerfile`, and `setup.sh` are wired up the same way as [cars-database](https://github.com/CP-Evenings-and-Weekends/cars-database).

## Feature set to support

Aim for the feature set Grubhub had at launch:

- **Users** sign up (name, email, password)
- **Restaurants** have a name, address, and one or more cuisine types
- Each restaurant has a **menu** of **menu items** (name, price, description)
- Users place **orders** at a restaurant.  An order can contain **many menu items** (and a menu item can appear in many orders) — many-to-many, needs a join table
- Each order tracks total price and an order timestamp
- Each order is **delivered to an address** (a user can have multiple saved addresses)

## Requirements

### 1. Confirm or revise the ERD

Open Saturday's diagram (or create one if you skipped it) in [dbdiagram.io](https://dbdiagram.io/) or [Quick Database Diagrams](https://www.quickdatabasediagrams.com/).  Commit a screenshot as `erd.png` or a Mermaid `erDiagram` block as `erd.md`.

You'll likely have: `users`, `addresses`, `restaurants`, `cuisines`, `restaurant_cuisines` (join), `menu_items`, `orders`, `order_items` (join).

### 2. Implement in `init.sql`

Translate the ERD into `CREATE TABLE` statements with primary keys, foreign keys, and constraints (`NOT NULL`, `UNIQUE`).  Follow the conventions from Saturday: plural lowercase table names, `id` primary keys, `_id` foreign keys.

### 3. Seed it with data

Either write `INSERT` statements directly or use [Mockaroo](https://www.mockaroo.com/) to generate CSVs.  Aim for at least:
- 5 restaurants across 3+ cuisines
- 20+ menu items
- 5 users with multiple addresses
- 10+ orders with 2-4 items each

### 4. Build, run, and query

```bash
./setup.sh
```

(or build/run manually with `docker build` + `docker run` if you prefer — same pattern as cars-database)

Write at least 5 queries in `queries.sql` that exercise the schema:
- Every restaurant whose menu has at least one item over $20
- A specific user's order history (each order with its items)
- The most-ordered menu item across all restaurants
- Revenue per restaurant
- Cuisines available within a given address's city

## Things to think about
- A menu item's price changes over time, but a past order should still show what it cost at the time.  How would you preserve that historical accuracy?  (Hint: store `price` on `order_items`, not just `menu_items`.)
- A user can have many addresses; an order has one delivery address.  Is `address_id` on `orders`, or do you need a snapshot of the address as well?
- `restaurant_cuisines` is a pure join table (just two foreign keys).  Does it need its own `id`, or is the composite `(restaurant_id, cuisine_id)` enough as a primary key?

## Stretch
- Add **ratings/reviews** — a user can review a restaurant.  Each review has a 1–5 rating and an optional text body.  Add a query for "restaurants with average rating ≥ 4."
- Add **order status** (pending / preparing / delivered / cancelled) as an enum or constrained column, plus timestamps for each transition.
- Add an index on a column you think will be queried frequently (e.g. `menu_items.restaurant_id`), then `EXPLAIN ANALYZE` one of your queries before and after.

> Stuck? Have a code error? Use the ["4 Before Me"](https://docs.google.com/document/d/1nseOs5oabYBKNHfwJZNAR7GlU0zkZxNagsw63AD7XV0/edit) debugging checklist to help you solve it!
