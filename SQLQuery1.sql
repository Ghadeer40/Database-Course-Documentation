-- Step 1: Create Database
CREATE DATABASE CompanyDB;
-- Use the new database
USE CompanyDB;

-- Step 2: Create Employee Table (first to handle self-referencing supervisor)
CREATE TABLE Employee (
    SSN int primary key identity(1,1),
    FirstName nvarchar(50),
    LastName nvarchar(50),
    BirthDate date,
    Gender bit default 0,
    Supervise int, -- SSN
    DepNumber int -- FK added later after Department table is created
);

-- Step 3: Create Department Table
CREATE TABLE Department (
    DepNumber int primary key identity(1,1),
    DepName nvarchar(50),
    SSN int, -- Manager SSN (FK to Employee)
    HireDate DATE,
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);

-- Now add FK in Employee for DepNumber
ALTER TABLE Employee
ADD FOREIGN KEY (DepNumber) REFERENCES Department(DepNumber);

-- Step 4: Create Location Table
CREATE TABLE Location (
    DepNumber int,
    Location nvarchar(150),
    PRIMARY KEY (DepNumber, Location),
    FOREIGN KEY (DepNumber) REFERENCES Department(DepNumber)
);

-- Step 5: Create Project Table
CREATE TABLE Project (
    ProjectNumber int primary key identity(1,1),
    ProjectName nvarchar(50),
    City nvarchar(150),
    Location nvarchar(150),
    DepNumber int,
    FOREIGN KEY (DepNumber) REFERENCES Department(DepNumber)
);

-- Step 6: Create Work Table (Employee ↔ Project)
CREATE TABLE Work (
    SSN int,
    ProjectNumber int,
    Hours int,
    PRIMARY KEY (SSN, ProjectNumber),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (ProjectNumber) REFERENCES Project(ProjectNumber)
);

-- Step 7: Create Dependent Table
CREATE TABLE Dependent (
    SSN int,
    DependentNum int,
    DependentName nvarchar(150),
    Gender int,
    PRIMARY KEY (SSN, DependentNum),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);


-- Part 2: DML - Insert Sample Data
-- Insert Employees
select * from Employee
INSERT INTO Employee (FirstName, LastName, BirthDate, Gender) VALUES
('Ali', 'Said', '1985-07-15', 1),
('Sara', 'Hassan', '1990-11-22', 0),
('Khalid', 'Mansoor', '1988-05-10', 1),
('Fatma', 'Yousef', '1995-03-09', 0),
('Ahmed', 'Salem', '1982-01-30', 1);

INSERT INTO Employee (FirstName, LastName, BirthDate, Gender,Supervise) VALUES
('fatma', 'Said', '1985-07-15', 1,3),
('marow', 'Hassan', '1990-11-22',0, 3),
('hanan', 'Mansoor', '1988-05-10',0, 3),
('ghadeer', 'Yousef', '1995-03-09',0, 3),
('salim', 'Salem', '1982-01-30',1, 3);

INSERT INTO Employee (FirstName, LastName, BirthDate, Gender,Supervise,DepNumber) VALUES
('fatma', 'Said', '1985-07-15', 1,3,1),
('marow', 'Hassan', '1990-11-22',0, 3,2),
('hanan', 'Mansoor', '1988-05-10',0, 3,3),
('ghadeer', 'Yousef', '1995-03-09',0, 3,4),
('salim', 'Salem', '1982-01-30',1, 3,5);

-- Insert Departments First (required before employees)
select * from Department
INSERT INTO Department (DepName, SSN, HireDate) VALUES 
('HR', NULL, '2018-01-01'),
('Finance', NULL, '2019-03-15'),
('IT', NULL, '2020-06-10'),
('Logistics', NULL, '2021-09-01'),
('Marketing', NULL, '2022-02-20');

-- Update Department Manager SSN
UPDATE Department SET SSN = 1 WHERE DepNumber = 1;
UPDATE Department SET SSN = 2 WHERE DepNumber = 2;
UPDATE Department SET SSN = 3 WHERE DepNumber = 3;
UPDATE Department SET SSN = 4 WHERE DepNumber = 4;
UPDATE Department SET SSN = 5 WHERE DepNumber = 5;

-- Insert Locations
select * from Location
INSERT INTO Location VALUES
(1, 'Muscat'),
(2, 'Salalah'),
(3, 'Sohar'),
(4, 'Nizwa'),
(5, 'Sur');


-- Insert Projects
select * from Project
INSERT INTO Project (ProjectName, City, Location, DepNumber) VALUES
('Payroll System', 'Muscat', 'Muscat', 1),
('Budget Forecast', 'Salalah', 'Salalah', 2),
('Network Upgrade', 'Sohar', 'Sohar', 3),
('Inventory App', 'Nizwa', 'Nizwa', 4),
('Ad Campaign', 'Sur', 'Sur', 5);

-- Insert Work (Employee ↔ Project)
select * from Work
INSERT INTO Work VALUES
(3, 1, 20),
(4, 2, 25),
(5, 3, 30),
(6, 4, 35),
(7, 5, 40);

-- Insert Dependents
select * from Dependent
INSERT INTO Dependent VALUES
(3, 1, 'Mona Ali', 0),
(4, 1, 'Hassan Sara', 1),
(5, 1, 'Laila Khalid', 0),
(6, 1, 'Fahad Fatma', 1),
(7, 1, 'Noor Ahmed', 0);

-- SELECT Queries
-- 1. All Employees in IT Department
SELECT FirstName, LastName FROM Employee WHERE DepNumber = 3;

-- 2. List of Projects and Their Department Names
SELECT p.ProjectName, d.DepName FROM Project p
JOIN Department d ON p.DepNumber = d.DepNumber;

-- 3. Employees working more than 30 hours
SELECT e.FirstName, e.LastName, w.Hours FROM Employee e
JOIN Work w ON e.SSN = w.SSN
WHERE w.Hours > 30;

-- UPDATE Query
-- Increase hours of employee SSN = 1 in Project 1
UPDATE Work SET Hours = Hours + 5 WHERE SSN = 1 AND ProjectNumber = 1;

-- DELETE Query
-- Delete dependent for employee 5
DELETE FROM Dependent WHERE SSN = 5 AND DependentNum = 1;
