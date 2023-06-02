CREATE PROCEDURE SendMessageToAll @message varchar(255) = null AS BEGIN
SET NOCOUNT ON;
DECLARE @ID int
DECLARE member_cursor CURSOR FOR
SELECT member_id
FROM dbo.Member OPEN member_cursor FETCH NEXT
FROM member_cursor INTO @ID WHILE @@FETCH_STATUS = 0 BEGIN
INSERT INTO dbo.Message(member_id, text, is_seen)
VALUES(@ID, @message, 0);
FETCH NEXT
FROM member_cursor INTO @ID
END CLOSE member_cursor DEALLOCATE member_cursor
END
GO EXEC SendMessageToAll 'AICup is coming soon' CREATE PROCEDURE CreateEvent @email nvarchar(50) = null,
    @password varchar(50) = null,
    @phone_number varchar(50) = null,
    @thumbnail varchar(50) = null,
    @category_title varchar(50) = null,
    @organizer_name varchar(50) = null,
    @name varchar(50) = null,
    @price decimal(12, 3) = null,
    @place varchar(50) = null,
    @type varchar(15) = null,
    @description varchar(500) = null,
    @exp_registration datetime = null AS BEGIN
SET NOCOUNT ON;
DECLARE @organizer int
DECLARE @category varchar(50)
DECLARE @event_id int
SELECT @organizer = organizer_id
FROM dbo.organizer
WHERE name = @organizer_name IF @organizer IS NULL BEGIN RAISERROR('Organizer not found', 16, 1) RETURN
END
SELECT @category = title
FROM dbo.category
WHERE title = @category_title IF @category IS NULL BEGIN RAISERROR('Category not found', 16, 1) RETURN
END
INSERT INTO dbo.member(email, password, phone_number, thumbnail)
VALUES(@email, @password, @phone_number, @thumbnail)
SELECT @event_id = member_id
FROM dbo.member
WHERE email = @email
    and password = @password
INSERT INTO dbo.Event(
        event_id,
        category,
        organizer_id,
        name,
        price,
        place,
        type,
        description,
        exp_registration
    )
VALUES(
        @event_id,
        @category,
        @organizer,
        @name,
        @price,
        @place,
        @type,
        @description,
        @exp_registration
    )
END
GO EXEC CreateEvent 'robo@iut.ac.ir',
    'cd8vs6g743d',
    null,
    null,
    'Educational',
    'Isfahan university of technology',
    'RoboIUT',
    100000,
    'Isfahan university of technology',
    'Both',
    'An Robotic competition',
    '2023-12-12 00:00:00'
GO CREATE PROCEDURE CreateDiscount @percent int,
    @eventID int,
    @eventID int,
    @expire_date datetime AS BEGIN
SET NOCOUNT ON;
DECLARE @event int = (
        SELECT event_id
        FROM dbo.Event
        WHERE event_id = @eventID
    )
DECLARE @event int = (
        SELECT event_id
        FROM dbo.Event
        WHERE event_id = @eventID
    ) IF @event is null BEGIN RAISERROR('Event not found!', 16, 1) RETURN
END
DECLARE @discount decimal(2, 0) = (100 - @percent) / 100 IF GETDATE() > @expire_date BEGIN RAISERROR('expiraion date not valid!', 16, 1) RETURN
END --generate random code
DECLARE @random_code varchar(8)
SELECT @random_code = coalesce(@random_code, '') + CHAR(
        CASE
            WHEN r between 0 and 9 THEN 48
            WHEN r between 10 and 35 THEN 55
            ELSE 61
        END + r
    )
FROM master..spt_values
    CROSS JOIN (
        SELECT CAST(RAND(ABS(CHECKSUM(NEWID()))) * 61 as int) r
    ) a
WHERE type = 'P'
    AND number < 8
INSERT INTO dbo.Discount (code, event_id, dbo.Discount."percent", exp_date)
VALUES (@random_code, @event, @percent, @expire_date)
END
GO EXEC CreateDiscount @eventID = 6,
    @percent = 20,
    @expire_date = '2025-05-10 23:59:59'