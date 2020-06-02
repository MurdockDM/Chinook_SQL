-- 1 non_usa_customers.sql: Provide a query showing Customers (just their full
-- names, customer ID and country) who are not in the US.
SELECT
	CustomerId,
	FirstName,
	LastName,
	Country
FROM Customer
WHERE Country NOT LIKE 'USA';

-- 2 brazil_customers.sql: Provide a query only showing the Customers from Brazil.

SELECT *
FROM Customer
WHERE Country LIKE "Brazil";


-- 3 brazil_customers_invoices.sql: Provide a query showing the Invoices of
-- customers who are from Brazil. The resultant table should show the customer's
-- full name, Invoice ID, Date of the invoice and billing country.

SELECT
	i.InvoiceId,
	i.InvoiceDate,
	i.BillingCountry,
	c.FirstName,
	c.LastName
FROM Invoice i
	JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE Country Like "Brazil";


-- 4 sales_agents.sql: Provide a query showing only the Employees who are Sales
-- Agents.

SELECT *
FROM Employee
WHERE Title LIKE "Sales Support Agent";


-- 5 unique_invoice_countries.sql: Provide a query showing a unique/distinct list
-- of billing countries from the Invoice table.

SELECT DISTINCT
	BillingCountry
From Invoice
ORDER BY BillingCountry;

-- 6 sales_agent_invoices.sql: Provide a query that shows the invoices associated
-- with each sales agent. The resultant table should include the Sales Agent's
-- full name.


SELECT
	e.FirstName,
	e.LastName,
	e.Title,
	i.*
FROM Invoice i
	JOIN Customer c ON c.CustomerId = i.CustomerId
	JOIN Employee e ON c.SupportRepId = e.EmployeeId
Where e.Title LIKE "Sales%Agent"
ORDER BY e.FirstName;


-- 7 invoice_totals.sql: Provide a query that shows the Invoice Total, Customer
-- name, Country and Sale Agent name for all invoices and customers.

SELECT
	i.Total,
	i.BillingCountry,
	c.FirstName AS CustomerFirstName,
	c.LastName AS CustomerLastName,
	c.Country,
	e.FirstName,
	e.LastName
FROM Invoice i
	JOIN Customer c ON c.CustomerId = i.CustomerId
	JOIN Employee e ON e.EmployeeId = c.SupportRepId;

-- 8 total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?


SELECT STRFTIME('%Y',i.InvoiceDate) as Year, COUNT(i.InvoiceId)
FROM Invoice i
WHERE Year = '2009' or Year = '2011'
GROUP BY Year;

-- 9 total_sales_{year}.sql: What are the respective total sales for each of those
-- years?
SELECT STRFTIME('%Y',i.InvoiceDate) AS Year, COUNT(i.InvoiceId) 'Invoice Total', SUM(Total)
FROM Invoice i
WHERE Year = '2009' or Year = '2011'
GROUP BY Year;


-- 10 invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a
-- query that COUNTs the number of line items for Invoice ID 37.

SELECT
	COUNT(il.InvoiceId) AS 'Total Line Items for Id 37'
FROM InvoiceLine il
WHERE il.InvoiceId = 37;




-- 11 line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query
-- that COUNTs the number of line items for each Invoice. HINT: GROUP BY

SELECT
	il.InvoiceId,
	COUNT(il.InvoiceId) AS 'Total Line Items'
FROM InvoiceLine il
GROUP by il.InvoiceId;

-- 12 line_item_track.sql: Provide a query that includes the purchased track name
-- with each invoice line item.

SELECT
	il.InvoiceLineId,
	il.InvoiceId,
	t."Name"
FROM InvoiceLine il
	JOIN Track t ON t.TrackId = il.TrackId
GROUP by il.InvoiceId;

-- 13 line_item_track_artist.sql: Provide a query that includes the purchased track
-- name AND artist name with each invoice line item.

SELECT
	il.InvoiceLineId,
	il.InvoiceId,
	t."Name",
	art."Name"
FROM InvoiceLine il
	JOIN Track t ON t.TrackId = il.TrackId
	JOIN Album a ON a.AlbumId = t.AlbumId
	JOIN Artist art ON art.ArtistId = a.ArtistId
GROUP by il.InvoiceId;


-- 14 country_invoices.sql: Provide a query that shows the # of invoices per
-- country. HINT: GROUP BY

SELECT
	Count(i.InvoiceId) AS "Number of Invoices",
	i.BillingCountry
FROM Invoice i
GROUP BY BillingCountry;

-- 15 playlists_track_count.sql: Provide a query that shows the total number of
-- tracks in each playlist. The Playlist name should be include on the resulant
-- table.

SELECT
	p.Name, Count(pt.PlaylistId) AS 'Number of Tracks'
FROM Playlist p
	LEFT JOIN PLaylistTrack pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name;


-- 16 tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no
-- IDs. The result should include the Album name, Media type and Genre.

SELECT t.Name AS "Track", a.Title AS "Album", g.Name AS "Genre", m.Name AS "Media Type"
FROM Track t
	JOIN Album a ON t.AlbumId = a.AlbumId
	JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
	JOIN Genre g ON t.GenreId = g.GenreId
ORDER BY a.Title, t.Name;


-- 17 invoices_line_item_count.sql: Provide a query that shows all Invoices but
-- includes the # of invoice line items.


SELECT COUNT(il.InvoiceLineId) as 'Total Invoice Line Items', i.*
FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
GROUP BY il.InvoiceId;


-- 18 sales_agent_total_sales.sql: Provide a query that shows total sales made by
-- each sales agent.


SELECT (e.FirstName || ' ' || e.LastName) as 'Agent Name', printf("%.2f",SUM(i.Total)) as 'Total Sales'
FROM Employee e
	LEFT JOIN Customer c
	ON e.EmployeeId = c.SupportRepId
	LEFT JOIN Invoice i
	ON c.CustomerId = i.CustomerId
WHERE e.Title = 'Sales Support Agent'
GROUP BY e.EmployeeId;


-- 19 top_2009_agent.sql: Which sales agent made the most in sales in 2009?

SELECT sub.agent AS "Sales Agent", MAX(sub.top) AS "Top 2009 Sales"
FROM
	(SELECT e.FirstName || " " || e.LastName AS agent, SUM(i.Total) AS top
	FROM Employee e
		JOIN Customer c ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i ON c.CustomerId = i.CustomerId
			AND i.InvoiceDate BETWEEN "2009-01-01" AND "2009-12-31"
	GROUP BY e.EmployeeId) sub;

-- Hint: Use the MAX function on a subquery.


-- 20 top_agent.sql: Which sales agent made the most in sales over all?

SELECT sub.agent AS "Sales Agent", MAX(sub.top) AS "Top 2009 Sales"
FROM
	(SELECT e.FirstName || " " || e.LastName AS agent, printf("%.2f", SUM(i.Total)) AS top
	FROM Employee e
		JOIN Customer c ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i ON c.CustomerId = i.CustomerId
	GROUP BY e.EmployeeId) sub;

-- 21 sales_agent_customer_count.sql: Provide a query that shows the count of
-- customers assigned to each sales agent.

SELECT (e.FirstName || ' ' || e.LastName) as 'Name', COUNT(c.SupportRepId) as 'Total Customers'
FROM Employee e
	JOIN Customer c
	ON c.SupportRepId = e.EmployeeId
GROUP BY c.SupportRepId;

-- 22 sales_per_country.sql: Provide a query that shows the total sales per
-- country.

SELECT DISTINCT i.BillingCountry as 'Country', SUM(i.Total) as 'Total Sales'
FROM Invoice i
GROUP BY i.BillingCountry;

-- 23 top_country.sql: Which country's customers spent the most?

SELECT i.BillingCountry AS country, SUM(i.Total) AS total
FROM Invoice i
GROUP BY i.BillingCountry
ORDER BY total DESC
LIMIT 1;


-- 24 top_2013_track.sql: Provide a query that shows the most purchased track of
-- 2013.

SELECT x.Song AS "Song" , MAX(x.Num) AS "Times Purchased"
FROM 
	(SELECT t.Name AS Song, SUM(il.Quantity) AS Num, i.InvoiceDate
		FROM Invoice i
		JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
		JOIN Track t ON il.TrackId = t.TrackId
		WHERE i.InvoiceDate BETWEEN "2013-01-01" AND "2013-12-31"
		GROUP BY t.Name) x;


-- 25 top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks
-- over all.

SELECT t.Name AS "Song", SUM(il.Quantity) AS "Times Purchased"
	FROM  InvoiceLine il
	JOIN Track t ON il.TrackId = t.TrackId
	GROUP BY t.Name
	ORDER BY "Times Purchased" DESC
	LIMIT 5;

-- 26 top_3_artists.sql: Provide a query that shows the top 3 best selling artists.

SELECT a.Name, SUM(il.Quantity) AS "Tracks Sold"
FROM Artist a
JOIN Album b ON b.ArtistId = a.ArtistId
JOIN Track t ON t.AlbumId = b.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.Name
ORDER BY "Tracks Sold" DESC
LIMIT 3;


-- 27 top_media_type.sql: Provide a query that shows the most purchased Media Type.

SELECT x.media AS "Media Type", MAX(x.num) AS "Amount of Media Sold"
	FROM 
		(SELECT m.Name AS media, SUM(il.Quantity) AS num
		FROM MediaType m
		JOIN Track t ON t.MediaTypeId = m.MediaTypeId
		JOIN InvoiceLine il ON t.TrackId = il.TrackId
		GROUP BY m.Name
		) x;
