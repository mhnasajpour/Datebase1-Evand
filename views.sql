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