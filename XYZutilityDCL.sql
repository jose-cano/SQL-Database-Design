-- Jose Cano (1058360)
-- CIDM 6350-70 Project

-- Users and Roles

USE xyzutility;



CREATE ROLE IF NOT EXISTS manager@localhost;

GRANT SELECT on xyzutility.* TO 'manager'@'localhost';
GRANT ALL on xyzutility.tasks TO 'manager'@'localhost';
DROP USER IF EXISTS Jane@localhost;
CREATE USER 'Jane'@'localhost' identified BY 'xyzpass' default role manager@localhost;

CREATE ROLE IF NOT EXISTS customerservice@localhost;
GRANT SELECT ON xyzutility.Bills TO 'customerservice'@'localhost';
GRANT SELECT ON xyzutility.Customers TO 'customerservice'@'localhost';
GRANT SELECT ON xyzutility.Contracts TO 'customerservice'@'localhost';
DROP USER IF EXISTS Joe@localhost;
CREATE USER 'Joe'@'localhost' identified BY 'xyzpass' default role customerservice@localhost;


drop function if exists curuser;
create function curuser()
returns char(50) 
READS SQL DATA
NOT DETERMINISTIC
return (LEFT(USER(), LOCATE('@', user())-1 ));

DROP VIEW IF EXISTS ReaderTask;
CREATE VIEW ReaderTask AS
SELECT t.TaskID, t.ReaderID, r.`Name`, t.TaskDate, t.MeterReading, a.MeterNo, a.Address
FROM Tasks t, Addresses a, Readers r
WHERE LEFT(r.`Name`, LOCATE(' ', r.`Name`)-1 )= LEFT(USER(), LOCATE('@', user())-1 ) 
AND r.ReaderID = t.ReaderID
AND t.AddressID = a.AddressID
GROUP BY a.MeterNo, t.MeterReading;

CREATE ROLE IF NOT EXISTS reader@localhost;
GRANT SELECT ON xyzutility.ReaderTask TO 'reader'@'localhost';
GRANT SELECT (TaskID, TaskDate, MeterReading) ON xyzutility.tasks TO 'reader'@'localhost';
GRANT UPDATE (MeterReading) ON xyzutility.Tasks TO 'reader'@'localhost';
GRANT EXECUTE ON FUNCTION curuser TO 'reader'@'localhost';

DROP USER IF EXISTS Gaspar@localhost;
CREATE USER 'Gaspar'@'localhost' identified by 'xyzpass' default role reader@localhost;





FLUSH privileges;