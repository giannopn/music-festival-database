/* QUERY 07 - Βρείτε ποιο φεστιβάλ είχε τον χαμηλότερο μέσο όρο εμπειρίας τεχνικού προσωπικού;*/
select e.festival_id, round(avg(s.experience_level_id),2) as avg_experience_level, count(distinct s.staff_id) as number_of_technical_staff 
from "event" e 
join event_staff es on e.event_id = es.event_id 
join staff s on s.staff_id = es.staff_id 
join staff_category sc on sc.staff_category_id = s.staff_category_id 
where sc."name" = 'Technical'
--where s.staff_category_id = 1
group by festival_id 
order by avg_experience_level, number_of_technical_staff asc
limit 1