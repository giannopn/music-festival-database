/* QUERY 08
   Βρείτε το προσωπικό υποστήριξης που δεν έχει προγραμματισμένη εργασία σε συγκεκριμένη ημερομηνία;
*/

select s.staff_id, s.first_name, s.last_name from staff s 
join staff_category sc ON s.staff_category_id = sc.staff_category_id 
where sc.name = 'Support'
and s.staff_id not in (
	select es.staff_id
	from event_staff es
	join event e on es.event_id = e.event_id
	where DATE(e.start_timestamp) = '2015-04-24')
order by s.last_name, s.first_name