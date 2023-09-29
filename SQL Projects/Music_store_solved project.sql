Q1: which employee is the senior most employee?
select * from employee
order by levels desc
limit 1

Q2: which countries has most number of invoices?

select count(invoice_id) as num_of_invoice,billing_country from invoice
group by billing_country
order by num_of_invoice desc
limit 1

Q3: what are top 3 values of total invoice?

select * from invoice
order by total desc
limit 3

Q4: which city has the best customers, that is,the city which has highest invoice totals?

select sum(total)as total, billing_city from invoice
group by billing_city
order by total desc  
limit 1

Q5: who is the best customer who has spent most money,write a query that retruns the name of the person?

select customer.customer_id,SUM(invoice.total)as total, customer.first_name,customer.last_name
from customer join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

Q6: write a query to return the email, first name, last name & genre of all rock music listener.
return the list ordered alphabetically by email staring with A.

select distinct first_name,last_name, email from customer join invoice
on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in (select track_id from track join genre
on track.genre_id=genre.genre_id
where genre.name like 'Rock')
order by email

Q7: Artists who have written most rock music in our dataset.write a query that return 
the artist name and total track count of the top 10 rock bands.

select * from track join genre 
on track.genre_id=genre.genre_id


Q8: Write a query that returns the artists name and total track count of the top 10 rock 
bands.

select artist.name,count(artist.name) as track_number from artist join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
where track_id in (select track.track_id from genre join track
on genre.genre_id=track.genre_id
where genre.name like 'Rock')
group by artist.name
order by track_number desc
limit 10

select name, milliseconds from track where milliseconds >(select avg(milliseconds) from track) 
order by milliseconds desc

Q9: how much amount spent by each customer on artists? write a query to return customer name 
artists name & total spent.

select customer.first_name,customer.last_name,artist.name,sum((invoice_line.unit_price * invoice_line.quantity)) as total_spent
from customer join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on invoice_line.track_id=track.track_id
join album on album.album_id= track.album_id
join artist on artist.artist_id=album.artist_id
where artist.name like 'Queen'
group by 1,2,3
order by total_spent desc

Q10: write a query that returns each country along with the top genre. Determine the 
popular genre by the genre with highest amount of the purchases.

with t1 as 
(
select customer.country,genre.name, count(invoice_line.quantity) as total_sell,
row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as row_num
from customer join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 1,2
)

select * from t1 where row_num=1

Q11: query that determines the customer that has spent the most on music for each 
country. write a query that returns the country along with the top customer and how
much they spent.

with t2 as
(
select customer.country,sum(invoice_line.unit_price*invoice_line.quantity) as tot_spent,
customer.first_name,customer.last_name,
row_number() over (partition by customer.country order by sum(invoice_line.unit_price*invoice_line.quantity) desc) as row_num
from customer join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
group by 3,4,1
)

select * from t2 where row_num=1