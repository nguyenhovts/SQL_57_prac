﻿---Q1: Which shippers do we have?
select *
from dbo.Shippers

---Q2: Certain fields from Categories
select CategoryName, Description
from dbo.Categories

---Q3: Sales Representatives
select 
	FirstName, 
	LastName, 
	HireDate
from dbo.Employees
where Title = 'Sales Representative'

--Q4: -Sales Representatives in the United States
select 
	FirstName, 
	LastName, 
	HireDate
from dbo.Employees
where Title = 'Sales Representative' and Country = 'USA'

---Q5: Orders placed by specific EmployeeID
select 
	OrderID,
	OrderDate
from dbo.Orders
where EmployeeID = 5

---Q6: Suppliers and ContactTitles
select 
	SupplierID,
	ContactName, 
	ContactTitle 
from dbo.Suppliers
where ContactTitle <> 'Marketing Manager'

---Q7: Products with queso in ProductName
select 
	ProductID,
	ProductName
from dbo.Products
where ProductName like '%queso%'

---Q8: Orders shipping to France or Belgium
select 
	OrderID,
	CustomerID,
	ShipCountry
from dbo.Orders
where ShipCountry in ('France', 'Belgium')

---Q9: Orders shipping to any country in Latin America
select 
	OrderID,
	CustomerID,
	OrderDate,
	ShipCountry
from dbo.Orders
where ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

---Q10:  Employees, in order of age
select 
	FirstName, 
	LastName, 
	Title,
	BirthDate
from dbo.Employees
order by BirthDate

---Q11: Showing only the Date with a DateTime field
select 
	FirstName, 
	LastName, 
	Title,
	convert(date, Birthdate) as birth_date
from dbo.Employees
order by BirthDate

---Q12: Employees full name
select
	FirstName,
	LastName,
	concat(FirstName, ' ', LastName) as FullName
from dbo.Employees

---Q13: OrderDetails amount per line item
select
	 OrderID, 
	 ProductID, 
	 UnitPrice,
	 Quantity,
	 UnitPrice * Quantity as TotalPrice
from dbo.[Order Details]
order by 1,2

---Q14: How many customers?
select count(*) as TotalCustomers
from dbo.Customers

---Q15: When was the first order?
select min(OrderDate) as FirstOrder
from dbo.Orders

---Q16: Countries where there are customers
select Country
from dbo.Customers
group by Country
having count(*) > 0 

---Q17: Contact titles for customers
select 
	ContactTitle,
	count(ContactTitle) as TotalContactTitle
from dbo.Customers
group by ContactTitle
order by 2 desc

---Q18: Products with associated supplier names
select
	p.ProductID, 
	p.ProductName,
	s.CompanyName
from Products p
	join Suppliers s
		on p.SupplierID = s.SupplierID
order by 1

---Q19: Orders and the Shipper that was used
select
	o.OrderID, 
	convert(date, o.OrderDate) as OrderDate,
	s.CompanyName as Shipper
from dbo.Orders o
	join dbo.Shippers s
		on o.ShipVia = s.ShipperID
where OrderID <= 10300
order by OrderID

---Q20: Categories, and the total products in each category
select 
	c.CategoryName,
	count(p.ProductID) as TotalProducts
from dbo.Categories c
	join dbo.Products p
		on c.CategoryID = p.CategoryID
group by CategoryName
order by 2 desc

---Q21: Total customers per country/city
select 
	count(*) as TotalCustomers,
	City,
	Country
from dbo.Customers
group by City, Country
order by TotalCustomers desc

---Q22: Products that need reordering
select 
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel
from dbo.Products
where UnitsInStock < ReorderLevel
order by ProductID

---Q23:Products that need reordering, continued
select 
	ProductID,
	ProductName,
	UnitsInStock,
	UnitsOnOrder,
	ReorderLevel,
	Discontinued
from dbo.Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel
and Discontinued = 0
order by ProductID

---Q24: Customer list by region

select 
	CustomerID,
	CompanyName,
	Region
from dbo.Customers
order by 
	Case
		when Region is null then 1
		else 0
	End,
	Region,
	CustomerID

---Q25: 3 Highest freight charges
select top 3
	ShipCountry,
	avg(freight) as AverageFreight
from dbo.Orders
group by ShipCountry
order by AverageFreight desc

---Q26: High freight charges - 2015
select top 3
	ShipCountry,
	avg(freight) as AverageFreight
from dbo.Orders
where 
	year(OrderDate) = '1997'
group by ShipCountry
order by AverageFreight desc

---Q27: High freight charges with between
--RUN THE CODE AND FIND THE ERROR
Select Top 3
	ShipCountry
	,AverageFreight = avg(freight)
From Orders
Where
	OrderDate between '1/1/1997' and '12/31/1997'
Group By ShipCountry
Order By AverageFreight desc;

---Q28: 28. High freight charges - last year
select 
	ShipCountry,
	avg(freight) as AverageFreight
from dbo.Orders
where OrderDate >= dateadd(yy, -1, (select max(OrderDate) from dbo.Orders))
group by ShipCountry
order by AverageFreight desc
	
---Q29: Inventory list
select 
	e.EmployeeID, 
	e.LastName, 
	o.OrderID,
	p.ProductName,
	od.Quantity
from dbo.Employees e
	join dbo.Orders o
		on e.EmployeeID = o.EmployeeID
	join dbo.[Order Details] od
		on od.OrderID = o.OrderID
	join dbo.Products p
		on p.ProductID = od.ProductID
order by OrderID, p.ProductID

---Q30: Customers with no orders
select
	c.CustomerID as Customers_CustomerID,
	o.CustomerID as Orders_CustomerID
from dbo.Customers c
	left join dbo.Orders o
		on c.CustomerID = o.CustomerID
where OrderID is null

---Q31: Customers with no orders for EmployeeID 4
select
	c.CustomerID as Customers_CustomerID,
	o.CustomerID as Orders_CustomerID
from dbo.Customers c
	left join dbo.Orders o
		on c.CustomerID = o.CustomerID
		and o.EmployeeID = 4
where OrderID is null 

---Q32: High-value customers
select 
	c.CustomerID,
	c.CompanyName,
	od.OrderID,
	sum(od.UnitPrice * od.Quantity) as TotalOrderAmount
from dbo.Customers c
	join dbo.Orders o
		on c.CustomerID = o.CustomerID
	join dbo.[Order Details] od
		on od.OrderID = o.OrderID
where year(o.OrderDate) = '1997'
group by c.CustomerID, c.CompanyName, od.OrderID
having sum(od.UnitPrice * od.Quantity) >= 10000  
order by TotalOrderAmount desc

---Q33: High-value customers - total orders
select 
	c.CustomerID,	c.CompanyName,	sum(od.UnitPrice * od.Quantity) as TotalOrderAmountfrom dbo.Customers c
	join dbo.Orders o
		on c.CustomerID = o.CustomerID
	join dbo.[Order Details] od
		on od.OrderID = o.OrderID
where year(o.OrderDate) = '1997'
group by c.CustomerID, c.CompanyName
having sum(od.UnitPrice * od.Quantity) >= 15000  
order by TotalOrderAmount desc

---Q34: High-value customers - with discount
select 
	c.CustomerID,
	c.CompanyName,
	sum(od.UnitPrice * od.Quantity) as TotalsWithoutDiscount,
	sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as TotalsWithDiscountfrom dbo.Customers c
	join dbo.Orders o
		on c.CustomerID = o.CustomerID
	join dbo.[Order Details] od
		on od.OrderID = o.OrderID
---where year(o.OrderDate) = '2016'
group by c.CustomerID, c.CompanyName
having sum(od.UnitPrice * od.Quantity) >= 15000  
order by TotalsWithDiscount desc

---Q35: Month-end orders
select
	EmployeeID,
	OrderID,
	OrderDate
from dbo.Orders
where OrderDate = eomonth(OrderDate)
order by 1,2

---Q36: Orders with many line items
select top 10
	o.OrderID,
	count(*) as TotalOrderDetails
from dbo.Orders o
	join dbo.[Order Details] od
		on o.OrderID = od.OrderID
group by o.OrderID
order by TotalOrderDetails desc

---Q37: Orders - random assortment
select top 2 percent
	OrderID
from Orders
order by rand()

---Q38: Orders - accidental double-entry
select
	OrderID
from [Order Details]
where Quantity >= 60
group by OrderID, Quantity
having count(*) > 1 

---Q39. Orders - accidental double-entry details

With 
	double_entry as	(select
		OrderID
	from [Order Details]
	where Quantity >= 60
	group by OrderID, Quantity
	having count(*) > 1)select 	OrderID,	ProductID,	UnitPrice,	Quantity,	Discountfrom [Order Details]where OrderID in (select OrderID from double_entry)order by OrderID---Q40: Orders - accidental double-entry details, derived tableselect 	od.OrderID,	od.ProductID,	od.UnitPrice,	od.Quantity,	od.Discountfrom [Order Details] od	join(select
			OrderID
		from [Order Details]
		where Quantity >= 60
		group by OrderID, Quantity
		having count(*) > 1) as double_entry
	on double_entry.OrderID = od.OrderID
order by OrderID

---Q41:1. Late ordersselect	OrderID,	OrderDate,	RequiredDate,	ShippedDatefrom Orderswhere ShippedDate > RequiredDate 