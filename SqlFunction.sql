USE LibrarySQL
 
--1--
CREATE FUNCTION MyFunction1(@PressName NVARCHAR(30))
RETURNS TABLE
AS
  RETURN SELECT Books.Name as BookName
         FROM Books
         JOIN Press ON Id_Press=Press.Id
         WHERE Press.Name=@PressName
         GROUP BY Books.Name,Books.Pages
         HAVING Pages=(SELECT MIN(BookPage) 
                       FROM(SELECT Pages AS BookPage
                            FROM Books
                            JOIN Press ON Id_Press=Press.Id
                            WHERE Press.Name=@PressName
                            GROUP BY  Books.Name,Books.Pages) AS MinPage)

 --for to check--
SELECT * FROM dbo.MyFunction1('BHV')

--2--

ALTER FUNCTION MyFunction2(@Number INT)
RETURNS TABLE
AS
   RETURN  SELECT Press.Name as PressName
           FROM Books
           JOIN Press ON Id_Press=Press.Id
           GROUP BY Press.Name
		   HAVING AVG(Books.Pages)>@Number

--for to check--

SELECT * FROM dbo.MyFunction2(400)

--3--

ALTER FUNCTION MyFunction3(@PressName NVARCHAR(40))
RETURNS TABLE
AS 
   RETURN SELECT SUM(Books.Pages) AS TotalPageCount
          FROM Books
          JOIN Press ON Id_Press=Press.Id
          WHERE Press.Name=@PressName                 
 
		  --for to check--

SELECT * FROM dbo.MyFunction3('Кудиц-Образ')

--4--

CREATE FUNCTION MyFunction4(@date1 DATETIME,@date2 DATETIME)
RETURNS TABLE
AS
  RETURN SELECT Students.FirstName,Students.LastName
         FROM S_Cards
         JOIN Students ON S_Cards.Id_Student=Students.Id
         WHERE DateOut between @date1  and @date2


		 	  --for to check--

SELECT * FROM dbo.MyFunction4('2000-05-18','2001-05-02')

--5--
CREATE FUNCTION MyFunction5()
RETURNS TABLE
AS
   RETURN
   SELECT CONCAT(Students.FirstName,' ',Students.LastName) AS StudentFullName,Books.Name AS BookName,CONCAT(Authors.FirstName,' ',Authors.LastName) AS AutorFullName
   FROM S_Cards
   JOIN Students ON S_Cards.Id_Student=Students.Id
   JOIN Books ON S_Cards.Id_Book=Books.Id
   JOIN Authors ON Books.Id_Author=Authors.Id
     
	  --for to check--

SELECT * FROM dbo.MyFunction5()

 --6--
 
CREATE FUNCTION MyFunction6()
RETURNS TABLE
AS 
    RETURN SELECT Press.Name as PressName,Press.Id
           FROM Books
           JOIN Press ON Books.Id_Press=Press.Id
           WHERE Books.Pages=(select max(pages) from Books)
  

   --for to check--
   SELECT * FROM dbo.MyFunction6()

   --7--
CREATE FUNCTION MyFunction7()
RETURNS TABLE
AS 
   RETURN SELECT CONCAT(Authors.FirstName,' ',Authors.LastName) AS AutorFullName
          FROM Books
          JOIN Authors ON Books.Id_Author=Authors.Id
          WHERE Quantity=(SELECT MIN(Quantity) FROM Books)
          GROUP BY Authors.FirstName,Authors.LastName


SELECT * FROM dbo.MyFunction7()

--8--

CREATE FUNCTION MyFunction8()
RETURNS TABLE
AS 
 RETURN
     SELECT CONCAT(Students.FirstName,' ',Students.LastName) AS Membres,Books.Name as BookName 
     FROM  S_Cards 
     JOIN Students ON S_Cards.Id_Student=Students.Id
     JOIN Books ON S_Cards.Id_Book=Books.Id
     UNION
     SELECT CONCAT(Teachers.FirstName,' ',Teachers.LastName) AS Membres ,Books.Name as BookName 
     FROM  T_Cards
     JOIN Teachers ON T_Cards.Id_Teacher=Teachers.Id
     JOIN Books ON T_Cards.Id_Book=Books.Id

	 --for to check--
SELECT * FROM dbo.MyFunction8()


--9--

ALTER FUNCTION StudentCount()
RETURNS TABLE
AS 
    RETURN 
        SELECT (SELECT COUNT(Students.Id) FROM Students) - 
		(SELECT COUNT(Students.Id) FROM S_Cards JOIN Students ON S_Cards.Id_Student=Students.Id) AS NotTakeBookStudentCount
		
--for to check--
SELECT* FROM dbo.StudentCount()		
        
     
     
	  



	
	  