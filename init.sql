CREATE TABLE IF NOT EXISTS "fact_order" (
	"id" SERIAL NOT NULL,
	"dim_rest_id" INTEGER NOT NULL,
	"dim_user_id" INTEGER NOT NULL,
	"dim_cuisine_id" INTEGER NOT NULL,
	"order_date_time" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "dim_restaurant" (
	"id" SERIAL NOT NULL,
	"Name" VARCHAR(255) NOT NULL,
	"Address" VARCHAR(255) NOT NULL,
	"Phone" VARCHAR(255) NOT NULL,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "dim_cuisine" (
	"id" SERIAL NOT NULL,
	"cuisine_type" VARCHAR(255) NOT NULL,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "dim_user" (
	"id" SERIAL NOT NULL,
	"email" VARCHAR(255) NOT NULL,
	"password" VARCHAR(255) NOT NULL,
	"first_name" VARCHAR(255) NOT NULL,
	"last_name" VARCHAR(255) NOT NULL,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "dim_item" (
	"id" SERIAL NOT NULL,
	"item_name" VARCHAR(255) NOT NULL,
	"category" VARCHAR(255) NOT NULL,
	"price" NUMERIC(10,2) NOT NULL,
	PRIMARY KEY("id")
);




CREATE TABLE IF NOT EXISTS "bridge_order_item_id" (
	"fact_order_id" INTEGER NOT NULL,
	"item_id" INTEGER NOT NULL,
	"quantity" INTEGER NOT NULL,
	PRIMARY KEY("fact_order_id", "item_id")
);



ALTER TABLE "fact_order"
ADD FOREIGN KEY("dim_user_id") REFERENCES "dim_user"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "fact_order"
ADD FOREIGN KEY("dim_rest_id") REFERENCES "dim_restaurant"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "fact_order"
ADD FOREIGN KEY("dim_cuisine_id") REFERENCES "dim_cuisine"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "bridge_order_item_id"
ADD FOREIGN KEY("fact_order_id") REFERENCES "fact_order"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "bridge_order_item_id"
ADD FOREIGN KEY("item_id") REFERENCES "dim_item"("id")
ON UPDATE NO ACTION ON DELETE NO ACTION;