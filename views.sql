CREATE OR ALTER VIEW PARTICIPANT AS
SELECT    SERIAL_NUMBER,
          "USER_ID",
          BASE.EVENT_ID,
          ORGANIZER_ID,
          FIRST_NAME,
          LAST_NAME,
          NAME,
          PURCHASE_TIME,
          (100 - ISNULL(DISCOUNT."PERCENT", 0)) * PRICE / 100 AS PAYMENT,
          ISNULL(DISCOUNT."PERCENT", 0)                       AS DISCOUNT
FROM      (
                 SELECT SERIAL_NUMBER,
                        "USER"."USER_ID",
                        EVENT.EVENT_ID,
                        EVENT.ORGANIZER_ID,
                        FIRST_NAME,
                        LAST_NAME,
                        EVENT.NAME,
                        EVENT.PRICE,
                        TICKET.DATE_CREATED AS PURCHASE_TIME,
                        TICKET.DISCOUNT_CODE
                 FROM   "USER",
                        TICKET,
                        EVENT
                 WHERE  "USER".USER_ID = TICKET.USER_ID
                 AND    TICKET.EVENT_ID = EVENT.EVENT_ID ) AS BASE
LEFT JOIN DISCOUNT
ON        BASE.DISCOUNT_CODE = DISCOUNT.CODE


CREATE OR ALTER VIEW DISCOUNT_STATUS AS
SELECT DISCOUNT.CODE,
       EVENT.EVENT_ID,
       EVENT.NAME,
       EVENT.CATEGORY,
       ORGANIZER.ORGANIZER_ID,
       ORGANIZER.NAME AS ORGANIZE_NAME,
       EVENT.EXP_REGISTRATION,
       DISCOUNT."PERCENT" AS DISCOUNT_PERCENT,
       EVENT.PRICE,
       PRICE * (100 - DISCOUNT."PERCENT") / 100 AS FINAL_COST,
       DISCOUNT.DATE_CREATED                    AS CREATE_DATE,
       DISCOUNT.EXP_DATE                        AS EXPIRE_DATE,
       (
              SELECT Count(DISCOUNT_CODE)
              FROM   TICKET
              WHERE  DISCOUNT_CODE = DISCOUNT.CODE) AS NUMBER_OF_USED
FROM   DISCOUNT,
       EVENT,
       TICKET,
       ORGANIZER
WHERE  DISCOUNT.EVENT_ID = EVENT.EVENT_ID
AND    EVENT.EVENT_ID = TICKET.EVENT_ID
AND    EVENT.ORGANIZER_ID = ORGANIZER.ORGANIZER_ID


CREATE OR ALTER VIEW BEST_EVENTS AS
SELECT   *,
         RANK() OVER(ORDER BY SCORE DESC) AS rank
FROM     (
                SELECT *,
                       (TICKETS * 10) + (ISNULL(SALES, 0) / 20000) + (STAFFS * 10) + (ISNULL(STARS, 2.5) * 100) + (COMMENTS * 20) AS score
                FROM   (
                              SELECT EVENT.EVENT_ID,
                                     EVENT.NAME,
                                     EVENT.CATEGORY,
                                     ORGANIZER.NAME AS organizer,
                                     MEMBER.EMAIL,
                                     MEMBER.PHONE_NUMBER,
                                     EVENT.PRICE,
                                     EVENT.PLACE,
                                     EVENT.TYPE,
                                     MEMBER.THUMBNAIL,
                                     EVENT.EXP_REGISTRATION,
                                     EVENT.DESCRIPTION,
                                     (
                                            SELECT Count(TICKET.SERIAL_NUMBER)
                                            FROM   EVENT AS T,
                                                   TICKET
                                            WHERE  EVENT.EVENT_ID = T.EVENT_ID
                                            AND    T.EVENT_ID = TICKET.EVENT_ID) AS tickets,
                                     (
                                               SELECT    Sum(S.PRICE * (100 - ISNULL(DISCOUNT."PERCENT", 0)) / 100)
                                               FROM     (
                                                                SELECT PRICE,
                                                                       DISCOUNT_CODE
                                                                FROM   EVENT AS T,
                                                                       TICKET
                                                                WHERE  EVENT.EVENT_ID = T.EVENT_ID
                                                                AND    T.EVENT_ID = TICKET.EVENT_ID) AS S
                                               LEFT JOIN DISCOUNT
                                               ON        S.DISCOUNT_CODE = DISCOUNT.CODE) AS sales,
                                     (
                                            SELECT Count(STAFF.USER_ID)
                                            FROM   EVENT AS T,
                                                   STAFF
                                            WHERE  EVENT.EVENT_ID = T.EVENT_ID
                                            AND    T.EVENT_ID = STAFF.EVENT_ID) AS staffs,
                                     (
                                            SELECT Avg(STAR.RATE)
                                            FROM   EVENT AS T,
                                                   STAR
                                            WHERE  EVENT.EVENT_ID = T.EVENT_ID
                                            AND    T.EVENT_ID = STAR.EVENT_ID) AS stars,
                                     (
                                            SELECT Count(COMMENT.COMMENT_ID)
                                            FROM   EVENT AS T,
                                                   COMMENT
                                            WHERE  EVENT.EVENT_ID = T.EVENT_ID
                                            AND    T.EVENT_ID = COMMENT.EVENT_ID) AS comments
                              FROM   EVENT,
                                     MEMBER,
                                     ORGANIZER
                              WHERE  EVENT.EVENT_ID = MEMBER.MEMBER_ID
                              AND    EVENT.ORGANIZER_ID = ORGANIZER.ORGANIZER_ID) AS BASE) AS SCORE