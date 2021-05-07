-- Jose Cano (1058360)
-- CIDM 6350-70 Project

-- SCHEMA
DROP DATABASE xyzutility;
CREATE DATABASE IF NOT EXISTS XYZutility;
USE XYZutility;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
CustomerID int auto_increment,
`Name` varchar(30),
PRIMARY KEY (CustomerID)
);

DROP TABLE IF EXISTS Addresses;

CREATE TABLE Addresses (
AddressID int auto_increment,
Address varchar(80),
MeterNo int,
CustomerID int,
PRIMARY KEY (AddressID),
FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
);

DROP TABLE IF EXISTS Contracts;

CREATE TABLE Contracts (
ContractID int auto_increment,
AddressID int,
ActivationDate date,
DeactivationDate date DEFAULT NULL,
BillingRate decimal(3,2),
PRIMARY KEY (ContractID, AddressID),
FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID)
);

DROP TABLE IF EXISTS Tasks;

CREATE TABLE Tasks (
TaskID int auto_increment,
AddressID int,
ReaderID int,
TaskDate date,
MeterReading int,
BillID int,
Notes varchar(60) DEFAULT '',
PRIMARY KEY (TaskID, AddressID),
FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID),
FOREIGN KEY (ReaderID) REFERENCES Readers (ReaderID),
FOREIGN KEY (BillID) REFERENCES Bills (BillID)
);

DROP TABLE IF EXISTS Bills;

CREATE TABLE Bills (
BillID int auto_increment,
BillNo int,
IssueDate date,
DueDate date,
Consumption int,
TotalDue decimal(13,2) DEFAULT 0,
PRIMARY KEY (BillID)
);

DROP TABLE IF EXISTS Payments;

CREATE TABLE Payments (
PaymentID int auto_increment,
BillID int,
Payment decimal(13,2) DEFAULT 0,
DateOfPayment date,
Balance decimal(13,2),
PRIMARY KEY (PaymentID, BillID),
FOREIGN KEY (BillID) REFERENCES Bills (BillID)
);

DROP TABLE IF EXISTS Readers;

CREATE TABLE Readers (
ReaderID int auto_increment,
`Name` varchar(30),
PRIMARY KEY (ReaderID)
);


-- Data Inputs

INSERT INTO Customers
VALUES
(454, 'Kalie Gratton'),
(113, 'Johnath Dun'),
(1125, 'Roxi Falvey'),
(1010, 'Bat Scamel'),
(856, 'Ruperta Horsewood');

INSERT INTO Addresses
VALUES
(1, '36 Laurel Center Canyon TX 79015', 27, 454),
(2, '2768 Clarendon Trail Canyon TX 79015', 5, 113),
(3, '22509 Holmberg Point Canyon TX 79016', 56, 1125),
(4, '07245 Dottie Junction Canyon TX 79015', 48, 454),
(5, '656 Weeping Birch Avenue Canyon TX 79016', 16, 1010),
(6, '656 Weeping Birch Avenue Canyon TX 79016', 16, 856);

INSERT INTO Contracts (ContractID, AddressID, ActivationDate, BillingRate)
VALUES
(3592, 1, '2019-04-15', 0.49),
(5085, 2, '2020-05-06', 0.34),
(2795, 3, '2017-12-04', 0.38),
(2420, 4, '2018-09-21', 0.39),
(3955, 5, '2018-08-19', 0.26),
(4283, 6, '2018-08-13', 0.41);

INSERT INTO Tasks (TaskID, AddressID, ReaderID, TaskDate, MeterReading, BillID, Notes)
VALUES
(1, 1, 1, '2019-04-15', 211, 1, ''),
(2, 1, 1, '2019-05-15', 411, 1, ''),
(3, 2, 2, '2020-05-06', 3851, 2, ''),
(4, 2, 3, '2020-06-06', 4060, 2, ''),
(5, 1, 1, '2019-05-15', 411, 3, ''),
(6, 1, 1, '2019-06-15', 670, 3, ''),
(7, 1, 1, '2019-06-15', 670, 4, ''),
(8, 1, 4, '2019-07-15', 830, 4, ''),
(9, 3, 5, '2017-12-04', 341, 5, ''),
(10, 3, 4, '2018-01-05', 612, 5, ''),
(11, 3, 4, '2018-01-05', 612, 6, ''),
(12, 3, 4, '2018-02-05', 890, 6, ''),
(13, 4, 6, '2018-09-21', 1350, 7, ''),
(14, 4, 6, '2018-10-21', 1870, 7, ''),
(15, 5, 7, '2018-08-19', 269, 8, ''),
(16, 5, 7, '2018-09-19', 400, 8, ''),
(17, 6, 5, '2019-10-23', 400, 9, ''),
(18, 6, 1, '2019-11-23', 730, 9, ''),
(19, 2, 3, '2020-06-06', 4060, NULL, ''),
(20, 4, 6, '2018-10-21', 1870, NULL, ''),
(21, 1, 4, '2019-07-15', 830, NULL, ''),
(22, 6, 7, '2018-08-19', 269, NULL, ''),
(23, 6, 7, '2018-09-19', 400, NULL, 'need bill'),
(24, 6, 7, '2018-09-19', 400, NULL, 'new customer, needs new reading'),
(25, 6, 1, '2019-11-23', 730, NULL, ''),
(26, 5, 7, '2018-09-19', 400, NULL, 'terminated'),
(27, 5, 5, '2019-10-23', 400, NULL, ''),
(28, 5, 1, '2019-11-23', 730, NULL, 'need bill'),
(29, 5, 1, '2019-11-23', 730, NULL, ''),
(30, 3, 4, '2018-02-05', 890, NULL, 'needs new reading');

INSERT INTO Readers
VALUES
(1, 'Genvieve Creighton'),
(2, 'Lancelot Tschiersch'),
(3, 'Bernita Munson'),
(4, 'Gaspar McCaskill'),
(5, 'Cherye Buey'),
(6, 'Evaleen Madelin'),
(7, 'Rosalia Skip');

INSERT INTO Bills (BillID, BillNo, IssueDate, DueDate, Consumption, TotalDue)
VALUES
(1, 1001, '2019-05-15', '2019-06-14', 200, 98),
(2, 1002, '2020-06-06', '2020-07-06', 209, 71.06),
(3, 1003, '2019-06-15', '2019-07-15', 259, 126.91),
(4, 1004, '2019-07-15', '2019-08-14', 160, 78.4),
(5, 1005, '2017-12-04', '2018-01-03', 271, 102.98),
(6, 1006, '2018-01-05', '2018-02-04', 278, 105.64),
(7, 1007, '2018-10-21', '2018-11-20', 520, 202.8),
(8, 2006, '2018-09-19', '2018-10-19', 131, 34.06),
(9, 2007, '2019-11-23', '2019-12-23', 330, 135.3);

INSERT INTO Payments (PaymentID, BillID, Payment, DateOfPayment, Balance)
VALUES
(1, 1, 98, '2019-05-20', 0),
(2, 2, 71.06, '2020-06-07', 0),
(3, 3, 126.91, '2019-06-20', 0),
(4, 4, 78.4, '2019-07-16', 0),
(5, 5, 102.98, '2017-12-06', 0),
(6, 6, 105.64, '2018-01-08', 0),
(7, 7, 100, '2018-10-22', 102.8),
(8, 8, 34.06, NULL, 34.06),
(9, 9, 100, '2019-11-25', 35.3),
(10, 9, 35.3, '2019-12-10', 0);


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;