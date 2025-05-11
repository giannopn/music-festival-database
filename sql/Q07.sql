/* QUERY 07 - Βρείτε ποιο φεστιβάλ είχε τον χαμηλότερο μέσο όρο εμπειρίας τεχνικού προσωπικού;*/
select f.name as festival_name, round(avg(s.experience_level_id),2) as avg_experience_level 
from event e 
join event_staff es on e.event_id = es.event_id 
join festival f on e.festival_id = f.festival_id 
join staff s on s.staff_id = es.staff_id 
join staff_category sc on sc.staff_category_id = s.staff_category_id 
where sc.name = 'Technical'
--where s.staff_category_id = 1
group by e.festival_id, f.name 
order by avg_experience_level
limit 1