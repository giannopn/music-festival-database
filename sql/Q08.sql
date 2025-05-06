/* QUERY 08 - Βρείτε το προσωπικό υποστήριξης που δεν έχει προγραμματισμένη εργασία σε συγκεκριμένη ημερομηνία;*/
select s.staff_id, s.first_name, s.last_name from staff s 
join staff_category sc ON s.staff_category_id = sc.staff_category_id 
where sc."name" = 'Support'
and s.staff_id not in (
	SELECT es.staff_id
	FROM event_staff es
	JOIN event e ON es.event_id = e.event_id
	WHERE DATE(e.start_timestamp) = '2017-06-01')
