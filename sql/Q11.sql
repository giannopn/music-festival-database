/* QUERY 11 - Βρείτε όλους τους καλλιτέχνες που συμμετείχαν τουλάχιστον 5 λιγότερες φορές από τον καλλιτέχνη με τις
περισσότερες συμμετοχές σε φεστιβάλ.*/
with festival_participations as (
	select a.artist_id, a.stage_name, count(DISTINCT e.festival_id) as appearences
	from artist a 
	join performance p on p.artist_id = a.artist_id 
	join event e on e.event_id = p.event_id 
	group by a.artist_id 
	order by 1, 2
)
select fp.artist_id, fp.stage_name, fp.appearences as number_of_appearences
from festival_participations fp
where fp.appearences < (select max(fp2.appearences) from  festival_participations fp2) - 4
