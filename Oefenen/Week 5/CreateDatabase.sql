CREATE DATABASE TestDatabase
GO
USE TestDatabase
GO

CREATE TABLE Student(
	ID	int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	StudentName varchar(50) NOT NULL,
	CreateDate datetime NOT NULL DEFAULT GetDate()
)
GO
