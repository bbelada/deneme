

select * 
from Production.Product


select Name, Color, ListPrice
from Production.Product

-- ahsdjagdhg sdvsva  a ad a das da sdas d
-- agdýads


/* buraya yorum yazilir
asdasdasdsad
asdasdasd
asdasd
*/

-- fiyati 0 olan urunler gelsin
select Name, Color, ListPrice
from Production.Product
where ListPrice = 0

-- fiyati 0 dan farkli olan urunler
select Name, Color, ListPrice
from Production.Product
where ListPrice != 0

select Name, Color, ListPrice
from Production.Product
where ListPrice <> 0

-- fiyati 1000 ila 2000 arasinda olan urunler
select Name, Color, ListPrice
from Production.Product
where ListPrice between 1000 and 2000

select Name, Color, ListPrice
from Production.Product
where ListPrice >= 1000 and ListPrice <= 2000

-- Rengi Siyah olan urunler gelsin
select Name, Color, ListPrice
from Production.Product
where Color = 'Black'

-- Rengi Siyah ya da Kýrmýzý olup fiyati 1000 den buyuk olan urunler
select Name, Color, ListPrice
from Production.Product
where (Color = 'Black' or Color = 'Red') and ListPrice > 1000


-- Rengi Siyah ya da Kirmizi ya da Mavi ya da Sari olan urunler
select Name, Color, ListPrice
from Production.Product
where Color IN ('Black', 'Red', 'Blue', 'Yellow')

-- Rengi Siyah ya da Kirmizi ya da Mavi ya da Sari olmayan urunler
select Name, Color, ListPrice
from Production.Product
where Color NOT IN ('Black', 'Red', 'Blue', 'Yellow') or Color is null


-- sadece 2002 yilinda verilen siparisler gelsin
select *
from Sales.SalesOrderHeader
where YEAR(OrderDate) = 2012

-- 2. yontem
select *
from Sales.SalesOrderHeader
where OrderDate between '2012-01-01' and '2013-01-01'

-- 3. yontem
select *
from Sales.SalesOrderHeader
where OrderDate >= '2012-01-01' and OrderDate < '2013-01-01'

/* LIKE
-------------
%	--> 0 veya daha fazla karakteri temsil eder
_	--> Sadece tek 1 adet kerekteri temsil eder

*/

-- Soyadi K ile baslayan kisiler gelsin
select *
from Person.Person
where LastName like 'K%'

-- Soyadi K ile biten kisiler
select *
from Person.Person
where LastName like '%K'


select *
from Person.Person
where LastName like '%K%'


-- Soyadinin sondan 3. harfi K olan kisiler
select *
from Person.Person
where LastName like '%K__'

-- 678-555-0175 formatinda olan telefolar gelsin
select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'

select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'

select *
from Person.PersonPhone
where PhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'


-- kac farkli renk mevcut
select distinct Color
from Production.Product

select distinct Color, Size
from Production.Product

-- fiyati 0-1000 --> Ucuz, 1000-2000 --> Orta, fiyati 2000 den buyukse --> Pahalý
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then N'Pahalý'
		 else N'Diðer'
	end as Segment
from Production.Product

-- Black-->Siyah, Red-->Kýrmýzý, Yellow-->Sarý olarak gelsin
select Name, Color, ListPrice,
	case when Color = 'Black' then 'Siyah'
		 when Color = 'Red' then N'Kýrmýzý'
		 when Color = 'Yellow' then N'Sarý'
		 else N'Diðer'
	end as Renk
from Production.Product

-- urunleri fiyata gore kucukten buyuge dogru sirali getirelim
select Name, Color, ListPrice
from Production.Product
order by ListPrice asc

select Name, Color, ListPrice
from Production.Product
order by ListPrice desc


select Name, Color, ListPrice
from Production.Product
order by ListPrice asc, Name asc

-- fiyati en pahali olan ilk 10 urun gelsin
select top 10 Name, Color, ListPrice
from Production.Product
order by ListPrice desc

select top 10 percent Name, Color, ListPrice
from Production.Product
order by ListPrice desc

select top 3 with ties Name, Color, ListPrice
from Production.Product
order by ListPrice desc

/* SORGU KOMUTLARININ YAZILMA VE CALISTIRILMA SIRASI
---------------------------------------------------------
			Calistirilma Sirasi
SELECT ...........(5)
FROM .............(1)
WHERE ............(2)
GROUP BY .........(3)
HAVING ...........(4)
ORDER BY .........(6)

*/

select Name as "Ürün Adý", Color as Renk, ListPrice as [Liste Fiyatý]
from Production.Product
where Color = 'Black'
order by [Liste Fiyatý] desc

/* AGGREGATE FUNCTIONS
------------------------------
SUM()	--> Dogru
MIN()	--> Dogru
MAX()	-->	Dogru
------------------
COUNT()	--> NULL hesaplamaya dahil edilmez!!!
AVG()	--> NULL hesaplamaya dahil edilmez!!!

*/

select SUM(ProductSubcategoryID) as toplam,
	   MIN(ProductSubcategoryID) as minimum,
	   MAX(ProductSubcategoryID) as maksimum,
	   COUNT(ProductSubcategoryID) as adet,
	   AVG(ProductSubcategoryID) as ortalama,
	   COUNT(*) as adet2,
	   AVG(ISNULL(ProductSubcategoryID, 0)) as ortalama2
from Production.Product

-- hangi renkten kac adet urun var
select Color, COUNT(*) as adet
from Production.Product
group by Color

-- her bir rengin en pahalý, en ucuz ve ortalama fiyatlarý gelsin
select Color, MAX(ListPrice) as EnPahali, MIN(ListPrice) as EnUcuz, AVG(ListPrice) as OratalamaFiyat
from Production.Product
group by Color

-- hangi yilda toplam ne kadar ciro elde edildi
select YEAR(OrderDate) as Yil, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by Yil asc

-- hangi yilin hangi ayinda toplam ne kadar ciro elde dildi
select YEAR(OrderDate) as Yil, MONTH(OrderDate) as Ay, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate), MONTH(OrderDate)
order by Yil asc, Ay asc

-- 5 milyon TL den daha fazla ciro yapilan aylar gelsin
select YEAR(OrderDate) as Yil, MONTH(OrderDate) as Ay, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate), MONTH(OrderDate)
having SUM(SubTotal) >= 5000000
order by Yil asc, Ay asc

-- en az 30 adet urunu olan renkler gelsin
select Color, COUNT(*) as adet
from Production.Product
group by Color
having COUNT(*) >= 30

/* JOINS
----------------
1- INNER JOIN
2- OUTER JOIN
	- LEFT JOIN
	- RIGHT JOIN
	- FULL JOIN
3- CROSS JOIN

*/

-- Siparislerin tarihi, tutari ve bolgeadi gelsin
select * from Sales.SalesOrderHeader
select * from Sales.SalesTerritory

select soh.OrderDate, soh.SubTotal, st.Name
from Sales.SalesOrderHeader as soh inner join Sales.SalesTerritory as st
on soh.TerritoryID = st.TerritoryID

-- Urunlerin Urunadi, Rengi, Fiyati ve Modeladi gelsin
select * from Production.Product		-- 504 rows
select * from Production.ProductModel	-- 128 rows


-- INNER JOIN -- 295 rows
select p.Name as ÜrünAdi, p.Color as Renk, p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.Product as p inner join Production.ProductModel as pm
on p.ProductModelID = pm.ProductModelID


-- LEFT JOIN -- 504 rows
select p.Name as ÜrünAdi, p.Color as Renk, p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.Product as p left join Production.ProductModel as pm
on p.ProductModelID = pm.ProductModelID

-- RIGHT JOIN -- 304 rows
select p.Name as ÜrünAdi, p.Color as Renk, p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.Product as p right join Production.ProductModel as pm
on p.ProductModelID = pm.ProductModelID

-- FULL JOIN -- 513 rows
select p.Name as ÜrünAdi, p.Color as Renk, p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.Product as p full join Production.ProductModel as pm
on p.ProductModelID = pm.ProductModelID

-- CROSS JOIN -- 64512 rows
select p.Name as ÜrünAdi, p.Color as Renk, p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.Product as p cross join Production.ProductModel as pm

-- KategoriAdi, AltkategoriAdi, UrunAdi, Rengi, Fiyatý ve ModelAdi gelsin
select * from Production.ProductCategory
select * from Production.ProductSubcategory
select * from Production.Product
select * from Production.ProductModel

select pc.Name as KategorAdi, psc.Name as AltkategoriAdi, p.Name as ÜrünAdi, p.Color as Renk, 
		p.ListPrice as Fiyat, pm.Name as ModelAdi
from Production.ProductCategory as pc inner join Production.ProductSubcategory as psc
on pc.ProductCategoryID = psc.ProductCategoryID
inner join Production.Product as p
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Production.ProductModel as pm
on p.ProductModelID = pm.ProductModelID



SELECT  pc.Name AS [Kategori Adý], psc.Name AS [Altkategori Adý], p.Name AS [Ürün Adý], p.Color AS Renk, p.ListPrice AS Fiyat, pm.Name AS [Model Adý]
FROM      Production.Product AS p INNER JOIN
                   Production.ProductModel AS pm ON p.ProductModelID = pm.ProductModelID INNER JOIN
                   Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID INNER JOIN
                   Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE   (p.Color = N'Black') OR
                   (p.Color = N'Red')
ORDER BY [Kategori Adý], Fiyat DESC

/* SUBQUERY
--------------------
SELECT ........
FROM ..........
WHERE kolonadi =     IN 
	(
	SELECT kolonadi
	FROM .......
	......
	......
	)
....
....

*/

-- Fiyati en pahali olan urunun rengindeki butun urunler gelsin
select top 1 Color
from Production.Product
order by ListPrice desc

select *
from Production.Product
where Color = 
	(
	select top 1 Color
	from Production.Product
	order by ListPrice desc
	)

-- En son siparis verilen tarihteki butun siparisler gelsin
select MAX(OrderDate)
from Sales.SalesOrderHeader


select *
from Sales.SalesOrderHeader
where OrderDate = 
	(
	select MAX(OrderDate)
	from Sales.SalesOrderHeader
	)

-- Fiyati ortalama fiyattan daha yuksek olan urunler gelsin
select AVG(ListPrice)
from Production.Product


select *
from Production.Product
where ListPrice > 
	(
	select AVG(ListPrice)
	from Production.Product
	)

-- hic siparis vermemis musteriler
select *
from Sales.Customer
where CustomerID NOT IN
	(
	select CustomerID
	from Sales.SalesOrderHeader
	)


-- 2. yontem
select c.*
from Sales.Customer as c left join Sales.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID
where soh.SalesOrderID is null

/* SET OPERATORS
------------------
1- UNION ALL
2- UNION
3- INTERSECT
4- EXCEPT (MINUS)

*/

select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'
EXCEPT
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'


select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'
INTERSECT
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'


select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'
UNION ALL
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'


select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'
UNION
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'







