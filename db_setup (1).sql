DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table
 
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby (
	Hby_ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Hby_Name VARCHAR(255) NOT NULL,
    PRIMARY KEY (Hby_ID)
);

INSERT INTO Hobby (Hby_Name) VALUES
('reading'),
('hiking'),
('chess'),
('Taichi'),
('ballroom dancing'),
('football'),
('Tennis'),
('Rugby'),
('climbing'),
('rowing');

DROP TABLE IF EXISTS Enjoys;

CREATE TABLE Enjoys (
    URN INT UNSIGNED NOT NULL,
    Hby_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (URN, Hby_ID),
    FOREIGN KEY (URN) REFERENCES Student(URN)
    ON DELETE CASCADE,
    FOREIGN KEY (Hby_ID) REFERENCES Hobby(Hby_ID)
    ON DELETE CASCADE
);

INSERT INTO Enjoys VALUES
(612345, 1),
(612345, 2),
(612346, 2),
(612347, 6),
(612354, 5);

DROP TABLE IF EXISTS Society;

CREATE TABLE Society (
	Soc_ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Soc_Name VARCHAR(255) NOT NULL,
    Soc_Email VARCHAR(255) NOT NULL,
    PRIMARY KEY (Soc_ID)
);

INSERT INTO Society (Soc_Name, Soc_Email) VALUES
('Chess Club', 'chess@gmail.com'),
('Football Society', 'football@gmail.com'),
('Sports Group', 'sports@gmail.com'),
('Computer Society', 'computers@gmail.com'),
('Languages Society', 'languages@gmail.com');

DROP TABLE IF EXISTS RelatedHobbies;

CREATE TABLE RelatedHobbies (
    Soc_ID INT UNSIGNED NOT NULL,
    Hby_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (Soc_ID, Hby_ID),
    FOREIGN KEY (Soc_ID) REFERENCES Society(Soc_ID)
    ON DELETE CASCADE,
    FOREIGN KEY (Hby_ID) REFERENCES Hobby(Hby_ID) 
    ON DELETE CASCADE
);

INSERT INTO RelatedHobbies VALUES
(1, 3),
(2, 6),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10);

DROP TABLE IF EXISTS Activity;

CREATE TABLE Activity (
	Act_ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Act_Name VARCHAR(255) NOT NULL,
    Act_Date DATE NOT NULL,
    Soc_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (Act_ID),
    FOREIGN KEY (Soc_ID) REFERENCES Society(Soc_ID)
    ON DELETE CASCADE
);

INSERT INTO Activity (Act_Name, Act_Date, Soc_ID) VALUES
('Chess Competition', '2023-11-20', 1),
('Football meetup', '2023-12-01', 2),
('Evening pub', '2023-05-29', 2),
('Game Jam', '2024-01-05', 4),
('Spanish lesson', '2024-02-13', 5);

DROP TABLE IF EXISTS Partakes;

CREATE TABLE Partakes (
    URN INT UNSIGNED NOT NULL,
    Soc_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (URN, Soc_ID),
    FOREIGN KEY (URN) REFERENCES Student(URN)
    ON DELETE CASCADE,
    FOREIGN KEY (Soc_ID) REFERENCES Society(Soc_ID)
    ON DELETE CASCADE
);

INSERT INTO Partakes VALUES
(612345, 3),
(612346, 3),
(612346, 1),
(612353, 1),
(612347, 2);
