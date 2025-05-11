/* QUERY 09 - Βρείτε ποιοι επισκέπτες έχουν παρακολουθήσει τον ίδιο αριθμό παραστάσεων σε διάστημα ενός έτους με
περισσότερες από 3 παρακολουθήσεις;*/
with visitors_events_per_year as (
	select f.year, t.visitor_id, count(*) as freq from event e 
	join festival f on f.festival_id = e.festival_id 
	join ticket t ON t.event_id = e.event_id 
	where t.used = true 
	group by f.year, t.visitor_id 
	having count(*)>3
	order by f.year, t.visitor_id asc
)
select concat(v1.first_name, ' ', v1.last_name) visitor_1, concat(v2.first_name, ' ', v2.last_name) visitor_2, vpy1.year, vpy1.freq 
from visitors_events_per_year vpy1
join visitors_events_per_year vpy2 on vpy1.year = vpy2.year and vpy1.freq=vpy2.freq and vpy1.visitor_id<vpy2.visitor_id
join visitor v1 on vpy1.visitor_id = v1.visitor_id 
join visitor v2 on vpy2.visitor_id = v2.visitor_id 
order by v1.visitor_id, year 