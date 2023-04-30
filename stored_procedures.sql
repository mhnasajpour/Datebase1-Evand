CREATE PROCEDURE SendMessageToAll
    @message varchar(255) = null
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ID int
    DECLARE member_cursor CURSOR FOR SELECT member_id FROM dbo.Member
    OPEN member_cursor
    FETCH NEXT FROM member_cursor INTO @ID
    WHILE @@FETCH_STATUS=0
    BEGIN
        INSERT INTO dbo.Message(member_id, text, is_seen) VALUES(@ID, @message, 0);
        FETCH NEXT FROM member_cursor INTO @ID
    END
    CLOSE member_cursor
    DEALLOCATE member_cursor
END
GO
CREATE PROCEDURE CreateEvent
    @category_title varchar(50) = null,
    @organizer_name varchar(50) = null,
    @name varchar(50) = null,
    @price decimal(12, 3) = null,
    @place varchar(50) = null,
    @type varchar(15) = null,
    @description varchar(500) = null,
    @exp_registration datetime = null
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @organizer int
    DECLARE @category varchar(50)
    SELECT @organizer = organizer_id FROM dbo.Organizer WHERE name = @organizer_name
    IF @organizer IS NULL
    BEGIN
        RAISERROR('Organizer not found', 16, 1)
        RETURN
    END
    SELECT @category = title FROM dbo.Category WHERE title = @category_title
    IF @category IS NULL
    BEGIN
        RAISERROR('Category not found', 16, 1)
        RETURN
    END
    INSERT INTO dbo.Event(event_id, category, organizer_id, name, price, place, type, description, exp_registration) VALUES(@organizer, @category, @organizer, @name, @price, @place, @type, @description, @exp_registration)
END
GO
EXEC CreateEvent 'Educational', 'Isfahan university of technology', 'AICup', 100, 'Isfahan university of technology', 'Both', 'An AI competition', '2023-12-12 00:00:00'
EXEC SendMessageToAll 'AICup is coming soon'


