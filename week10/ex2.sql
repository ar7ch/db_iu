create table users(
		username varchar(30),
		fullname varchar(100),
		balance decimal(10,3),
		groupId int);

insert into users(username, fullname, balance, groupId)
	values
	('jones', 'Alice Jones', 82, 1),
	('bitdiddl', 'Ben Bitdiddle', 65, 1),
	('mike', 'Michael Dole', 73, 2),
	('alyssa', 'Alyssa P. Hacker', 79, 3),
	('bbrown', 'Bob Brown', 100, 3);
