/* QUERY 13 */

with festival_per_continent as (
	select f.festival_id, c.name as continent
	from festival f 
	join location l on l.location_id = f.location_id 
	join continent c on c.continent_id =l.continent_id),
artist_per_festival as (
	select a.artist_id, e.festival_id from artist a 
	join performance p on p.artist_id = a.artist_id 
	join event e on e.event_id = p.event_id 
)
select a.artist_id, a.real_name
from festival_per_continent fpc
join artist_per_festival apf on  apf.festival_id = fpc.festival_id
join artist a on a.artist_id = apf.artist_id
group by a.artist_id
having count(distinct fpc.continent)>= 3