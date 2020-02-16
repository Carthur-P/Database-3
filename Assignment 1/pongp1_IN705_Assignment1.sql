--Creating all the tables
	drop table AssemblySubcomponent
	drop table QuoteComponent
	drop table Component
	drop table Supplier
	drop table Customer
	drop table Category
	drop table Quote
	drop table Contact

	create table Contact (
		ContactID int identity(1,1) not null primary key,
		ContactName nchar(50) not null, 
		ContactPostalAddress nchar(100) not null, 
		ContactWWW nchar(100),
		ContactEmail nchar(100),
		ContactPhone nchar(30) not null,
		ContactFax nchar(30)
	)
	go

	create table Supplier (
		SupplierID int not null primary key foreign key references Contact(ContactID),
		SupplierGST float not null
	)

	create table Category (
		CategoryID int identity(1,1) not null primary key,
		CategoryName nchar(30) not null
	)
	go

	create table Component (
		ComponentID int identity(1,1) not null primary key,
		ComponentName nchar(50) not null, 
		ComponentDescription nchar(100) not null, 
		SupplierID int not null foreign key references Supplier(SupplierID) on delete cascade on update cascade, 
		ListPrice money not null, 
		TradePrice money not null, 
		TimeToFit float not null, 
		CategoryID int not null foreign key references Category(CategoryID) on delete cascade on update cascade
	)
	go

	create table AssemblySubcomponent (
		AssemblyID int not null foreign key references Component(ComponentID) on delete no action on update cascade,
		SubcomponentID int not null foreign key references Component(ComponentID),
		Quantity decimal(8,4) not null,

		constraint PK_AsseblySubcomponet
		primary key(AssemblyID, SubcomponentID),

		constraint NotTheSameKey
		check(AssemblyID != SubcomponentID) 
	)
	go

	create table Customer (
		CustomerID int not null primary key foreign key references Contact(ContactID) on delete cascade on update cascade
	)
	go

	create table Quote (
		QuoteID int identity(1,1) not null primary key,
		QuoteDescription nchar(100) not null,
		QuateDate date not null,
		QuotePrice money,
		QuoteCompiler nchar(100),
		CustomerID int not null foreign key references Contact(ContactID) on delete no action on update cascade,
	)
	go

	create table QuoteComponent (
		ComponentID int not null foreign key references Component(ComponentID),
		QuoteID int not null foreign key references Quote(QuoteID) on delete cascade on update cascade,
		Quantity int not null,
		TradePrice money not null,
		ListPrice money not null,
		TimeToFit float not null,
		
		constraint PK_QuoteComponent
		primary key(ComponentID, QuoteID),
	)
	go

--initial insert statements for the three created tables
	--categories inserts
	insert Category (CategoryName) values ('Black Steel')
	insert Category (CategoryName) values ('Assembly')
	insert Category (CategoryName) values ('Fixings')
	insert Category (CategoryName) values ('Paint')
	insert Category (CategoryName) values ('Labour')

	--contacts inserts
	declare @ABC int, @XYZ int, @CDBD int, @BITManf int
	insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
	values ('ABC Ltd.', '17 George Street, Dunedin', 'www.abc.co.nz', 'info@abc.co.nz', '471 2345', null)
	set @ABC = @@IDENTITY
	insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
	values ('XYZ Ltd.', '23 Princes Street, Dunedin', null, 'xyz@paradise.net.nz', '4798765', '4798760')
	set @XYZ = @@IDENTITY
	insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
	values ('CDBD Pty Ltd.', 'Lot 27, Kangaroo Estate, Bondi, NSW, Australia 2026', 'www.cdbd.com.au', 'support@cdbd.com.au', '+61 (2) 9130 1234', null)
	set @CDBD = @@IDENTITY
	insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
	values ('BIT Manufacturing Ltd.', 'Forth Street, Dunedin', 'bitmanf.tekotago.ac.nz', 'bitmanf@tekotago.ac.nz', '0800 SMARTMOVE', null)
	set @BITManf = @@IDENTITY

	--supplier inserts
	declare @GSTtax float
	set @GSTtax = 0.15
	insert Supplier values (@ABC, @GSTtax)
	insert Supplier values (@XYZ, @GSTtax)
	insert Supplier values (@CDBD, @GSTtax)
	insert Supplier values (@BITManf, @GSTtax)

	--components inserts
	set IDENTITY_INSERT Component on
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30901, 'BMS10', '10mm M6 ms bolt', 1, 0.20, 0.17, 0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30902, 'BMS12', '12mm M6 ms bolt', @ABC, 0.25, 0.2125,	0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30903, 'BMS15', '15mm M6 ms bolt', @ABC, 0.32, 0.2720, 0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30904, 'NMS10', '10mm M6 ms nut', @ABC, 0.05, 0.04, 0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30905, 'NMS12', '12mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30906, 'NMS15', '15mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30911, 'BMS.3.12', '3mm x 12mm flat ms bar', @XYZ, 1.20, 1.15, 	0.75, dbo.getCategoryID('Black Steel'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30912, 'BMS.5.15', '5mm x 15mm flat ms bar', @XYZ, 2.50, 2.45, 	0.75, dbo.getCategoryID('Black Steel'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30913, 'BMS.10.25', '10mm x 25mm flat ms bar', @XYZ, 8.33, 8.27, 0.75, dbo.getCategoryID('Black Steel'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30914, 'BMS.15.40', '15mm x 40mm flat ms bar', @XYZ, 20.00, 19.85, 0.75, dbo.getCategoryID('Black Steel'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30931, '27', 'Anti-rust paint, silver', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30932, '43', 'Anti-rust paint, red', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30933, '154', 'Anti-rust paint, blue', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30921, 'ARTLAB', 'Artisan labour', @BITManf, 42.00, 42.00, 0	, dbo.getCategoryID('Labour'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30922, 'DESLAB', 'Designer labour', @BITManf, 54.00, 54.00, 0, dbo.getCategoryID('Labour'))
	insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (30923, 'APPLAB', 'Apprentice labour', @BITManf, 23.50, 23.50, 0, dbo.getCategoryID('Labour'))
	set IDENTITY_INSERT Component off

--creating supporting fucntion and procedues
	create or alter function getCategoryID(@CategoryName nchar(30))
	returns int 
	as
	begin
	return (
		select CategoryID
		from Category
		where CategoryName = @CategoryName
	)
	end
	go

	create or alter function getAssemblySupplierID()
	returns int
	as 
	begin
	return (
		select ContactID
		from Contact
		where ContactName = 'BIT Manufacturing Ltd.'
	)
	end
	go

	create or alter proc createAssembly(@componenentName nchar(30), @componentDescription nchar(30))
	as
	begin
	insert into Component(ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	values (@componenentName, @componentDescription, dbo.getAssemblySupplierID(), 0, 0, 0, dbo.getCategoryID('Assembly'))
	end
	go

	create or alter proc addSubComponent(@assemblyName nchar(30), @subComponentName nchar(30), @quantity int)
	as
	begin
	insert into AssemblySubComponent
	select a.ComponentID, sc.ComponentID, @quantity
	from Component a cross join Component sc
	where a.ComponentName = @assemblyName and sc.ComponentName = @subComponentName
	end
	go

--running insert proc and functions
	exec createAssembly  'SmallCorner.15', '15mm small corner'
	exec dbo.addSubComponent 'SmallCorner.15', 'BMS.5.15', 0.120
	exec dbo.addSubComponent 'SmallCorner.15', 'APPLAB', 0.33333
	exec dbo.addSubComponent 'SmallCorner.15', '43', 0.0833333
	exec dbo.createAssembly 'SquareStrap.1000.15', '1000mm x 15mm square strap'
	exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS.5.15', 4
	exec dbo.addSubComponent 'SquareStrap.1000.15', 'SmallCorner.15', 4
	exec dbo.addSubComponent 'SquareStrap.1000.15', 'APPLAB', 25
	exec dbo.addSubComponent 'SquareStrap.1000.15', 'ARTLAB', 10
	exec dbo.addSubComponent 'SquareStrap.1000.15', '43', 0.185
	exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS10', 8
	exec dbo.createAssembly 'CornerBrace.15', '15mm corner brace'
	exec dbo.addSubComponent 'CornerBrace.15', 'BMS.5.15', 0.090
	exec dbo.addSubComponent 'CornerBrace.15', 'BMS10', 2

--stored procedues and triggers for quote database
	--procedue that will create customers
	create or alter proc createCustomer(@name nchar(30), @phone nchar(30), @postalAddress nchar(30), @email nchar(30) = null, @customerID int output)
	as
	begin
	insert into Contact (ContactName, ContactPostalAddress, ContactEmail, ContactPhone)
	values (@name, @postalAddress, @email, @phone)
	set @customerID = @@IDENTITY
	insert into Customer
	values (@customerID)
	end 
	go

	--procedues that will create quote
	create or alter proc createQuote (@QuoteDescription nchar(100), @QuoteDate date = null, @QuotePrice money = null, @QuoteCompiler nchar(100), @CustomerID int, @QuoteID int output)
	as 
	begin
	if @QuoteDate is null set @QuoteDate= getdate()
	if @QuotePrice is null set @QuotePrice=0
	insert into Quote (QuoteDescription, QuateDate, QuotePrice, QuoteCompiler, CustomerID)
	values (@QuoteDescription, @QuoteDate, @QuotePrice, @QuoteCompiler, @CustomerID)
	set @QuoteID = @@IDENTITY
	end
	go

	--procedues that will create component for quote
	create or alter proc addQuoteCompnent (@ComponentName nchar(100), @QuoteID int, @Quantity int, @TimeToFit float)
	as
	begin
	insert into QuoteComponent
	select ComponentID, @QuoteID, @Quantity, TradePrice, ListPrice, @TimeToFit
	from Component
	where ComponentName = @ComponentName
	end
	go

	--trigger that is in place of supplier delete
	create or alter trigger trigSupplierDelete
	on Supplier
	instead of delete
	as
	begin

	declare @supplier varchar(25)
	declare @componentCount int
	select @supplier=co.ContactName, @componentCount=count(c.SupplierID)  
	from deleted d join Component c
	on d.SupplierID = c.SupplierID
	join Contact co 
	on co.ContactID = d.SupplierID
	group by c.SupplierID, co.ContactName

	if(EXISTS(
		select c.SupplierID
		from deleted d join Component c
		on d.SupplierID = c.SupplierID
		))
		print 'You cannot delete this supplier! ' + @supplier + ' has ' + cast(@componentCount as nchar) + ' component related'
	else
		delete from Supplier
		where SupplierID = (select SupplierID from deleted)
	end
	go

	--testing trigSupplierDelete trigger
	select * from Supplier
	
	insert into Supplier
	values (5, 1.5)
	
	delete from Supplier
	where SupplierID = 5

	delete from Supplier
	where SupplierID = 1

	--trigger that will update trade prices and list price of quote component 
	create or alter trigger updateAssemblyPrices
	on Component
	after update
	as
	begin
	update QuoteComponent
	set TradePrice = (select TradePrice from inserted), 
	ListPrice = (select ListPrice from inserted)
	where ComponentID = (select ComponentID from inserted)
	end
	go

	--testing updateAssemblyPrices trigger
	select * from Component
	select * from QuoteComponent

	--oiginal price (74.58)
	update Component
	set ListPrice = 80
	where ComponentName = '154'

--creating customer, quote and quote component
	--customer 1
	declare @customerID int
	declare @QuoteID int
	exec createCustomer @name='Bimble & Hat', @phone='444 5555', @postalAddress='123 Digit Street, Dunedin', @email='guy.little@bh.biz.nz', @customerID=@customerID output
	exec createQuote @QuoteDescription='Craypot frame', @QuoteCompiler='Compiler 1',@customerID=@CustomerID, @QuoteID=@QuoteID output
	exec addQuoteCompnent @ComponentName='SquareStrap.1000.15', @QuoteID=@QuoteID, @Quantity=3, @TimeToFit=150
	exec addQuoteCompnent @ComponentName='BMS10', @QuoteID=@QuoteID, @Quantity=24, @TimeToFit=120
	exec addQuoteCompnent @ComponentName='NMS10', @QuoteID=@QuoteID, @Quantity=24, @TimeToFit=120
	exec addQuoteCompnent @ComponentName='154', @QuoteID=@QuoteID, @Quantity=200, @TimeToFit=45
	go 
	
	--customer 2
	declare @customerID int
	declare @QuoteID int
	set @customerID=5
	exec createQuote @QuoteDescription='Craypot stand', @QuoteCompiler='Compiler 2',@customerID=@CustomerID, @QuoteID=@QuoteID output
	exec addQuoteCompnent @ComponentName='BMS.15.40', @QuoteID=@QuoteID, @Quantity=2, @TimeToFit=90
	exec addQuoteCompnent @ComponentName='BMS15', @QuoteID=@QuoteID, @Quantity=4, @TimeToFit=90
	exec addQuoteCompnent @ComponentName='NMS15', @QuoteID=@QuoteID, @Quantity=4, @TimeToFit=90
	exec addQuoteCompnent @ComponentName='154', @QuoteID=@QuoteID, @Quantity=90, @TimeToFit=15
	go 

	--customer 3
	declare @customerID int
	declare @QuoteID int
	exec createCustomer @name='Hyperfont Modulator (International) Ltd.', @phone='(4) 213 4359', @postalAddress='3 Lambton Quay, Wellington', @email='sue@nz.hfm.com', @customerID=@customerID output
	exec createQuote @QuoteDescription='Phasing restitution fulcrum', @QuoteCompiler='Compiler 3',@customerID=@CustomerID, @QuoteID=@QuoteID output
	exec addQuoteCompnent @ComponentName='SquareStrap.1000.15', @QuoteID=@QuoteID, @Quantity=3, @TimeToFit=320
	exec addQuoteCompnent @ComponentName='BMS10', @QuoteID=@QuoteID, @Quantity=24, @TimeToFit=320
	exec addQuoteCompnent @ComponentName='NMS10', @QuoteID=@QuoteID, @Quantity=24, @TimeToFit=320
	exec addQuoteCompnent @ComponentName='154', @QuoteID=@QuoteID, @Quantity=200, @TimeToFit=105
	go 

	select * from Customer
	select * from Quote
	select * from QuoteComponent