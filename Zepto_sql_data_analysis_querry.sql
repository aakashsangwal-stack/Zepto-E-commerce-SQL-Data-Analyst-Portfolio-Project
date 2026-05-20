create database Zepto;
use Zepto;
select * from zepto_data;
ALTER TABLE zepto_data
ADD COLUMN sku_id INT AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE zepto_data
CHANGE COLUMN `ï»¿Category` category VARCHAR(120);
ALTER TABLE zepto_data
MODIFY COLUMN sku_id INT FIRST;
select * from zepto_data;

#Null values

SELECT * FROM zepto_data
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR availableQuantity IS NULL
OR quantity IS NULL;

#different product categories
select distinct category
 from zepto_data
 order by category;

#Products in stock vs out of stock
select outOfStock, count(sku_id)
from zepto_data
group by outOfStock;

#product name present multiple time 
select name , count(sku_id) as "Number of SKU"
from zepto_data
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

# Data cleaning
#product with price = 0
select * from zepto_data
where mrp = 0 or discountedSellingPrice =0;
 
 # then we delete that row by using this 
delete from zepto_data 
where mrp  = 0
and sku_id > 0;
SELECT * FROM zepto_data;

# convert paise to rupees
update zepto_data
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0
where sku_id > 0;
SELECT * FROM zepto_data;

#Q1. what are the top 10 best values product based on the discount percentage.alter?
select distinct name, mrp, discountPercent
from zepto_data
order by discountPercent desc
limit 10;

#Q2.Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto_data
WHERE outOfStock = 'TRUE'
AND mrp > 300
ORDER BY mrp DESC;

#Q3. .Calculate Estimated Revenue for each category
select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue
 from zepto_data
 group by category
 order by total_revenue;

#Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp, discountPercent
 from zepto_data
 where mrp > 500 and discountPercent <10
 order by mrp desc,
 discountPercent desc;
 
#Q5. Identify the top 5 categories offering the highest average discount percentage.
select category ,
round(avg(discountPercent),2) as avg_discount
from zepto_data
group by category
order by avg_discount desc
limit 5;

#Q6.Find the price per gram for products above 100g and sort by best value.
select distinct name , weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto_data
order by price_per_gram;

#Q7. Group the products into categories like Low, Medium, Bulk.
select distinct name, weightInGms,
 case when weightInGms< 1000 then "Low"
 when weightInGms <5000 then 'medium'
 else "Bulk"
 end as weight_category
 from zepto_data
 order by weight_category;

#Q8. .What is the Total Inventory Weight Per Category ?
select category,
 sum(weightInGms * availableQuantity) as total_weight
  from zepto_data
   group by category
 order by total_weight;



