---------------------------------------------------------------------------------------
/* Hello! We're going to practice some SQL with a database
   from Oracle. This database covers:
   - PC component products
   - categories, orders and order items for said products
   - customers and employees
   - warehouses and their inventories
   - locations, countries, regions
   Hoowhee! That's a lot of tables. But when it comes to
   data, the more the merrier :) */
use ot;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
/*  	*
	1a.) Select the region_id and count of all rows from the countries table. Group 
	by the region_id and order by count descending. Limit to 1 to find the region 
	with the most countries that have company locations. */
---------------------------------------------------------------------------------------

#drop view one_a;
CREATE VIEW one_a AS
    SELECT 
        countries.region_id,
        COUNT(countries.region_id) AS num_countries
    FROM
        countries
    GROUP BY countries.region_id
    ORDER BY num_countries DESC
    LIMIT 1;

---------------------------------------------------------------------------------------
/* 	*
	1b.) Looks like we found the region with the most countries, but we don't know 
	the name of the region. Fortunately, that can be found in the regions table. 
	Using the results of the previous problem, find the name of the region with the
	most countries. We want to use an alias of 'region with most locations' for the 
        column label, as well. */
---------------------------------------------------------------------------------------

SELECT 
    region_name AS region_with_most_locations
FROM
    one_a
        JOIN
    regions ON regions.region_id = one_a.region_id;

---------------------------------------------------------------------------------------
/* 	**
	 1c.) Nice job! Now, here's a more difficult one. Using the locations table, 
	 select the state, city, and postal_code from locations where the country is 
	 NOT the United States (country_id != "US") and the name of the city starts
	 with "S". 
         Hint: Use LIKE and a wildcard. */
---------------------------------------------------------------------------------------

SELECT 
    state, city, postal_code
FROM
    locations
WHERE
    country_id != 'US' AND city LIKE 'S%';
        
---------------------------------------------------------------------------------------
/*  	*
	1d.) As you may have seen in the problem above, there's a "state" column in the 
        locations table, but not all locations are in a state. Select all entries for 
        the locations that are NOT in a state. */
---------------------------------------------------------------------------------------

SELECT 
    *
FROM
    locations
WHERE
    state IS NULL;

---------------------------------------------------------------------------------------
/* 	**
	1e.) Your employer wants an update on the number of countries that have locations. 
	They note that they want unique countries but they're not sure how to do that 
	and they're asking you for help. Write a query for them. */
---------------------------------------------------------------------------------------

SELECT DISTINCT
    country_name
FROM
    countries
        JOIN
    locations ON countries.country_id = locations.country_id;

---------------------------------------------------------------------------------------
/* 	**
	2a.) Why don't we switch gears? Let's take a look at the products in this
	database. Find the product names and prices of all products that have a 
	list_price between 100 and 500. You'll have to find the right table yourself on 
	this one. */
---------------------------------------------------------------------------------------

SELECT 
    product_name, list_price
FROM
    products
WHERE
    list_price > 100 AND list_price < 500;

---------------------------------------------------------------------------------------
/* 	**
	2b.) What do those product names even MEAN? If you don't know much about PC 
       components, it can be difficult to distinguish between different kinds of 
       products. Good thing we have a table for product categories! 
       
       Select the product_name, list_price, and category_name (from product category) 
       rows from the products table joined to the product_categories table on 
       category_id (using an inner join). */
---------------------------------------------------------------------------------------

SELECT 
    product_name, list_price, category_name
FROM
    products
        JOIN
    product_categories ON products.category_id = product_categories.category_id
WHERE
    list_price > 100 AND list_price < 500;

---------------------------------------------------------------------------------------
/* 	****
	2c.) Let's try joining more than two tables. You're looking for a popular CPU 
	that has more than 100 units in stock at your local warehouse in Toronto. You 
	only need to find the names of the products, but you'll need to join these 
	tables:
        - warehouses
        - inventories
        - products
        - product_categories
        The only info you need is the product_name and the list_price. */
---------------------------------------------------------------------------------------
        
SELECT 
    product_name, list_price
FROM
    products
        JOIN
    product_categories ON products.category_id = product_categories.category_id
        JOIN
    inventories ON products.product_id = inventories.product_id
        JOIN
    warehouses ON inventories.warehouse_id = warehouses.warehouse_id
WHERE
    product_categories.category_name LIKE 'CPU'
        AND inventories.quantity > 100
        AND warehouses.warehouse_name LIKE 'Toronto';
        
---------------------------------------------------------------------------------------
/* 	**
	3a.) Now that we have a bit more of an idea of what kinds of products we have, 
	let's investigate prices. Select the avg list_price of all products. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* 	***
	3b.) Let's take a closer look at the average prices of each category. Select the 
        category_name and average list_price of each product category, rounded to 2 
        decimals. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* 	**
	4a.) We have the mean, now, but the outliers in the data will skew the mean.
	There are other statistics that we can look at as well, like mode!
       
       Let's start by 
	-- selecting list_price and the count of list_prices 
	-- grouped by list_price
        -- ordered with the highest value first 
        -- limited to 2.
        Note: We limit to 2 to see if there are multiple modes. If the top two results 
        of this query have the same count, rerun the query with limit + 1, and repeat
        (do this manually). If there's more than one mode, this is how you find them 
        all without incorporating more advanced functions. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* 	****
	4b.) What if we want to find the modes for list_price for each product category?
	With what we've learned so far, we can find them with a single query.
        
        Use a joined table to select category_name, list_price, and count of the
        correct groups*. Sort the results in a way that will allow you to easily see 
        the highest count in each category**. 
        
        * Tip: Remember we can use multiple groups. For example, we can group first by 
        category name, then we can group by list price for each category_name (there 
        are 4).
        
        ** Additional Tip: There isn't a very easy way to limit your query to the
        highest count of each category, but what you can do is filter out all the 
        entries that only have a count of 1, as they are certainly not the mode. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* 	**
	5a.) Last but not least, we have to find the median! We'll need to use subqueries
	for this, as well as SET user-defined variables. 
        
        First, let's SET a user-defined variable (@variable) equal to (:=) -1. These 
        variables last longer in the memory than statement based variables, whose 
        values return to null once the statement is run. We're setting a row index 
        because we need to keep track of each row when we order it by price.
        
        Note: Make sure this is your first line (or that you're running this line) any 
        time you're running procedures in problem 5, otherwise your row index won't 
        reset. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
 /* 	***
	5b.) Next, let's select that user-defined variable and, within the statement, 
	increment it upwards by 1 (@rowindex:=@rowindex + 1). Give it an alias of 
        rowindex, not as a string (or user-defined variable) but as a statement
        variable. We'll also want to select the list price as well. Order the result
        by list price. */
SET @rowindex := -1;
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------  
/* 	****
	5c.) That last problem will be our subquery in this problem. We'll want to select
	the average list_price with an alias of Median from our subquery above (with
        an alias of p) and filter it where p.rowindex is the very middle of the
        subquery. We do this with a little bit of math:
        
        - p.rowindex IN ( FLOOR( @rowindex / 2 ), CEIL( @rowindex / 2 ) );
        
        The IN operator is shorthand for multiple OR conditions and allows you to 
        specify multiple values in a WHERE clause. FLOOR will return a bottom-rounded
        integer, CEIL will return a top-rounded integer. 
        
        At this point, @rowindex is the total number of rows, and dividing that by 
        two gets us the middle row. However, if there is an even amount of rows, we'll 
        get two different numbers. This is where the AVG() function in the select 
        statement comes into play, to find the middle value between the two middlemost 
        list_prices in the the subquery. */
SET @rowindex := -1;
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* 	*****
	5d. Find the median of the video card list_prices (category_id = 2).
	Remember to reset your @rowindex. */
---------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------
/* Way to go! There's still a lot more that you can do with this database, but we were
   able to use it to cover a lot of the basics and some more in-depth statistics. Feel
   free to use the space below to further explore, especially if you're interested in
   pc component prices and inventory volume in global warehouses! */
---------------------------------------------------------------------------------------



