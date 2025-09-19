/* QUERY 07 */

select f.name as festival_name, round(avg(s.experience_level_id),2) as avg_experience_level 
from event e 
join event_staff es on e.event_id = es.event_id 
join festival f on e.festival_id = f.festival_id 
join staff s on s.staff_id = es.staff_id 
join staff_category sc on sc.staff_category_id = s.staff_category_id 
where sc.name = 'Technical'
group by e.festival_id, f.name
order by avg_experience_level
limit 1