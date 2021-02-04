
-- alt+x �al��t�r�r
-- 0 olanlar
select Name, Color, ListPrice
from Production.Product
where ListPrice=0

-- 0dan farkl� olanlar
select Name, Color, ListPrice
from Production.Product
where ListPrice != 0  -- != ya da <>

-- 1000 2000 aras�
select Name, Color, ListPrice
from Production.Product
where ListPrice between 1000 and 2000 --ba�lang�� ve biti� dahil edilir
-- ya da
select Name, Color, ListPrice
from Production.Product
where ListPrice >= 1000 and ListPrice <= 2000


--rengi black olanlar
select Name, Color, ListPrice
from Production.Product
where Color = 'black'

-- rengi siyah ya da k�rm�z� olup 1000 tl �st� olan
select Name, Color, ListPrice
from Production.Product
where (Color = 'black' or Color= 'red') and ListPrice >1000

-- Rengi Siyah ya da Kirmizi ya da Mavi ya da Sari olan urunler
select Name, Color, ListPrice
from Production.Product
where Color in ('black', 'red', 'blue', 'yellow')

-- Rengi Siyah ya da Kirmizi ya da Mavi ya da Sari olmayan urunler
select Name, Color, ListPrice
from Production.Product
where Color not in ('black', 'red', 'blue', 'yellow')  -- Null olanlar� dahil etmiyo
-- nullar� da getirmek i�in
select Name, Color, ListPrice
from Production.Product
where Color not in ('black', 'red', 'blue', 'yellow') or Color is null


-- ��leden sonra

-- sadece 2002 y�l�ndaki sipari�ler gelsin
select *
from Sales.SalesOrderHeader
where YEAR (OrderDate) = 2002

--2.y�ntem (tarihlerde kullanma)
select *
from Sales.SalesOrderHeader
where OrderDate between '2002-01-01' and '2003-01-01' -- '2003-01-01' 00.00 da dahil oluyo b�yle

--3.y�ntem (best practice)
select *
from Sales.SalesOrderHeader
where OrderDate >= '2002-01-01' and OrderDate < '2003-01-01'


-- LIKE

-- Soyadi K ile baslayan kisiler gelsin
select * 
from Person.Contact
where LastName like 'k%'

-- Soyadi K ile biten kisiler gelsin
select * 
from Person.Contact
where LastName like '%k'

-- Soyadinda K ge�en kisiler gelsin
select * 
from Person.Contact
where LastName like '%k%'


-- Soyadinin sondan 3. harfi K olan kisiler
select * 
from Person.Contact
where LastName like '%k__'

-- 678-555-0175 formatinda olan telefolar gelsin
select * 
from Person.Contact
where Phone like '___-___-____'

--yukardakinin sadece rakam olan�
select *
from Person.Contact
where Phone like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'



-- i�inde 2 tane tire olanlar
select *
from Person.Contact
where Phone like '%-%-%'


--distinct
--


-- fiyati 0-1000 --> Ucuz, 1000-2000 --> Orta, fiyati 2000 den buyukse --> Pahal�
select Name, Color, ListPrice,
case when ListPrice between 0 and 1000 then 'Ucuz'
when ListPrice between 1000 and 2000 then 'Orta'
when ListPrice > 2000 then N'Pahal�' -- N konyunca ba��na t�rke karakterleri de al�yo
else N'Di�er'
end as Segment
from Production.Product

-- Black-->Siyah, Red-->K�rm�z�, Yellow-->Sar� olarak gelsin
select Name, Color, ListPrice,
case when Color = 'Black' then 'Siyah'
when Color = 'Red' then N'K�rm�z�'
when Color = 'Yellow' then N'Sar�'
else N'Di�er'
end as Renk
from Production.Product


--ORDER BY (zor �al���r yorar pcyi)

select Name, Color, ListPrice
from Production.Product
order by ListPrice asc --default asc 

select Name, Color, ListPrice
from Production.Product
order by ListPrice desc


select Name, Color, ListPrice
from Production.Product
order by ListPrice asc, Name asc


-- fiyati en pahali olan ilk 10 urun gelsin
select top 10 Name, Color, ListPrice -- 10 sat�r demek, 10 percent dersek en pahal� %10 gelir
from Production.Product
order by ListPrice desc 

select top 3 with ties Name, Color, ListPrice -- fiyat� ayn� olup haks�zl��a u�rayanlar� da al�yo
from Production.Product
order by ListPrice desc

/* 
SELECT ...........(5)
FROM .............(1)
WHERE ............(2)
GROUP BY .........(3)
HAVING ...........(4)
ORDER BY .........(6)
*/

select Name as "�r�n Ad�", Color as Renk, ListPrice as [Liste Fiyat�]
from Production.Product
where Color = 'Black'
order by [Liste Fiyat�] desc --(s�ralamadan dolay� select'te de�i�tirdi�imiz column isimlerini ancak order by'da kullanabiliyoruz)



---------------------2.g�n----------------------------------------------------------------


select sum (ProductSubcategoryID) as toplam,
	   min (ProductSubcategoryID) as minimum,
	   max (ProductSubcategoryID) as maximum,
	   count (ProductSubcategoryID) as adet, --nulllar say�lmaz 
	   avg (ProductSubcategoryID) as ortalama, --"nulllar say�lmaz
	   count (*) as adet2,
	   avg (isnull(ProductSubcategoryID,0)) as ortalama
from Production.Product

-- GROUP BY
--hangi renkten ka� adet var
select Color, count (*) as adet
from Production.Product
group by Color

--her rengin en pahal�, en ucuz ve ortalama fiyatlar�
select Color, min(ListPrice) as minimum, MAX(ListPrice) as maximum, AVG(ListPrice) as ortalama
from Production.Product
group by Color


--hangi y�lda toplam ne kadar ciro
select YEAR(OrderDate) as tarih, SUM(SubTotal) as ciro
from Sales.SalesOrderHeader
group by year(OrderDate)
order by tarih

--hangi y�l�n hangi ay�nda toplam ne kadar ciro
select YEAR(OrderDate) as tarih, MONTH (OrderDate) as ay, SUM(SubTotal) as ciro
from Sales.SalesOrderHeader
group by year(OrderDate), MONTH (OrderDate)
order by tarih, ay

-- 5 milyon tl ve daha fazla ciro yap�lan aylar
select YEAR(OrderDate) as tarih, MONTH (OrderDate) as ay, SUM(SubTotal) as ciro
from Sales.SalesOrderHeader
group by year(OrderDate), MONTH (OrderDate)
having sum(SubTotal) >= 5000000
order by tarih, ay

-- en az 30 adet �r�n� olan renkler gelsin
select Color, count (*) as adet
from Production.Product
group by Color
having COUNT(*) >= 30
-------------------------------------------------------
/* JOINS
-----------
1- INNER JOIN
2- OUTER JOIN
	A- LEFT JOIN
	B- RIGHT JOIN
	C- FULL JOIN
3- CROSS JOIN

*/


-- Sipari�lerin tarihi, tutar�, b�lge ad� gelsin
select soh.OrderDate, soh.SubTotal, st.Name
from Sales.SalesOrderHeader as soh inner join Sales.SalesTerritory as st
on soh.TerritoryID = st.TerritoryID


-- �r�nlerin �r�nad�, rengi, fiyat� ve modelad� gelsin

--INNER JOIN -- 295 rows
select pp.Name, pp.Color, pp.ListPrice, ppm.Name
from Production.Product as pp inner join Production.ProductModel as ppm
on pp.ProductModelID = ppm.ProductModelID

--LEFT JOIN -- 504 rows
select pp.Name, pp.Color, pp.ListPrice, ppm.Name
from Production.Product as pp left join Production.ProductModel as ppm
on pp.ProductModelID = ppm.ProductModelID

--RIGHT JOIN -- 304 rows
select pp.Name, pp.Color, pp.ListPrice, ppm.Name
from Production.Product as pp right join Production.ProductModel as ppm
on pp.ProductModelID = ppm.ProductModelID

--FULL JOIN -- 513 rows
select pp.Name, pp.Color, pp.ListPrice, ppm.Name
from Production.Product as pp full join Production.ProductModel as ppm
on pp.ProductModelID = ppm.ProductModelID

--CROSS JOIN -- 64512 rows
select pp.Name, pp.Color, pp.ListPrice, ppm.Name
from Production.Product as pp cross join Production.ProductModel as ppm

----------------------------------------
-- ��leden sonra

--kategoriadi, altkategoriadi, urunadi, rengi, fiyat� ve madeladi gelsin

select * from Production.ProductCategory
select * from Production.ProductSubcategory
select * from Production.Product
select * from Production.ProductModel

select ppc.Name as kategoriadi, ppsc.Name as altkategoriadi, pp.Name as urunadi, pp.Color as renk, pp.ListPrice as fiyat, ppm.Name as modeladi
from Production.ProductCategory as ppc inner join Production.ProductSubcategory as ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product as pp
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join Production.ProductModel as ppm
on ppm.ProductModelID = pp.ProductModelID


-- sa� t�klay�p query editorden yap�ld�
SELECT ppc.Name AS Kategoriadi, ppsc.Name AS altkategoriadi, pp.Name AS urunadi, pp.Color AS renk, pp.ListPrice AS fiyat, ppm.Name AS modeladi
FROM     Production.Product AS pp INNER JOIN
                  Production.ProductModel AS ppm ON pp.ProductModelID = ppm.ProductModelID INNER JOIN
                  Production.ProductSubcategory AS ppsc ON pp.ProductSubcategoryID = ppsc.ProductSubcategoryID INNER JOIN
                  Production.ProductCategory AS ppc ON ppsc.ProductCategoryID = ppc.ProductCategoryID


-- 
---------------------
/* SUBQUERY
------------------
SELECT........
FROM..........
WHERE kolonadi = 
	(
	SELECT kolonadi
	FROM......
	.....
	.....
	)
......
.......
*/

-- fiyat� en pahal� olan urunun rengindeki butun urunlar gelsin
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
----------
--en son sipari� verilen tarihteki b�t�n sipari�ler gelsin
select *
from Sales.SalesOrderHeader
where OrderDate = 
	(
	select top 1 OrderDate
	from Sales.SalesOrderHeader
	order by OrderDate desc
	)
-- hocan�n yapt���
select *
from Sales.SalesOrderHeader
where OrderDate = 
	(
	select MAX(OrderDate)
	from Sales.SalesOrderHeader
	)
-----------------------------------
-- fiyat� ortalama fiyattan daha y�ksek olan �r�nler
select *
from Production.Product
where ListPrice > 
	(
	select AVG(ListPrice)
	from Production.Product
	)


-------- burda bi �eyle yapt� takip edemedim------



-------------------------------------------------

/* SET OPERATORS
---------------------
1- UNION ALL
2- UNION
3- INTERSECT
4- EXCEPT (MINUS)

*/

