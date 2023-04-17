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
	email			varchar(50) unique not null,
	password		varchar(50) not null,
	phone_number	varchar(11) null,
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
	birth_date		date null,
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
	price				decimal(12, 3) null,
	place				nvarchar(50) null,			
	type				nvarchar(20) not null,
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
	name			nvarchar(50),
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
	"percent"		decimal(2, 0) not null,
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
	payment			decimal(12, 3) null,
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
	rate			decimal(2, 1) not null,
	date_created	datetime default getdate(),
	date_updated	datetime default getdate(),
	primary key ("user_id", event_id),
	foreign key ("user_id") REFERENCES "User"("user_id"),
	foreign key (event_id) REFERENCES Event(event_id)
);