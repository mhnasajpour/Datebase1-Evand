CREATE TRIGGER CancelRegistrations
ON Event
AFTER DELETE
AS
BEGIN
    DECLARE @ID int
    DECLARE user_cursor CURSOR FOR SELECT "user_id" FROM dbo.Ticket WHERE event_id IN (SELECT event_id FROM deleted)
    OPEN user_cursor
    FETCH NEXT FROM user_cursor INTO @ID
    WHILE @@FETCH_STATUS=0
    BEGIN
        INSERT INTO dbo.Message(member_id, text, is_seen) VALUES(@ID, 'The event you registered for is cancelled', 0);
        FETCH NEXT FROM user_cursor INTO @ID
    END
    DELETE FROM Ticket WHERE event_id IN (SELECT event_id FROM deleted)
END
GO


CREATE TRIGGER NotifyStaff
ON Comment
AFTER INSERT
AS
BEGIN
    DECLARE @ID int
    DECLARE user_cursor CURSOR FOR SELECT "user_id" FROM dbo.Staff WHERE event_id IN (SELECT event_id FROM inserted)
    OPEN user_cursor
    FETCH NEXT FROM user_cursor INTO @ID
    WHILE @@FETCH_STATUS=0
    BEGIN
        INSERT INTO dbo.Message(member_id, text, is_seen) VALUES(@ID, 'A comment has been posted on an event you are staff of', 0);
        FETCH NEXT FROM user_cursor INTO @ID
    END
END
GO


CREATE TRIGGER UpdateDate
ON Event
AFTER UPDATE
AS
BEGIN
    UPDATE Event SET date_updated = GETDATE() WHERE event_id IN (SELECT event_id FROM inserted)
END
GO