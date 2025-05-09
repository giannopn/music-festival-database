/* QUERY 14 - Βρείτε ποια μουσικά είδη είχαν τον ίδιο αριθμό εμφανίσεων σε δύο συνεχόμενες χρονιές με τουλάχιστον 3
εμφανίσεις ανά έτος;*/
with perf_genre as (-- ομαδοποίηση εμφανίσεων ανά είδος για τους artists
  select p.performance_id, f.year as festival_year, ag.genre_id
  from performance p
  join event e  on p.event_id = e.event_id
  join festival f  on e.festival_id=f.festival_id
  join artist_genre ag on p.artist_id=ag.artist_id
  union all
  select p.performance_id, f.year as festival_year, bg.genre_id
  from performance p
  join event e  on p.event_id = e.event_id
  join festival f  on e.festival_id = f.festival_id
  join band_genre bg on p.band_id = bg.band_id
),
genre_year_counts as ( -- εμφανίσεις είδος ανά έτος
  select genre_id, festival_year, count(*) as appearances
  from perf_genre
  group by genre_id, festival_year
)
select g.name as genre_name, g1.festival_year  as year1, g2.festival_year  as year2, g1.appearances as appearances_per_year
from genre_year_counts g1
join genre_year_counts g2
  on g1.genre_id= g2.genre_id
 and g2.festival_year= g1.festival_year + 1
 and g2.appearances= g1.appearances
join genre g
  on g.genre_id=g1.genre_id
where g1.appearances >= 3
order by g.name, g1.festival_year;
