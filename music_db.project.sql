🙋‍--Who Is The Senior Most Employee Based On Job Titile?

    select * from employee 
    order by levels desc
    limit 1;

🙋‍--Which Countries Have The Most Invoices?

    select * from invoice
    select count(*) as c, billing_country
    from invoice
    group by billing_country
    order by c desc;

🙋‍--What Are Top 3  Values Of Total Invoice?

    select * from invoice;

    select total from invoice
    order by total desc
    limit 3;

🙋‍♂️--Which City  Has The Best Customers? 
--We Would Like To throw a promostional music festival in the city we
--made the money most . Write a query that returns  one city that has 
--the highest sum of invoice totals.  
--Return both the city name and sum a of all invoice total.

    select * from invoice;
    select sum(total) as invoice_total , billing_city
    from invoice
    group by billing_city 
    order by invoice_total desc;

🙋‍--Who is the best customer? The person who has spent the most money 
--will declare as a best customer.
--write the query that return the person who has spent the money most.

    select * from customer;
    select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
    from customer
    join invoice on customer.customer_id = invoice.customer_id
    GROUP BY customer.customer_id, customer.first_name, customer.last_name
    ORDER BY total desc
    limit 1;

🙋‍--Write a query to return email,fisrt_name , last_name and genre for all
--rock music listener. Return your list order alphabeticaly by email starting
--with A.

    select * from invoice_line;
    select distinct email, first_name, last_name
    from customer
    join invoice on customer.customer_id = invoice.customer_id
    join invoice_line on invoice.invoice_id = invoice_line.invoice_line_id
    where track_id in(
    select track_id from track
    join genre on track.genre_id = genre.genre_id
    where genre.name like 'Rock'
)
    order by email;

🙋--Lets invite a artist who has writen the most Rock music in our database
--write a query that return the Artist name and total track count of the top 10    
--Rock band.

    select * from genre;

    select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
    from track
    join album on album.album_id = track.album_id
    join artist on artist.artist_id = album.artist_id
    join genre on genre.genre_id = track.genre_id
    where genre.name like 'Rock'
    group by artist.artist_id, artist.name
    order by number_of_songs desc
    limit 10;

🙋--Return all the track name that have a songs length longer than a average song length.
--Return the name and milisecond of each track. Order by the song length with longest song listed first
    select name, milliseconds
    from track
    where milliseconds > (
    select avg (milliseconds) as avg_track_length
    from track)
    order by milliseconds desc;

🙋--Find how much amount spent by customer on artist? Write a query to return customer name, artist name
--and total spent.

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t ON t.track_id = il.track_id
    JOIN album alb ON alb.album_id = t.album_id  
    JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
    GROUP BY 1,2,3,4
    ORDER BY 5 DESC;

    select * from track;

🙋--Write a query that determins the customerthat has spent the most on music for each country.Writes
--a query thats returns the country along with the top customer and how much they spent . For countries 
--where the top amount spent is shared,  provide all customer who spent this amount.

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

-----------------------------------------------Thank🙏You-------------------------------------------------