create or alter view participant
as
select serial_number,
	"user_id",
	base.event_id,
	organizer_id,
	first_name,
	last_name,
	name,
	purchase_time,
	payment,
	isnull(discount."percent", 0) as discount
from (select serial_number,
		"user"."user_id",
		event.event_id,
		event.organizer_id,
		first_name,
		last_name,
		event.name,
		ticket.date_created as purchase_time,
		payment,
		ticket.discount_code
	from "user", ticket, event
	where "user".user_id = ticket.user_id and
		ticket.event_id = event.event_id
		) as base left join discount 
		on base.discount_code = discount.code


create or alter view discount_status
as
select discount.code,
	event.event_id,
	event.name,
	event.category,
	organizer.organizer_id,
	organizer.name as organize_name,
	event.exp_registration,
	discount."percent" as discount_percent,
	event.price,
	price * (100 - discount."percent") / 100 as final_cost,
	discount.date_created as create_date,
	discount.exp_date as expire_date,
	(select count(discount_code) from ticket where discount_code = discount.code) as number_of_used
from discount, event, ticket, organizer
where discount.event_id = event.event_id and
	event.event_id = ticket.event_id and
	event.organizer_id = organizer.organizer_id


create or alter view best_events
as
select *,
	rank() over(order by score desc) as rank
from (select *,
		(tickets * 10) + (isnull(sales, 0) / 20000) + (staffs * 10) + (isnull(stars, 2.5) * 100) + (comments * 20) as score
	from (select event.event_id,
			event.name,
			event.category,
			organizer.name as organizer,
			member.email,
			member.phone_number,
			event.price,
			event.place,
			event.type,
			member.thumbnail,
			event.exp_registration,
			event.description,
			(select count(ticket.serial_number) from event as t, ticket where event.event_id = t.event_id and t.event_id = ticket.event_id) as tickets,
			(select sum(ticket.payment) from event as t, ticket where event.event_id = t.event_id and t.event_id = ticket.event_id) as sales,
			(select count(staff.user_id) from event as t, staff where event.event_id = t.event_id and t.event_id = staff.event_id) as staffs,
			(select avg(star.rate) from event as t, star where event.event_id = t.event_id and t.event_id = star.event_id) as stars,
			(select count(comment.comment_id) from event as t, comment where event.event_id = t.event_id and t.event_id = comment.event_id) as comments
		from event, member, organizer
		where event.event_id = member.member_id and
			event.organizer_id = organizer.organizer_id) as base) as score