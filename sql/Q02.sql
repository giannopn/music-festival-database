/* QUERY 02 - Βρείτε όλους τους καλλιτέχνες που ανήκουν σε ένα συγκεκριμένο μουσικό είδος με ένδειξη αν συμμετείχαν σε
εκδηλώσεις του φεστιβάλ για το συγκεκριμένο έτος ; */
-- Needs to be re-checked

select p."name", p.artist_id, a.stage_name, e.event_id, p.performance_type, g."name", f."name", f."year" 
from performance p 
join artist a on (a.artist_id = p.artist_id)
join artist_genre ag ON (a.artist_id = ag.artist_id)
join genre g on (g.genre_id= ag.genre_id)
join "event" e on (e.event_id=p.event_id)
join festival f ON (f.festival_id = e.festival_id)
where p.performance_type = <performance_type> --replace with 'Warm Up', 'Main' 
and g.name = <"name"> --'Rock', 'Jazz'
and f.year = <year> -- 2020, 2021