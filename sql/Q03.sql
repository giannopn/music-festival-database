/* QUERY 03 */

select f.name as festival_name, f.year, a.stage_name
from performance p
join event     e on p.event_id    = e.event_id
join festival  f on e.festival_id = f.festival_id
join artist    a on p.artist_id   = a.artist_id
where p.performance_type = 'Warm Up'
group by a.stage_name, f.name, f.year
having count(*) > 2