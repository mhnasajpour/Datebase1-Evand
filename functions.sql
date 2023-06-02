IF Object_id (N'dbo.CheckTicket', N'IF') IS NOT NULL 
	DROP FUNCTION CHECKTICKET;
GO
CREATE OR ALTER FUNCTION DBO.CHECKTICKET(@USERID INT, @EVENT_NAME NVARCHAR(50))
RETURNS TABLE AS
RETURN
(
       SELECT T.SERIAL_NUMBER AS "VALID SERIAL NUMBER",
              U.USER_ID       AS "ID",
              E.NAME          AS "EVENT"
       FROM   DBO.EVENT E,
              DBO."USER" U,
              DBO.TICKET T
       WHERE  @USERID = T.USER_ID
       AND    @EVENT_NAME = E.NAME
       AND    T.USER_ID = U.USER_ID
       AND    T.EVENT_ID = E.EVENT_ID )

SELECT * FROM DBO.CHECKTICKET(2, 'AICup')


IF OBJECT_ID (N'dbo.GetAtendeeCount', N'FN') IS NOT NULL 
	DROP FUNCTION GETATENDEECOUNT;
GO
CREATE OR ALTER FUNCTION DBO.GETATENDEECOUNT(@EVENT_NAME NVARCHAR(50))
RETURNS INT AS
BEGIN
  DECLARE @RET INT;
  SELECT @RET = Count(U.USER_ID)
  FROM   DBO."USER" U,
         DBO.TICKET T,
         DBO.EVENT E
  WHERE  @EVENT_NAME = E.NAME
  AND    U.USER_ID = T.USER_ID
  AND    T.EVENT_ID = E.EVENT_ID
  RETURN @RET;
END;
SELECT DBO.GETATENDEECOUNT('AICup') AS "AtendeeCount"


IF Object_id (N'dbo.GetSimilarEvents', N'IF') IS NOT NULL 
	DROP FUNCTION GETSIMILAREVENTS;
GO
CREATE OR ALTER FUNCTION DBO.GETSIMILAREVENTS(@EVENT_NAME NVARCHAR(50))
RETURNS TABLE AS
RETURN
(
       SELECT E.EVENT_ID AS "ID",
              E.NAME     AS "Similar Event",
              O.NAME     AS "Organizer"
       FROM   DBO.EVENT E,
              DBO.CATEGORY C,
              DBO.ORGANIZER O,
              (
                     SELECT *
                     FROM   DBO.EVENT ) AS ALL_EVENTS
       WHERE  E.CATEGORY = C.TITLE
       AND    E.CATEGORY = ALL_EVENTS.CATEGORY
       AND    O.ORGANIZER_ID = E.ORGANIZER_ID
       AND    E.NAME != @EVENT_NAME )

SELECT DISTINCT * FROM DBO.GETSIMILAREVENTS('Hello Hackers')