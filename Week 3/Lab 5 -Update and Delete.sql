/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Note: I will be marking off all labs from the first week on Friday, make sure you have committed your work to GitLab.
		If you are using GitHub you need to send me a link to your repository.
*/

--Exercises for section 9 : UPDATE

--*In all exercises, write the answer statement and then execute it.

--e9.1	Change the name of IN628 to 'Object-Oriented Software Development (discontinued after 2019)'  
	update Paper
	set PaperName = 'Object-Oriented Software Development'
	where PaperID = 'IN628'
	
	select * from Paper
	where PaperID = 'IN628'

/*
e9.2	For all the semesters that start after 01-June-2018, alter the end date
		to be 14 days later than currently recorded.
*/
	update Semester
	set EndDate = EndDate + 14
	where StartDate > '2018-06-01'

	select EndDate, StartDate
	from Semester
	where StartDate > '2018-06-01'

/*
e9.3	Imagine a strange enrolment requirement regarding the students
		enrolled in IN238 for 2020S1 [Ensure your database has all the records
		created by exercise e8.4]: all students with short names [length of FullName
		is less than 12 characters] must have their enrolment moved 
		from 2020S1 to 2019S2. Write a statement that will perform this enrolment change.
*/
	insert into PaperInstance
	values('IN238', '2019S2')

	update Enrolment
	set SemesterID = '2019S2'
	from Enrolment e join Person p
	on e.PersonID = p.PersonID
	where e.PaperID = 'IN238' and len(p.FullName) < 12

	select *
	from Enrolment join Person
	on Person.PersonID = Enrolment.PersonID
	where PaperID = 'IN238' and len(Person.FullName) < 12

--Exercises for section 10 : DELETE

--*In all exercises, write the answer statement and then execute it.

--e10.1	Write a statement to delete all enrolments for IN238 Extraspecial Topic in semester 2020S1.
	delete Enrolment
	where PaperID = 'IN238' and SemesterID = '2020S1'

	select * from Enrolment
	where PaperID = 'IN238' and SemesterID = '2020S1'

--e10.2	Delete all PaperInstances that have no enrolments.
	delete PaperInstance
	from PaperInstance p left join Enrolment e
	on p.PaperID = e.PaperID and p.SemesterID = e.SemesterID
	where e.PaperID is null 

	select * from PaperInstance

		