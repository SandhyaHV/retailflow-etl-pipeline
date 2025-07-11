-- creating a table structure to load the data from Kaggle API using a Python script.

CREATE TABLE df_orders (
	[order_id] int primary key,
	[order_date] date,
	[ship_mode] varchar(20),
	[segment] varchar(20),    
	[country] varchar(20),     
	[city] varchar(20),           
	[state] varchar(20),           
	[postal_code] varchar(20),       
	[region] varchar(20),             
	[category] varchar(20),           
	[sub_category] varchar(20),       
	[product_id] varchar(20),         
	[quantity] int,
	[discounted_price] decimal(7,2),
	[sale_price] decimal(7,2),
	[revenue] decimal(7,2),
	[total_cost] decimal(7,2),
	[profit] decimal(7,2)
);



