/*
Exercises for section 4

delete from PaperInstance where PaperID = 'IN610' -- I populated this table using a cross join so all of the data will match otherwise.
insert into Enrolment values ('IN511', '2019S2', 102);
*/

/*
4.1	List the starting date and ending date of each occasion 
	IN511 Programming 2 has run.
*/
	select e.PaperID, s.StartDate, s.EndDate from
	Semester s join Enrolment e
	on s.SemesterID = e.SemesterID
	where e.PaperID like 'IN511'

/*
4.2	List all the full names of the people who have ever enrolled in
	IN511 Programming 2 .
	If a person has enrolled more than once, do not repeat their name.
*/
	select e.PaperID, p.FullName from
	Enrolment e join Person p
	on e.PersonID = p.PersonID
	where e.PaperID like 'IN511'
	group by p.FullName, e.PaperID

/*
4.3	List all the full names of all the people who have never enrolled in a paper
	(according to the data on the database).
*/
	select p.FullName from 
	Person p left join Enrolment e
	on p.PersonID = e.PersonID
	where e.PersonID IS NULL

/*
4.4	List all the papers that have never been run (according to the data).There are currently none so insert one in order to test the query.
Insert into Paper values ('IN728', 'Programming5') 
*/
	select p.PaperName from 
	Paper p left join PaperInstance pa
	on p.PaperID = pa.PaperID
	where pa.PaperID IS NULL

/*
4.5	List all the semesters, showing semester start date and length in days, in which IN511 has run.
*/
	select s.StartDate, datediff(day, s.StartDate, s.EndDate) as [Length in Days] from 
	Semester s join PaperInstance p
	on s.SemesterID = p.SemesterID
	where p.PaperID like 'IN511'

/*
4.6	Develop a statement that returns all people that enrolled in IN511 
	in a semester that started on or between 12-Apr-2018 and 13-Aug-2019.
	Display the full name of each person and the year in which they enrolled. 
	Ensure the people are listed alphabetically according to their family name then given name.
*/
	select p.FullName, s.StartDate from
	Person p join Enrolment e
	on p.PersonID = e.PersonID 
	join Semester s
	on s.SemesterID = e.SemesterID
	where s.StartDate between '12-Apr-2018' and '13-Aug-2019' and e.PaperID like 'IN511'
	order by p.FamilyName, p.GivenName

--Exercises for section 5

/*
5.1	List all the papers that have a paper instance. 
	Display the PaperID and number of instances of the paper.
*/
	select pa.PaperID, count(pa.PaperID) as [Number of Papers] from
	PaperInstance pa join Paper p
	on pa.PaperID = p.PaperID
	group by pa.PaperID

/*
5.2	How many people, in total over all semesters, have enrolled in each of the papers
	that have been delivered? Display the paper ID, paper name and enrolment count.
*/
	select p.PaperID, p.PaperName, count(e.PaperID) as [Number of Person Enroled] from
	Paper p join Enrolment e
	on p.PaperID = e.PaperID
	group by p.PaperID, p.PaperName

/*
5.3	How many people, in total over all semesters, have enrolled in each of the papers
	listed on the Paper table? Display the paper ID, paper name and enrolment count.
*/
	select p.PaperID, p.PaperName, count(e.PaperID) as [Number of Person Enroled] from
	Paper p left join Enrolment e
	on p.PaperID = e.PaperID
	group by p.PaperID, p.PaperName

/*
5.4	List the paper instance with the highest enrolment. 
	Display the paper instance's start date, end date, paper name and enrolment count.
*/
	select top 1 with ties s.StartDate, s.EndDate, p.PaperName, count(e.PaperID) as [Number of People Enroled]
	from Paper p join PaperInstance pa
	on p.PaperID = pa.PaperID
	join Semester s
	on s.SemesterID = pa.SemesterID
	join Enrolment e
	on pa.PaperID = e.PaperID
	group by e.PaperID, s.StartDate, s.EndDate, p.PaperName
	order by [Number of People Enroled] desc

/*
5.5	List all the people who have 3, 4 or 5 enrolments.
*/
	select p.FullName, count(e.PersonID) as [Enroled Count]
	from Person p join Enrolment e
	on p.PersonID = e.PersonID
	group by e.PersonID, p.FullName
	having count(e.PersonID) between 3 and 5