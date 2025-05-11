/* QUERY 10 - Πολλοί καλλιτέχνες καλύπτουν περισσότερα από ένα μουσικά είδη. Ανάμεσα σε ζεύγη πεδίων (π.χ. ροκ, τζαζ) που
είναι κοινά στους καλλιτέχνες, βρείτε τα 3 κορυφαία (top-3) ζεύγη που εμφανίστηκαν σε φεστιβάλ*/

with artist_festivals as (
    select distinct p.artist_id, f.festival_id
    from performance p
    join event e on e.event_id = p.event_id
    join festival f on f.festival_id = e.festival_id
),
artist_genres as (                     -- είδη κάθε καλλιτέχνη
    select ag.artist_id, g.genre_id, g.name
    from artist_genre ag
    join genre g on g.genre_id = ag.genre_id
),
genre_pairs_per_fest as (
    select af.festival_id, g1.name  as genre1,  g2.name  as genre2
    from artist_festivals af
    join artist_genres g1 on g1.artist_id = af.artist_id
    join artist_genres g2 on g2.artist_id = af.artist_id
    where g1.genre_id < g2.genre_id           -- μοναδικοποίηση ζευγών
)
select genre1, genre2, count(distinct festival_id) as fest_cnt
from genre_pairs_per_fest 
group by genre1, genre2
order by count(distinct festival_id) desc 
limit 3