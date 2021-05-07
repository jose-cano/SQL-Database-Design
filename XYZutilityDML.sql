-- Jose Cano (1058360)
-- CIDM 6350-70 Project

-- Task 2 UPDATE Queries

-- 2.1
USE xyzutility;

INSERT INTO Customers (`Name`)
VALUES
('Will Draper'),
('Elliot Alders');

-- 2.2
INSERT INTO Tasks (AddressID, ReaderID, TaskDate)
VALUES
(4, 4, '2020-04-22'),
(6, 4, '2021-04-24');

-- 2.3
-- To report reading, as Reader Gaspar run this command

use xyzutility;
SELECT * FROM ReaderTask;

UPDATE Tasks
SET MeterReading = 1900
WHERE TaskID = 31;

-- To create bill, verify consumption using the reported reading

SELECT * FROM TASKS
WHERE AddressID = 4;

-- then calculate and insert the bill information

INSERT INTO Bills
VALUES (10, 2008, '2020-04-23', '2020-05-23', '30', '11.7');

-- 2.4
-- Task for termination reading
INSERT INTO Tasks (AddressID, ReaderID, TaskDate)
VALUES
(3, 4, '2020-06-11');

-- Reader reports reading
use xyzutility;
SELECT * FROM ReaderTask;

UPDATE Tasks
SET MeterReading = 900
WHERE TaskID = 33;

-- To create bill, verify consumption using the reported reading

SELECT * FROM TASKS
WHERE AddressID = 3;

-- then calculate and insert the bill information
SELECT * FROM Bills;
INSERT INTO Bills
VALUES (11, 2009, '2020-06-11', '2020-07-11', 10, 3.8);
UPDATE Tasks
SET BillID = 11
WHERE TaskID = 30 OR TaskID = 33;    -- Logs these tasks as the tasks used to produce the Bill

-- Finally, update deactivation date for the customer on their contract
UPDATE Contracts
SET DeactivationDate = '2020-07-11'
WHERE ContractID = 2795;
SELECT * FROM CONTRACTS
WHERE ContractID = 2795;



-- Task 2.2 Informational Queries
-- 1

SELECT c.`Name`, p.Balance
FROM Customers c, Addresses a, Tasks t, Bills b, Payments p
WHERE p.Balance > 100
AND c.CustomerID = a.CustomerID
AND a.AddressID = t.AddressID
AND t.BillID = b.BillID
AND b.BillID = p.BillID
GROUP BY p.Balance;

-- 2

SELECT t.TaskID, t.ReaderID, r.`Name`, t.TaskDate, t.MeterReading, a.MeterNo, a.Address
FROM Tasks t, Addresses a, Readers r
WHERE r.readerID = 1
AND r.ReaderID = t.ReaderID
AND t.AddressID = a.AddressID;


-- 3

SELECT c.`Name`, a.Address, t.TaskDate, t.MeterReading, b.BillNo, b.IssueDate, b.Consumption, b.totaldue, p.DateOfPayment, p.Payment, p.Balance
FROM Customers c, Addresses a, Tasks t, Bills b, Payments p
WHERE c.customerID = a.CustomerID
AND b.BillID = t.BillID
AND b.BillID = p.BillID
AND t.AddressID = a.AddressID
GROUP BY t.BillID;

-- 4
SELECT * FROM Tasks
WHERE ReaderID = 4
AND (TaskDate BETWEEN '2019-01-01' AND '2020-04-25');

-- 5
SELECT b.BillNo, t.ReaderID, r.`Name`, t.TaskDate
FROM Bills b, Tasks t, Readers r
WHERE b.BillNo = 1002
AND b.BillID = t.BillID
AND t.ReaderID = r.ReaderID;

-- 6
SELECT `Name`, MAX(sumcons) as `MaxConsumption`
FROM
(SELECT SUM(b.Consumption) as sumcons, c.`Name` as `Name`
FROM Bills b, Customers c, Tasks t, Addresses a
WHERE b.BillID = t.BillID
AND t.AddressID = a.AddressID
AND a.CustomerID = c.CustomerID
AND (b.IssueDate BETWEEN '1990-05-01' AND '2020-07-04')
GROUP BY c.`Name`) as T1
GROUP BY `Name`
ORDER BY `MaxConsumption` desc
LIMIT 1;

-- 7
SELECT avg(b.Consumption) as avgConsumption
FROM Bills b
WHERE (b.IssueDate BETWEEN '2017-05-01' AND '2020-07-04');

-- 8
SELECT `Name`, IF (Consumption > avgcons, Consumption, NULL) as Above_Avg_Consumption 
FROM
(SELECT b.Consumption as Consumption, avg(b.Consumption) as avgcons, c.`Name` as `Name`
FROM Bills b, Customers c, Tasks t, Addresses a
WHERE b.BillID = t.BillID
AND t.AddressID = a.AddressID
AND a.CustomerID = c.CustomerID
AND (b.IssueDate BETWEEN '2017-05-01' AND '2020-07-04')
GROUP BY c.`Name`) as T2;
