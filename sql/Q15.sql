/* QUERY 15
Βρείτε τους top-5 επισκέπτες που έχουν δώσει συνολικά την υψηλότερη βαθμολόγηση σε ένα καλλιτέχνη. (όνομα
επισκέπτη, όνομα καλλιτέχνη και συνολικό σκορ βαθμολόγησης);*/

with visitor_artist_scores as (
  select pr.visitor_id, p.artist_id,
    sum(coalesce(pr.artist_performance_rating, 0)+coalesce(pr.sound_lighting_rating, 0) + coalesce(pr.stage_presence_rating,0)+ coalesce(pr.organization_rating,0) + coalesce(pr.overall_impression_rating, 0)) as total_score
  from performance_rating pr
  join performance p on pr.performance_id = p.performance_id
  where p.artist_id is not null
  group by pr.visitor_id, p.artist_id
)
select
  concat(v.first_name,' ', v.last_name) as visitor_name,
  a.stage_name as stage_name,
  vas.total_score
from visitor_artist_scores vas
join visitor v on vas.visitor_id = v.visitor_id
join artist  a on vas.artist_id  = a.artist_id
order by vas.total_score desc
limit 5