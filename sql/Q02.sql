/* QUERY 02 */

select distinct a.stage_name, 
case 
	when g."name" = 'Pop' 
    then 'appearred'
	else 'not appearred'
end as appeared
from performance p 
join artist a on (a.artist_id = p.artist_id)
join artist_genre ag ON (a.artist_id = ag.artist_id)
join genre g on (g.genre_id= ag.genre_id)
join "event" e on (e.event_id=p.event_id)
join festival f ON (f.festival_id = e.festival_id)
where f.year = 2014
order by 1