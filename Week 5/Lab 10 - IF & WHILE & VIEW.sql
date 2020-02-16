/*
Using Transact-SQL : Exercises
------------------------------------------------------------
*/

--Exercises for Section 15

/*
15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
		with the most enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.
*/
	create view BigPaperInstance 
	as
	select x.PaperID, p.PaperName, x.SemesterID, s.StartDate, s.EndDate
	from 
	(select top 10 count(e.PaperID) as [Enrolment Count], pa.PaperID, pa.SemesterID
	from Enrolment e join PaperInstance pa
	on e.PaperID = pa.PaperID
	group by pa.PaperID, pa.SemesterID
	order by count(e.PaperID) desc) as x
	join Paper p 
	on p.PaperID = x.PaperID
	join Semester s
	on s.SemesterID = x.SemesterID

	select * from BigPaperInstance

/*
15.2    Develop a view [SmallPaper] that finds the 10 paper instances
		with the least (lowest number of) enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.
*/
	create view SmallPaper
	as
	select x.PaperID, p.PaperName, x.SemesterID, s.StartDate, s.EndDate
	from 
	(select top 10 count(e.PaperID) as [Enrolment Count], pa.PaperID, pa.SemesterID
	from Enrolment e join PaperInstance pa
	on e.PaperID = pa.PaperID
	group by pa.PaperID, pa.SemesterID
	order by count(e.PaperID) asc) as x
	join Paper p 
	on p.PaperID = x.PaperID
	join Semester s
	on s.SemesterID = x.SemesterID

	select * from SmallPaper

--15.3	Write a view that lists all the current first year students (PaperID = IN5*)
	create view FirstYearStudent
	as
	select p.FullName
	from Person p join Enrolment e
	on p.PersonID = e.PersonID
	where e.PaperID like 'IN5%'
	group by p.FullName
	go

	select * from FirstYearStudent

/*
***************************************************************************************

	You can reference a Database table even if you are not 
	currently connected to it as long as you use its fully qualified domain name.
	The following two questions are using the countries table in the World Database.
	You can use this to find the FQDN for World using a new query pointed at that Database:
	
	select
		@@SERVERNAME [server name],
		DB_NAME() [database name],
		SCHEMA_NAME(schema_id) [schema name], 
		name [table name],
		object_id,
		"fully qualified name (FQN)" =
		concat(QUOTENAME(DB_NAME()), '.', QUOTENAME(SCHEMA_NAME(schema_id)),'.', QUOTENAME(name))
	from sys.tables
	where type = 'U' -- USER_TABLE
*/

/*
15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
		Show the code and name of each country.
*/
	drop view ConsonantCountry
	create view ConsonantCountry
	as
	select Code, Name
	from [World].[dbo].[country]
	where Name like '[b c d f g h j k l m n p q r s t v w x y z]%'
	go

	select * from ConsonantCountry
	order by Name asc

/*
15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
		gained their independence within the last 100 years. 
		Make sure the view adjusts the resultset to take account of the date when it is run.
*/
	drop view RecentlyIndependentCountry
	create view RecentlyIndependentCountry
	as
	select IndepYear, Name, DATEDIFF(day, IndepYear, year(getdate())) as [Years Independent]
	from [World].[dbo].[country]
	where DATEDIFF(day, IndepYear, year(getdate())) > 100
	go

	select * from RecentlyIndependentCountry