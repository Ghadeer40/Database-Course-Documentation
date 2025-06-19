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

