/* QUERY 10 - Πολλοί καλλιτέχνες καλύπτουν περισσότερα από ένα μουσικά είδη. Ανάμεσα σε ζεύγη πεδίων (π.χ. ροκ, τζαζ) που
είναι κοινά στους καλλιτέχνες, βρείτε τα 3 κορυφαία (top-3) ζεύγη που εμφανίστηκαν σε φεστιβάλ*/

with pairs as (
  select
    p1.event_id,
    p1.artist_id as a1,
    p2.artist_id as a2
  from performance as p1
  join performance as p2
    on p1.event_id   = p2.event_id
   and p1.artist_id  < p2.artist_id
)
select ar1.stage_name as artist_a, ar2.stage_name as artist_b, count(*) as events_played_together
from pairs as p
join artist as ar1 on p.a1 = ar1.artist_id
join artist as ar2 on p.a2 = ar2.artist_id
group by ar1.stage_name, ar2.stage_name
order by events_played_together desc
limit 3;
