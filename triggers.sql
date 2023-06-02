CREATE TRIGGER CANCELREGISTRATIONS 
ON EVENT
AFTER DELETE
AS
  BEGIN
      DECLARE @ID INT
      DECLARE USER_CURSOR CURSOR FOR
        SELECT "USER_ID"
        FROM   DBO.TICKET
        WHERE  EVENT_ID IN (SELECT EVENT_ID
                            FROM   DELETED)

      OPEN USER_CURSOR
      FETCH NEXT FROM USER_CURSOR INTO @ID

      WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO DBO.MESSAGE
                        (MEMBER_ID,TEXT,IS_SEEN)
            VALUES     (@ID,'The event you registered for is cancelled',0);

            FETCH NEXT FROM USER_CURSOR INTO @ID
        END

      DELETE FROM TICKET
      WHERE  EVENT_ID IN (SELECT EVENT_ID
                          FROM   DELETED)
  END
GO


CREATE TRIGGER NOTIFYSTAFF
ON COMMENT
AFTER INSERT
AS
  BEGIN
      DECLARE @ID INT
      DECLARE USER_CURSOR CURSOR FOR
        SELECT "USER_ID"
        FROM   DBO.STAFF
        WHERE  EVENT_ID IN (SELECT EVENT_ID
                            FROM   INSERTED)

      OPEN USER_CURSOR
      FETCH NEXT FROM USER_CURSOR INTO @ID

      WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO DBO.MESSAGE
                        (MEMBER_ID,TEXT,IS_SEEN)
            VALUES      (@ID,'A comment has been posted on an event you are staff of',0);

            FETCH NEXT FROM USER_CURSOR INTO @ID
        END
  END
GO


CREATE TRIGGER UPDATEDATE
ON EVENT
AFTER UPDATE
AS
  BEGIN
      UPDATE EVENT
      SET    DATE_UPDATED = Getdate()
      WHERE  EVENT_ID IN (SELECT EVENT_ID
                          FROM   INSERTED)
  END
GO 