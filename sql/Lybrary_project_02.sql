CREATE DATABASE Lybrary_project_02;

USE  Lybrary_project_02;


# ---------------------------------------------------------------------Create Table--------------------------------------------------------------------
drop table  if exists books;
Create table books(
isbn	varchar(25) primary key,
book_title	varchar(75),
category	varchar(20),
rental_price	float,
status	varchar(20),
author	varchar(30),
publisher varchar(30)
);

drop table if exists branch;
Create table branch(
branch_id	varchar(15) primary key,
manager_id	varchar(15),                   #fk
branch_address	varchar(255),
contact_no varchar(20)
);

drop table if exists employees;
Create table employees(
emp_id	varchar(15) primary key,
emp_name	varchar(35),
position	varchar(15),
salary	 int(20),
branch_id  varchar(15)            #fk
);


drop table if exists issued_status;
Create table issued_status(
issued_id	varchar(20) primary key,
issued_member_id	varchar(20),       #fk
issued_book_name	varchar(70),
issued_date	date,
issued_book_isbn	varchar(25),       # fk
issued_emp_id varchar(10)              # fk
);

drop table if exists members;
Create table members(
member_id varchar(20) primary key,
member_name	varchar(20),
member_address	varchar(55),
reg_date date
);

drop table if exists return_status;
Create table return_status(
return_id	varchar(10) primary key,
issued_id	varchar(20),                # fk
return_book_name	varchar(20),
return_date	date,
return_book_isbn varchar(25)      
);


#----------------------------------------------------------------Forgien key---------------------------------------------------------------------

Alter Table issued_status
Add constraint fk_members
Foreign key (issued_member_id)
References members(member_id);

Alter Table issued_status
Add Constraint fk_books
Foreign key (issued_book_isbn)
References books(isbn);

Alter Table issued_status
Add Constraint fk_employees
Foreign key (issued_emp_id)
References employees(emp_id);

Alter Table return_status
Add constraint fk_issued_status
Foreign key(issued_id)
References issued_status(issued_id);

Alter Table employees
Add Constraint fk_branch
Foreign key (branch_id)
References branch(branch_id);



#---------------------------------------------------------data Exploration--------------------------------------------------------
select * from books;
select * from employees;
select * from branch;
select * from issued_status;
select * from members;
select * from return_status;




#-----------------------------------------------------------------Project Task--------------------------------------------------------------------------------

-- Project TASK


-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

-- Task 2: Update an Existing Member's Address


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.


-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt


-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:


-- Task 8: Find Total Rental Income by Category:


-- Task 9. **List Members Who Registered in the Last 180 Days**:

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold

-- Task 12: Retrieve the List of Books Not Yet Returned

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.



#-----------------------------------------------------------------------Project Analysis------------------------------------------------------------------------------

----------------- 1. CRUD Operations-------------------


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')")"

Insert Into books(isbn,book_title,category,rental_price,status,author,publisher)
values( 
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

select* from books;

-- Task 2: Update an Existing Member's Address



Update members
set member_name = "Alice john"
where member_id = "C102";

select * from members;


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS107' from the issued_status table.

delete from issued_status
where issued_id = "IS107";
select * from issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_book_name, issued_date, COUNT(*)
FROM issued_status
WHERE issued_emp_id = "E101"
GROUP BY 1,2;

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_emp_id,count(issued_id) 
from issued_status
group by issued_emp_id
having count(issued_id ) >1
order by 2;


-- ---------------------CTAS Operation -----------------------

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt



create table books_count 
AS
select b.isbn, count(ist.issued_book_isbn) from 
books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by ist.issued_book_isbn
order by 2 ;

select * from books_count;

-- Task 7. **Retrieve All Books in a Specific Category:

select *  from books
where category ="History";

-- Task 8: Find Total Rental Income by Category:

select category,sum(rental_price) as Total_Rental_income, count(category) as Count from books 
group by category
order by 2;

-- Task 9. **List Members Who Registered in the Last 180 Days**:

select * from members
where reg_date >= curdate() - interval 360 day;



insert into members( member_id,member_name,member_address, reg_date)
values("C120" ,"Nitish","152 Main St","2025-11-21"),
("C121","Shubham","159 Main St","2026-01-01");


-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:


select
 b.branch_id,
 e1.emp_name,
 e2.emp_name as mageger, b.branch_address,b.contact_no
 from
branch as b
join
employees as e1
on b.branch_id = e1.branch_id
join
employees as e2
on b.manager_id =e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a 4 USD Threshold.

create table books_price_greter_than_4  as
select book_title,rental_price from books
where rental_price > 4;

select * from books_price_greter_than_4;


-- Task 12: Retrieve the List of Books Not Yet Returned

select distinct ist.issued_book_name  from 
issued_status as ist
left join
return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null;


-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.

select member_name,book_title,issued_date,
DATEDIFF(CURDATE(), ist.issued_date) AS Over_due_days
from
members as m
join
issued_status as ist
on m.member_id =ist.issued_member_id
join
books as bk
on bk.isbn =ist.issued_book_isbn
left join
return_status as rs
on rs.issued_id =ist.issued_id
where 
return_date is null
and 
 DATEDIFF(CURDATE(), ist.issued_date) > 650



-- ---------------------------------------------------------------------The end-------------------------------------------------------------------------------
