/*
Using Transact-SQL : Exercises
------------------------------------------------------------
*/

--Exercises for section 8 : INSERT

--In all exercises, write the answer statement and then execute it.

--e8.1	Write a statement to create 2 new papers: IN338 and IN238 Extraspecial Topic 
	insert into Paper
	values('IN338', 'Robotics'), ('IN238', 'Data Science')

	select * from Paper

/*
e8.2	Create a new user (yourself)
		Write statements that will add three enrolments for you
		in papers you have completed (Add extra papers if required).
*/	
	insert into Person(PersonID, GivenName, FamilyName, FullName)
	values(112, 'Carthur', 'Pongpatimet', 'Carthur Pongpatimet')
	
	select * from Person

	insert into Enrolment
	select top 3 e.PaperID, e.SemesterID, 112
	from Enrolment e join PaperInstance pa
	on e.PaperID = pa.PaperID
	group by e.PaperID, e.SemesterID
	order by e.SemesterID
	
	select * from Enrolment 
	where PersonID = 112 
		 
/*
e8.3	Imagine that every paper on the database will run in 2021.
		Write the statements that will create all the necessary paper instances. You will need to add the Semester
		This can be done using a subselect or a left outer join.
*/
	insert into Semester
	values('2021S1', '02/02/2021', '06/06/2021')

	select * from Semester
	where SemesterID like '2021S1'

	insert into PaperInstance
	select p.PaperID, '2021S1'
	from Paper p left join PaperInstance pa
	on p.PaperID = pa.PaperID
	group by p.PaperID

	select * from PaperInstance
	where SemesterID like '2021S1'

/*
e8.4	Imagine a strange path-of-study requirement: in semester 2020S1
		Find all people who are currently enrolled in IN605 and not enrolled in IN612 and enrol them in IN238.
		Write a statement to create the correct paper instance for IN238.
		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
		but	not enrolled in IN612 (semester 2019S2) and 
		will create IN238 (semester 2020S1) enrolments for them. Build it up one step at a time.
		
		1. create paper, semester and paper instance data
		2. Find IN605/2019S2 enrolments that are not in IN612
		3. insert new enrolments
*/
	insert into Semester
	values('2020S1', '02/02/2020', '06/06/2020')

	select * from Semester
	where SemesterID like '2020S1'

	insert into PaperInstance
	values('IN238', '2020S1')

	select * from PaperInstance
	where PaperID like 'IN238'

	insert into Enrolment
	select 'IN238', '2020S1', p.PersonID
	from Person p join Enrolment e
	on p.PersonID = e.PersonID
	where e.PaperID like 'IN605' and e.PaperID not like 'IN612' and e.SemesterID like '2019S2'

	select * from Enrolment
	where SemesterID = '2020S1'