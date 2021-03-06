/****** Script for SelectTopNRows command from SSMS  

SELECT TOP (1000) [PaperID]
      ,[SemesterID]
      ,[PersonID]
  FROM [IN705_201902_kwood].[dbo].[Enrolment]
*/
  
--Week 2 labs are due on Friday 16 August

/* 
13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
		and a semesterID and calculates the number of enrolments in the 
		relevant paper instance. It returns the enrolment count as an
		output parameter.
*/
	create proc EnrolmentCount(@paperID varchar(7), @semesterID varchar(7), @enrolmentCount int output)
	as
	set @enrolmentCount = (
	select count(PersonID)
	from Enrolment
	where PaperID = @paperID and SemesterID = @semesterID
	)
	go

	declare @eCount int 
	exec EnrolmentCount 'IN510', '2019S1', @eCount output 
	print ''
	print 'Enrolment count for IN510 paper running in the semester 2019S1 is ' + cast(@eCount as varchar)

/*		
13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
		is optional and defaults to the current semester. If there is no
		current semester, it chooses the most recent semester. 
*/
	alter proc EnrolmentCount(@paperID varchar(7), @semesterID varchar(7) = null, @enrolmentCount int output)
	as
	if @semesterID is null set @semesterID = (
	select top 1 SemesterID
	from Semester
	order by StartDate desc
	)

	set @enrolmentCount = (
	select count(PersonID)
	from Enrolment
	where PaperID = @paperID and SemesterID = @semesterID
	)
	go

--13.3  Write the script you will need to test 13.2 hint: you may have to cast your output
	insert into PaperInstance
	values ('IN510', '2021S2')
	
	insert into Enrolment
	values ('IN510', '2021S2', 101)

	select * from Enrolment

	declare @eCount int 
	exec EnrolmentCount @paperID = 'IN510', @enrolmentCount = @ecount output
	print ''
	print 'Enrolment count for IN510 paper running in the latest semester is ' + cast(@eCount as varchar)
