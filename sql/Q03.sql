/* QUERY 03 - Βρείτε ποιοι καλλιτέχνες έχουν εμφανιστεί ως warm up περισσότερες από 2 φορές στο ίδιο φεστιβάλ; */
select p.artist_id, a.stage_name, e.festival_id, f.name as festival_name, count(*) as warmup_count
from performance p
join event     e on p.event_id    = e.event_id
join festival  f on e.festival_id = f.festival_id
join artist    a on p.artist_id   = a.artist_id
where p.performance_type = 'Warm Up'
group by p.artist_id, a.stage_name, e.festival_id, f.name
having count(*) > 2
order by warmup_count desc;
