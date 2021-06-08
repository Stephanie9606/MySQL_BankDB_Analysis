#hw2
#stephanie

## create bank db
create database if not exists bank; 
use bank;

create table if not exists account
(
account_number char(5) not null primary key,
branch_name varchar(10),
balance double
);
create table if not exists branch
(
branch_name varchar(10) not null primary key,
branch_city varchar(10),
assets double
);
create table if not exists customer
(
customer_name varchar(20) not null primary key,
customer_street varchar(20),
customer_city varchar(10)
);
create table if not exists loan
(
loan_number varchar(5) not null primary key, branch_name varchar(10),
amount double
);
create table if not exists borrower
(
customer_name varchar(20) not null,
loan_number varchar(5) not null,
primary key(customer_name, loan_number)
);
create table if not exists depositor
(
customer_name varchar(20) not null,
account_number char(5) not null,
primary key(customer_name, account_number)
);
create table if not exists employee (
employee_name varchar(20) not null, branch_name varchar(10) not null, salary double,
primary key(employee_name,branch_name)
);

## populating the tables
use bank;

insert into account values('A-101', 'Downtown',   500);
insert into account values('A-102', 'Perryridge', 400);
insert into account values('A-201', 'Brighton', 900);
insert into account values('A-215', 'Mianus', 700);
insert into account values('A-217', 'Brighton', 750);
insert into account values('A-222', 'Redwood', 700);
insert into account values('A-305', 'Round Hill', 350);

insert into branch values('Brighton', 'Brooklyn', 7100000);
insert into branch values('Downtown', 'Brooklyn', 9000000);
insert into branch values('Mianus', 'Horseneck', 400000);
insert into branch values('North Town', 'Rye', 3700000);
insert into branch values('Perryridge', 'Horseneck', 1700000);
insert into branch values('Pownal',     'Bennington',  300000);
insert into branch values('Redwood',    'Palo Alto', 2100000);
insert into branch values('Round Hill', 'Horseneck', 8000000);

insert into customer values('Adams', 'Spring', 'Pittsfield');
insert into customer values('Brooks', 'Senator', 'Brooklyn');
insert into customer values('Curry', 'North', 'Rye');
insert into customer values('Glenn', 'Sand Hill', 'Woodside');
insert into customer values('Green', 'Walnut', 'Stamford');
insert into customer values('Hayes', 'Main', 'Harrison');
insert into customer values('Johnson',  'Alma', 'Palo Alto');
insert into customer values('Jones',    'Main', 'Harrison');
insert into customer values('Lindsay',  'Park', 'Pittsfield');
insert into customer values('Smith',    'North', 'Rye');
insert into customer values('Turner',   'Putnam', 'Stamford');
insert into customer values('Williams', 'Nassau', 'Princeton');

insert into depositor values('Hayes', 'A-102');
insert into depositor values('Johnson', 'A-102');
insert into depositor values('Johnson', 'A-201');
insert into depositor values('Jones', 'A-217');
insert into depositor values('Lindsay', 'A-222');
insert into depositor values('Smith', 'A-215');
insert into depositor values('Turner', 'A-305');

insert into loan values('L-11', 'Round Hill', 900);
insert into loan values('L-14', 'Downtown', 1500);
insert into loan values('L-15', 'Perryridge', 1500);
insert into loan values('L-16', 'Perryridge', 1300);
insert into loan values('L-17', 'Downtown', 1000);
insert into loan values('L-23', 'Redwood', 2000);
insert into loan values('l-93', 'Mianus', 500);

insert into borrower values('Adams', 'L-16');
insert into borrower values('Curry', 'L-93');
insert into borrower values('Hayes', 'L-15');
insert into borrower values('Jackson', 'L-14');
insert into borrower values('Jones', 'L-17');
insert into borrower values('Smith', 'L-11');
insert into borrower values('Smith', 'L-23');
insert into borrower values('Williams', 'L-17');

insert into employee values('Adams', 'Perryridge', 1500);
insert into employee values('Brown', 'Perryridge', 1300);
insert into employee values('Gopal', 'Perryridge', 5300);
insert into employee values('Johnson', 'Downtown', 1500);
insert into employee values('Loreena', 'Downtown', 1300);
insert into employee values('Peterson', 'Downtown', 2500);
insert into employee values('Rao', 'Austin', 1500);
insert into employee values('Sato', 'Austin', 1600);

commit;

## retrieval queries

#1
#find all loan number for loans made at the Perryridge branch with loan amounts greater than $1100
SELECT 
    loan_number
FROM
    loan
WHERE
    branch_name = 'Perryridge'
        AND amount > 1100;

#2
#find the loan number of those loans with loan amounts between $1,000 and $1,500
SELECT 
    loan_number
FROM
    loan
WHERE
    amount BETWEEN 1000 AND 1500;
    
#3
#find the names of all branches that have greater assets than some branch located in Brooklyn
SELECT 
    b1.branch_name
FROM
    branch b1
        JOIN
    branch b2
WHERE
    b1.assets > b2.assets
        AND b2.branch_city = 'Brooklyn';

#4
#find the customer names and their loan numbers for all customers having a loan at some branch
SELECT 
    bo.customer_name, bo.loan_number
FROM
    borrower bo
        INNER JOIN
    loan l ON (bo.loan_number = l.loan_number);

#5
#find all customers who have a loan, an account, or both
SELECT 
    customer_name
FROM
    borrower 
UNION SELECT 
    customer_name
FROM
    depositor;

#6
#find all customers who have an account but no loan (no minus operator provided in mysql)
SELECT DISTINCT
    customer_name
FROM
    depositor
WHERE
    customer_name NOT IN (SELECT 
            customer_name
        FROM
            borrower);

#7
#find the number of depositors for each branch
SELECT 
    branch_name, COUNT(customer_name) AS depositor_total
FROM
    branch,
    customer
WHERE
    branch.branch_city = customer.customer_city
GROUP BY branch_name;

#8
#find the names of all branches where the average account balance is more than $500
SELECT 
    branch.branch_name, AVG(balance)
FROM
    branch
        JOIN
    account ON (branch.branch_name = account.branch_name)
GROUP BY branch.branch_name
HAVING AVG(balance) > 500;
   
#9
#find all customers who have both an account and a loan at the bank
SELECT DISTINCT
    c.customer_name
FROM
    customer c
        INNER JOIN
    depositor d ON (c.customer_name = d.customer_name)
        INNER JOIN
    borrower bo ON (c.customer_name = bo.customer_name);

#10
#find all customers who have a loan at the bank but do not have an account at the bank
SELECT DISTINCT
    customer_name
FROM
    borrower
WHERE
    customer_name NOT IN (SELECT 
            customer_name
        FROM
            depositor);

#11
#find the names of all branches that have greater assets than all branches located in Horseneck (using both non-nested and nested select statement)
#non-nested
SELECT DISTINCT
    br1.branch_name
FROM
    branch br1,  (SELECT 
            MAX(assets) as max_assets
        FROM
            branch
        WHERE
            branch_city = 'HorseNeck') as br2
WHERE
    br1.assets > br2.max_assets;
                         
#nested
SELECT 
    branch_name
FROM
    branch
WHERE
    assets > ALL (SELECT 
            assets
        FROM
            branch
        WHERE
            branch_city = 'HorseNeck');

#12
#1 query of your choice involving aggregate functions
#highest employee's salary
SELECT 
    MAX(salary) AS highest_salary
FROM
    employee;

#13
#1 query of your choice involving group by feature
#average salary by branch_city
SELECT 
    branch_city, ROUND(AVG(assets), 2) AS avg_assets
FROM
    branch
GROUP BY branch_city;

## insert queries
#1
#create a HighLoan table with loan amount >=1500
CREATE TABLE HighLoan AS SELECT * FROM
    loan
WHERE
    amount >= 1500;

SELECT 
    *
FROM
    HighLoan;

#2
#create a HighSalaryEmployee table with employee having salary more than 2000
CREATE TABLE HighSalaryEmployee AS SELECT * FROM
    employee
WHERE
    salary > 2000;

SELECT 
    *
FROM
    HighSalaryEmployee;

#3
#1 more query (meaningful) of your choice on any table
#create table with customers in Stamford
CREATE TABLE StamfordCustomer AS SELECT * FROM
    customer
WHERE
    customer_city = 'Stamford';

SELECT 
    *
FROM
    StamfordCustomer;

## update queries
#1
#increase all accounts with balances over $800 by 7%, all other accounts receive 8%    
UPDATE account 
SET 
    balance = CASE
        WHEN balance > 800 THEN balance * 1.07
        WHEN balance <= 800 THEN balance * 1.08
    END;

#2
#do 2 update queries, each involving 2 tables
#ex1: increase 50% of employee salary where branches are located in Brooklyn

UPDATE branch br
        JOIN
    employee e ON (br.branch_name = e.branch_name) 
SET 
    e.salary = e.salary * 1.5
WHERE
    br.branch_city = 'Brooklyn';

-- #bf update
-- SELECT 
--     br.branch_city, e.employee_name, e.salary
-- FROM
--     branch br
--         JOIN
--     employee e ON (br.branch_name = e.branch_name);

#ex2: decrease 10% of amount in Horseneck city
UPDATE branch br
        JOIN
    loan l ON (br.branch_name = l.branch_name) 
SET 
    l.amount = l.amount * 0.9
WHERE
    br.branch_city = 'Horseneck';
    
-- #bf update
-- select br.branch_city, l.loan_number, l.amount from branch br
--         JOIN
--     loan l ON (br.branch_name = l.branch_name);

#3
#1 more update query of your choice on any table
#revise city Brooklyn to Queens
UPDATE branch 
SET 
    branch_city = 'Queens'
WHERE
    branch_city = 'Brooklyn';

## delete queries
#1
#delete the record of all accounts with balances below the average at the bank
DELETE a1 . * FROM account a1
        JOIN
    (SELECT 
        AVG(balance) AS avg_balance
    FROM
        account) a2 
WHERE
    a1.balance < a2.avg_balance;

#2
#do 2 delete queries, each involving 2 tables
#ex1
#delete records from account table which branch is located in Brooklyn with balance < 600
DELETE a FROM account a
        JOIN
    branch br ON a.branch_name = br.branch_name
WHERE 
    branch_city = 'Brooklyn'
    AND balance < 600;

#ex2
#delete records which branch is located in HorseNeck with salary > 5000
DELETE br, e FROM branch br
        JOIN
    employee e ON br.branch_name = e.branch_name 
WHERE
    branch_city = 'HorseNeck'
    AND salary < 5000;

#3
#1 more delete query of your choice from any table
DELETE FROM branch 
WHERE
    assets < 500000;

## views queries
#1
#a view consisting of branches and their customers
CREATE VIEW BrandandCustomer AS
    SELECT
        br.branch_name, c.customer_name
    FROM
        branch br
            JOIN
        customer c ON br.branch_city = c.customer_city;

#2
#create a view of HQEmployee who work in downtown branch
CREATE VIEW HQEmployee AS
    SELECT 
         *
    FROM
        employee
    WHERE
        branch_name = 'Downtown';

#3
#do one insert, delete, update, and select queries on HQEmployee view
# insert
insert into HQEmployee (employee_name, branch_name, salary) values ('Flora', 'Downtown', 3000);

#delete
DELETE FROM HQEmployee 
WHERE
    salary < 1500;

#update
UPDATE HQEmployee 
SET 
    salary = salary + 50;

# select
SELECT 
    round(avg(salary), 2) AS avg_salary
FROM
    HQEmployee;

## complex queries: provide results
#1
#1 select query involving 3 tables
# branch city's average assets where customer account balance is more than 500
SELECT 
    br.branch_city, AVG(assets) AS avg_assets
FROM
    customer c
        JOIN
    branch br ON c.customer_city = br.branch_city
        JOIN
    account a ON br.branch_name = a.branch_name
WHERE
    a.balance > 500
GROUP BY br.branch_city;

#2
#1 Delete query involving 3 tables
#delete customer from Rye and amount < 1000
DELETE c FROM customer c
        JOIN
    borrower bo ON c.customer_name = bo.customer_name
        JOIN
    loan l ON bo.loan_number = l.loan_number 
WHERE
    c.customer_city = 'Rye'
    AND amount < 1000;
    
#3
#1 Update query involving 3 tables
#revise Smith’s street information to South and add 50 to each of his or her loan
UPDATE customer c
        JOIN
    borrower bo ON c.customer_name = bo.customer_name
        JOIN
    loan l ON bo.loan_number = l.loan_number 
SET 
    c.customer_street = 'South',
    l.amount = l.amount + 50
WHERE
    c.customer_name = 'Smith';

-- #check
-- SELECT 
--     c.customer_name, c.customer_street, l.loan_number, l.amount
-- FROM
--     customer c
--         JOIN
--     borrower bo ON c.customer_name = bo.customer_name
--         JOIN
--     loan l ON bo.loan_number = l.loan_number
-- WHERE
--     c.customer_name = 'Smith';







