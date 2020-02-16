 --Joins and Subueries (Worth 5%)

--1.	List the titles and prices of all books that have the cheapest price.
	select top 1 with ties title, price 
	from titles
	where price is not null
	order by price asc

--2.	List all titles that have sold more than 40 copies at a single store.
	select t.title, s.qty
	from titles t join sales s
	on s.title_id = t.title_id
	where s.qty > 40

--3.	List all authors who have not published any books.
	select a.au_fname, a.au_lname
	from authors a left join titleauthor ta
	on a.au_id = ta.au_id
	where ta.au_id  is null

--4.	List all the publishers who have published any business books.
	select p.pub_name, t.type
	from publishers p join titles t
	on p.pub_id = t.pub_id
	where t.type = 'business'
	group by p.pub_name, t.type

--5.	List all authors who have published a “popular computing” book (these books have type = 'popular_comp' in the titles table).
	select a.au_fname, a.au_lname, t.type
	from authors a join titleauthor ta
	on a.au_id = ta.au_id
	join titles t
	on ta.title_id = t.title_id
	where t.type = 'popular_comp'

--6.	List all the cities where both an author (or authors) and a publisher (or publishers) are located.
	select a.au_fname, a.au_lname, p.pub_name, p.city
	from authors a join publishers p
	on a.city = p.city
	
--7.	List all cities where an author, but no publisher, is located.
	select a.city
	from authors a left join publishers p
	on a.city = p.city
	where p.city is null
	group by a.city

--8.	List all titles that have sold no copies.
	select title
	from titles t left join sales s
	on t.title_id = s.title_id
	where s.title_id is null

--9.	List the title and total sales of each book whose total sales is less than the average totals sales across all books.
	select t.title, sum(s.qty) as [Total Sales]
	from sales s join titles t
	on s.title_id = t.title_id
	group by t.title
	having sum(s.qty) < (
	select avg(x.[Sum Of Sales]) as [Average Total Sales]
	from 
	(select sum(qty) as [Sum Of Sales] 
	from sales 
	group by title_id) as x
	)

--10.	List the publishers, and the number of books each has published, who are not located in California.
	select p.pub_name, count(t.pub_id) as [Number of Books Published]
	from publishers p join titles t
	on p.pub_id = t.pub_id
	where p.state not like 'CA'
	group by t.pub_id, p.pub_name

--11.	For each book, list the number of stores where it has been sold.
	select t.title, count(s.title_id) as [Number of Stores That Sold the Book]
	from titles t join sales s
	on t.title_id = s.title_id
	group by t.title, s.title_id
	order by [Number of Stores That Sold the Book] desc

--12.	For each book, list its title, the largest quantity of it sold at any one store, and the name of that store.
	select t.title, max(s.qty) as [Largest Quantity Sold], st.stor_name
	from titles t join sales s
	on t.title_id = s.title_id
	join stores st
	on st.stor_id = s.stor_id
	group by t.title, st.stor_name

--13.	Increase by two points the royalty rate for all books that have sold more than 30 copies total.
	update roysched
	set royalty = (royalty + 2)
	where title_id in (select title_id from sales where qty > 30)

	select *
	from roysched

/*
Query 14: Challenge Problem. Think carefully about what set you need to produce to answer this question, and what tables you need to join to produce that set.
14.	List all types of books published by more than one publisher.
*/
	select distinct t1.type
	from titles t1 join titles t2
	on t1.type = t2.type
	and t1.pub_id != t2.pub_id

