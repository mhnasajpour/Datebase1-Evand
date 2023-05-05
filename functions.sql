IF OBJECT_ID (N'dbo.CheckTicket', N'IF') IS NOT NULL
	DROP FUNCTION CheckTicket;
GO
CREATE FUNCTION dbo.CheckTicket(@userID int, @event_name nvarchar(50))
RETURNS TABLE
AS
RETURN (
	SELECT t.serial_number as "Valid Serial Number", u.user_id as "ID", e.name as "Event"
	FROM dbo.Event e, dbo."User" u, dbo.Ticket t
	WHERE @userID = t.user_id
	AND @event_name = e.name
	AND t.user_id = u.user_id
	AND t.event_id = e.event_id
)
GO

SELECT * FROM dbo.CheckTicket(2, 'AICup')



IF OBJECT_ID (N'dbo.GetAtendeeCount', N'FN') IS NOT NULL
	DROP FUNCTION GetAtendeeCount;
GO
CREATE FUNCTION dbo.GetAtendeeCount(@event_name nvarchar(50))
RETURNS int
AS
BEGIN
	DECLARE @ret int;
	SELECT @ret = COUNT(u.user_id)
	FROM dbo."User" u, dbo.Ticket t, dbo.Event e
	WHERE @event_name = e.name
		AND u.user_id = t.user_id 
		AND t.event_id = e.event_id
	RETURN @ret;
END;
GO
SELECT dbo.GetAtendeeCount('AICup') as "AtendeeCount"



IF OBJECT_ID (N'dbo.GetSimilarEvents', N'IF') IS NOT NULL
	DROP FUNCTION GetSimilarEvents;
GO
CREATE FUNCTION dbo.GetSimilarEvents(@event_name nvarchar(50))
RETURNS TABLE
AS
RETURN (
	SELECT e.event_id as "ID", e.name as "Similar Event", o.name as "Organizer"
	FROM dbo.Event e, dbo.Category c, dbo.Organizer o,
		( SELECT * FROM dbo.Event ) as all_events
	WHERE e.category = c.title
		AND e.category = all_events.category
		AND o.organizer_id = e.organizer_id
		AND e.name != @event_name
)
GO
SELECT Distinct * FROM dbo.GetSimilarEvents('Hello Hackers')
