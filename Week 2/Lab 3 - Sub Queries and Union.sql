/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Exercises for section 6 Subqueries

e6.1	List the paper with the lowest average enrolment per instance. Ignore all papers with no enrolments.
	Display the paper ID, paper name and average enrolment count.
*/
	select top 1 with ties p.PaperID, p.PaperName, cast(avg([Paper Count]) as decimal(9,2)) as [Average Enrolment] from
	(select PaperID, count(PaperID) as [Paper Count] from
	Enrolment
	group by PaperID) as e
	join Paper p 
	on p.PaperID = e.PaperID
	group by p.PaperName, p.PaperID
	order by [Average Enrolment] asc

/*
e6.2	List the paper with the highest average enrolment per instance. 
	Display the paper ID, paper name and average enrolment count.
*/
	select top 1 with ties p.PaperID, p.PaperName, cast(avg([Paper Count]) as decimal(9,2)) as [Average Enrolment] from
	(select PaperID, count(PaperID) as [Paper Count] from
	Enrolment
	group by PaperID) as e
	join Paper p 
	on p.PaperID = e.PaperID
	group by p.PaperName, p.PaperID
	order by [Average Enrolment] desc

/*
e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.
*/
	select p.PaperID, p.PaperName, s.StartDate, min([Paper Count]) as [Minimum Enrolment], max([Paper Count]) as [Maximum Enrolment], avg([Paper Count]) as [Average Enrolment] from
	(select PaperID, SemesterID, count(PaperID) as [Paper Count] from
	Enrolment
	group by PaperID, SemesterID) as e
	join Semester s
	on s.SemesterID = e.SemesterID
	join Paper p
	on p.PaperID = e.PaperID
	group by p.PaperID, p.PaperName, s.StartDate

/*
e6.4	Which paper attracts people with long names? Find the background statistics 
	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
	sample standard deviation full name length & sample size (that is: number of enrolments).
*/
	select p.PaperName, cast(avg([Name Length]) as decimal(9,2)) as [Average Name Length], count(e.PaperID) as [Enrolment Count]
	from (select len(p.FullName) as [Name Length], p.PersonID
	from Person p) as x
	join Enrolment e
	on x.PersonID = e.PersonID
	join Paper p
	on p.PaperID = e.PaperID
	group by p.PaperName, e.PaperID

/*
e6.5	Rank the semesters from the most loaded (that is: the highest number of enrolments) to
	the least loaded. Calculate the ordinal position (1 for first, 2 for second...) of the semester
	in this ranking.
*/
	select count(e.PersonID) as [Number of People Enrolled], s.SemesterID
	from Enrolment e join Semester s
	on e.SemesterID = s.SemesterID
	group by s.SemesterID, e.PersonID
	order by [Number of People Enrolled] desc

--Exercises for section 7
--Use UNION to solve these tasks. 
--Note that these tasks could possibly be solved by another non-UNION statement.
--Can you also write a non-UNION statement that produces the same result?   

/*
e7.1	In one result, list all the people who enrolled in a paper delivered during 2019 and
	all the people who have enrolled in IN605. 
	The result should have three columns: PersonID, Full Name and the reason the person
	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'
*/
	select p.PersonID, p.FullName, 'Enrolled in 2019' as [Type]
	from Person p join Enrolment e
	on p.PersonID = e.PersonID
	join Semester s
	on s.SemesterID = e.SemesterID
	where s.StartDate between '01/01/2019' and '12/31/2019'
	group by p.PersonID, p.FullName
	union 
	select p.PersonID, p.FullName, 'Enrolled in IN605'
	from Person p join Enrolment e
	on p.PersonID = e.PersonID
	join Paper pa
	on pa.PaperID = e.PaperID
	where pa.PaperID like 'IN605'
	group by p.PersonID, p.FullName

/*
e7.2	Produce one resultset with two columns. List the all Paper Names and all the Person Full Names in one column.
	In the other column calculate the number of characters in the name.
	Sort the result with the longest name first.
*/
	select FullName, len(FullName) as [Number of characters]
	from Person p
	group by FullName
	union all
	select PaperName, len(PaperName)
	from Paper 
	group by PaperName
	order by [Number of characters] desc