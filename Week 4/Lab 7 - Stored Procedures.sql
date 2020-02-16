/*
Using Transact-SQL : Exercises
------------------------------------------------------------
*/

--Exercises for section 12 : STORED PROCEDURE

--*In all exercises, write the answer statement and then execute it.

/*
e12.1		Create a SP that returns the people with a family name that 
			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.
*/

	create proc vowelFamilyName
	as
	select PersonID, FullName 
	from Person
	where FamilyName like '[A,E,I,O,U]%'
	go

	exec vowelFamilyName
			
/*
e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
			have enrolments in that semester. List the PaperID and PaperName.
*/
	create proc enrolledPaperInSemester(@semesterID as varchar(6))
	as
	select p.PaperID, p.PaperName
	from
	Paper p join Enrolment e
	on p.PaperID = e.PaperID
	where e.SemesterID = @semesterID
	go

	select SemesterID from Semester
	exec enrolledPaperInSemester '2019S1'

/*
e12.3		Create a SP that creates a new semester record. the user must supply all
			appropriate input parameters.
*/

	create proc insertSemester(
		@semesterID varchar(6),
		@startDate datetime,
		@endDate datetime
	)
	as
	insert Semester
	values (@semesterID, @startDate, @endDate)
	go

	exec insertSemester '2021S2', '2021-06-06', '2021-12-18'
	select * from Semester