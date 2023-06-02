--drop table Star
--drop table Comment
--drop table Staff
--drop table Social_media
--drop table Message
--drop table Ticket
--drop table Discount
--drop table Event
--drop table "User"
--drop table Organizer
--drop table Member
--drop table Category

create table Category(
	title			nvarchar(50) primary key,
	description		nvarchar(500) null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate()
);

create table Member(
	member_id		int identity(1,1) primary key,
	email			varchar(50) unique not null check(email like '%@%.%'),
	password		varchar(50) not null,
	phone_number	varchar(11) null check(phone_number like '09%' and len(phone_number) = 11),
	thumbnail		nvarchar(MAX) null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate()
);

create table Organizer(
	organizer_id	int primary key,
	name			nvarchar(50) unique not null,
	description		nvarchar(500) null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key (organizer_id) REFERENCES Member(member_id)
);

create table "User"(
	"user_id"		int primary key,
	first_name		nvarchar(50) not null,
	last_name		nvarchar(50) not null,
	birth_date		date null check(birth_date < getdate()),
	province		nvarchar(50) null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key ("user_id") REFERENCES Member(member_id)
);

create table Event(
	event_id			int primary key,
	category			nvarchar(50) null,
	organizer_id		int not null,
	name				nvarchar(50) not null,
	price				decimal(12, 3) null check(price >= 0),
	place				nvarchar(50) null,			
	type				nvarchar(15) not null check(type in ('Attendance', 'Non-Attendance', 'Both')),
	description			nvarchar(500) null,
	exp_registration	datetime null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key (event_id) REFERENCES Member(member_id),
	foreign key (category) REFERENCES Category(title),
	foreign key (organizer_id) REFERENCES Organizer(organizer_id)
);

create table Social_media(
	member_id		int,
	name			nvarchar(10) check(name in ('Website', 'Linkedin', 'Telegram', 'Instagram', 'WhatsApp', 'Twitter', 'Skype', 'Facebook', 'Github')),
	link			nvarchar(100) not null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	primary key (member_id, name),
	foreign key (member_id) REFERENCES Member(member_id)
);

create table Message(
	message_id		int identity(1,1) primary key,
	member_id		int not null,
	text			nvarchar(500) not null,
	is_seen			bit not null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key (member_id) REFERENCES Member(member_id)
);

create table Discount(
	code			nvarchar(20) primary key,
	event_id		int not null,
	"percent"		decimal(2, 0) not null check("percent" >= 0),
	exp_date		datetime null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key (event_id) REFERENCES Event(event_id)
);

create table Staff(
	"user_id"		int,
	event_id		int,
	roll			nvarchar(50) null,
	is_admin		bit not null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	primary key ("user_id", event_id),
	foreign key ("user_id") REFERENCES "User"("user_id"),
	foreign key (event_id) REFERENCES Event(event_id)
);

create table Ticket(
	serial_number	nvarchar(20) primary key,
	"user_id"		int not null,
	event_id		int not null,
	discount_code	nvarchar(20) null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key ("user_id") REFERENCES "User"("user_id"),
	foreign key (event_id) REFERENCES Event(event_id),
	foreign key (discount_code) REFERENCES Discount(code)
);

create table Comment(
	comment_id		int identity(1,1) primary key,
	"user_id"		int not null,
	event_id		int not null,
	text			nvarchar(500) not null,
	is_enabled		bit not null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	foreign key ("user_id") REFERENCES "User"("user_id"),
	foreign key (event_id) REFERENCES Event(event_id)
);

create table Star(
	"user_id"		int,
	event_id		int,
	rate			decimal(2, 1) not null check(rate between 0 and 5),
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	primary key ("user_id", event_id),
	foreign key ("user_id") REFERENCES "User"("user_id"),
	foreign key (event_id) REFERENCES Event(event_id)
);


insert into Category(title) values('Educational');
insert into Category(title) values('Sports');

insert into Member(email, password, phone_number, thumbnail) values('mhnasajpour@gmail.com', 'dfg64f', '09134596626', '/images/pic1');
insert into Member(email, password, phone_number, thumbnail) values('danny@gmail.com', 'ikjhgb666', '09135649685', '/images/pic2');
insert into Member(email, password, phone_number) values('melika@gmail.com', 'jhgf7d6sa54', '09107826623');
insert into Member(email, password, phone_number, thumbnail) values('shayan@gmail.com', 'fdytjdfg898', '09107860245', '/images/pic3');
insert into Member(email, password, phone_number) values('hellohackers@gmail.com', 'abcf767454', '09387860245');
insert into Member(email, password, phone_number, thumbnail) values('aicup@gmail.com', 'ikqb0086', '09453671085', '/images/pic4');

insert into Organizer(organizer_id, name) values (3, 'Isfahan university of technology');
insert into Organizer(organizer_id, name) values (4, 'Sepahan');

insert into "User"("user_id", first_name, last_name, birth_date) values(1, 'Mohammad', 'Nasajpour', '2002-03-27');
insert into "User"("user_id", first_name, last_name) values(2, 'Danial', 'Khorasanizadeh');

insert into Event(event_id, category, organizer_id, name, type, price) values(5, 'Educational', 3, 'Hello Hackers', 'Non-Attendance', 100000);
insert into Event(event_id, category, organizer_id, name, type, price) values(6, 'Educational', 3, 'AICup', 'Attendance', 200000);

insert into Social_media(member_id, name, link) values(1, 'Telegram', '@mhnasajpour');
insert into Social_media(member_id, name, link) values(3, 'Linkedin', 'linkedin.com/in/fotoohi/');

insert into Message(member_id, text, is_seen) values(1, 'Welome to Evand', 1);
insert into Message(member_id, text, is_seen) values(2, 'How can i help you?', 0);

insert into Discount(code, event_id, "percent") values ('6s7d8f5', 5, 50);
insert into Discount(code, event_id, "percent", exp_date) values ('uihngbd', 5, 85, DATEADD(day, 7, GETDATE()));

insert into Staff("user_id", event_id, roll, is_admin) values (1, 6, 'HR', 0);
insert into Staff("user_id", event_id, roll, is_admin) values (2, 5, 'CTO', 1);

insert into Ticket(serial_number, "user_id", event_id, discount_code) values ('avnkewrj', 1, 5, '6s7d8f5');
insert into Ticket(serial_number, "user_id", event_id) values ('utjfkoif', 2, 6);

insert into Comment("user_id", event_id, text, is_enabled) values (1, 5, 'It was very good', 1);
insert into Comment("user_id", event_id, text, is_enabled) values (2, 5, 'What was this shit', 0);

insert into Star("user_id", event_id, rate) values (1, 5, 4.5);
insert into Star("user_id", event_id, rate) values (2, 5, 1);