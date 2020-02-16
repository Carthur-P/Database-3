--Creating user tables
begin
	use Cars
	declare @ListOfStudents table(
		StudentID int identity(1,1) not null primary key,
		LastName nvarchar(100) not null,
		FirstName nvarchar(100) not null,
		Username nvarchar(100) not null,
		UserPassword nvarchar(100) not null
	)

	insert into @ListOfStudents (LastName, FirstName, Username, UserPassword) select LastName, FirstName, Username, Password from Users
	select * from @ListOfStudents
	
	if exists (select * from @ListOfStudents)
	begin
		--declaring loop component
		declare @currentRow int, @maximumRows int

		--declaring user login component
		declare @ExecTemp nvarchar(1000), @_Login nvarchar(100), @_Password nvarchar(100), @_DefaultDatabase nvarchar(100)

		--declaring database component
		declare @dbFilePath nvarchar(2000), 
			@dbLogPath nvarchar(2000),
			@createFolderXP nvarchar(2000),
			@domainLogin nvarchar(30), 
			@prefix nvarchar(200),
			@DBName nvarchar(1000),
			@logicalDataName nvarchar(600),
			@logicalLogName nvarchar(600),
			@dataFileName nvarchar(600),
			@logFileName nvarchar(600),
			@dataSize nvarchar(500), 
			@dataMaxSize nvarchar(500),
			@dataFileGrowth nvarchar(500),
			@logSize nvarchar(500), 
			@logMaxSize nvarchar(500),
			@logFileGrowth nvarchar(500)

		--setting loop component
		set @currentRow = 1
		set @maximumRows = (select count(*) from @ListOfStudents)

		while @currentRow <= @maximumRows
		begin
			--setting login username 
			set @_Login = (select Username from @ListOfStudents where StudentID = @currentRow)

			--setting database information and creating database
			print('Begin create database')
			set @dbFilePath = N'/var/opt/mssql/data/'
			set @dbLogPath = N'/var/opt/mssql/data/'
			set @DBName = @_Login
			set @LogicalDataName= @DBName + '_dat'
			set @LogicalLogName= @DBName + '_log'
			set @DataFileName= @dbFilePath + @DBName + '.mdf'
			set @LogFileName= @dbLogPath + @DBName + '.ldf'
			set @dataSize = N'8192KB'
			set @dataMaxSize = N'200MB'
			set @dataFileGrowth = N'65536KB'
			set @logSize = N'8192KB'
			set @logMaxSize = N'100MB'
			set @logFileGrowth = N'65536KB'
			set @ExecTemp = 'CREATE DATABASE ' + @DBName + ' ON ('
			+ 'NAME = [' + @LogicalDataName + '], '
			+ 'FILENAME = [' + @DataFileName + '], '
			+ 'SIZE = ' + @DataSize + ', '
			+ 'MAXSIZE = ' + @DataMaxSize + ', '
			+ 'FILEGROWTH = ' + @DataFileGrowth + ') '
			+ 'LOG ON ('
			+ 'NAME = [' + @LogicalLogName + '], '
			+ 'FILENAME = [' + @LogFileName + '], '
			+ 'SIZE = ' + @LogSize + ', '
			+ 'MAXSIZE = ' + @LogMaxSize + ', '
			+ 'FILEGROWTH = ' + @LogFileGrowth + ') ' 
			exec (@ExecTemp)

			--setting user login components and creating user
			set @_Password = (select UserPassword from @ListOfStudents where StudentID = @currentRow) + 'DB3715'
			set @_DefaultDatabase = (select DB_NAME())
			set @ExecTemp = 'CREATE LOGIN ' + @_Login + ' WITH PASSWORD = ''' + @_Password + ''', DEFAULT_DATABASE = ' + @_DefaultDatabase 
			print(@ExecTemp)
			exec (@ExecTemp)

			--creating user for database
			SET @ExecTemp='USE ' + @DBName + ' CREATE USER [' + @_Login + '] FOR LOGIN [' + @_Login + ']'
			exec (@ExecTemp)

			--increasing the loop counter by 1
			set @currentRow += 1;
		end
	end
end
go 


