/* QUERY 03 - Βρείτε ποιοι καλλιτέχνες έχουν εμφανιστεί ως warm up περισσότερες από 2 φορές στο ίδιο φεστιβάλ; */
select a.stage_name, count(p.artist_id) AS appearences, p.performance_type, e."name", e.festival_id 
from performance p 
join "event" e on (e.event_id = p.event_id)
join artist a on (a.artist_id= p.artist_id)
where p.performance_type = 'Warm Up'
group by p.artist_id, p.performance_type, e."name", e.festival_id, a.stage_name 
having count(p.artist_id)>=2