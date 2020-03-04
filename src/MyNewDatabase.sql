create database MyNewDatabase;
use MyNewDatabase;
grant all on *.* to root@'%'  identified by 'Passw0rd';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Passw0rd';

DROP TABLE IF EXISTS Counselor;
DROP TABLE IF EXISTS Subject;


CREATE TABLE Counselor (
       counselor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
       first_name VARCHAR (50),
       nick_name VARCHAR (50),
       last_name VARCHAR (50),
       telephone VARCHAR (25),
       email VARCHAR (50),
       member_since DATE DEFAULT '1970-01-01',
       PRIMARY KEY (counselor_id)
);


CREATE TABLE Subject (
	subject_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR (50),
	description TEXT,
	counselor_idfk SMALLINT UNSIGNED,
	PRIMARY KEY (subject_id)
);


INSERT INTO Counselor 
       VALUES  	(null, 'Jake', '"The Jake"', 'Roberts', '412 565-5656', 'jake@ifpwafcad.com', '2003-09-10'),
               	(null, 'Andre', '"The Giant"', '', '606 443-4567', 'andre@ifpwafcad.com', '2001-01-12'),
               	(null, 'Brutus', '"The Brutus"', 'Beefcake', '555 555-4432', 'brutus@ifpwafcad.com', '2005-03-08'),
               	(null, 'Randy', '"Macho Man"', 'Savage', '555 317-4444', 'randy@ifpwafcad.com', '2000-11-10'),
               	(null, 'Ricky', '"The Ricky"', 'Steamboat','334 612-5678', 'ricky@ifpwafcad.com', '1996-01-01'),
               	(null, 'George', '"The George"', 'Steele', '412 565-5656', 'george@ifpwafcad.com', Now()),
               	(null, 'Koko', '"The Koko"', 'B. Ware', '553 499-8162', 'koko@ifpwafcad.com', '1999-12-03'),
               	(null, 'Greg', '"The Greg"', 'Valentine', '617 889-5545', 'greg@ifpwafcad.com', '1998-05-07'),
               	(null, 'Bobby', '"The Bobby"', 'Heenan', '777 513-3333', 'bobby@ifpwafcad.com', '2002-07-09');


INSERT INTO Subject
	VALUES  (null, 'Application Server Management', 'Application servers are most common type of Middleware server.', '9');
	
INSERT INTO Subject
	VALUES  (null, 'Message Oriented middleware Management', 'This type of servers are used for integration of disparate servers.', '7');
INSERT INTO Subject
	VALUES  (null, 'Database Management', 'Database management involves end to end services for managing databases.', '4');
INSERT INTO Subject
	VALUES  (null, 'Enterprise Asset Management', 'Asset and license management at the Enterprise level', '2');	      
INSERT INTO Subject
	VALUES  (null, 'API management', 'API management is the process of publishing, promoting and overseeing application programming interfaces (APIs).', '1');
INSERT INTO Subject
	VALUES  (null, 'Service Management', 'Service Management is a customer-focused approach to delivering information technology.', '3');
INSERT INTO Subject
	VALUES  (null, 'Container Management', 'Better management, Web front ends, improved visibility into container apps ', '8');
INSERT INTO Subject
	VALUES  (null, 'IT Security Management', 'An information security management system (ISMS) is a set of policies and procedures for systematically managing sensitive data.', '6');
INSERT INTO Subject
	VALUES  (null, 'Storage Management', 'The term storage management encompasses the technologies and processes organizations use to maximize or improve the performance of their data storage resources.', '5');

ALTER DATABASE MyNewDatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE Counselor CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE Subject CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
			
			
			
			