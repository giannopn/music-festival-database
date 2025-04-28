/* QUERY 05 - Βρείτε τους νέους καλλιτέχνες (ηλικία < 30 ετών) που έχουν τις περισσότερες συμμετοχές σε φεστιβάλ;*/
select a.stage_name, a.date_of_birth, count(e.festival_id) as festival_appearences --count(p.performance_id), e.festival_id
from artist a 
join performance p on (p.artist_id = a.artist_id)
join "event" e on (e.event_id = p.event_id)
where a.date_of_birth >= now() - '30 years'::interval
group by a.stage_name, a.date_of_birth
order by festival_appearences desc 