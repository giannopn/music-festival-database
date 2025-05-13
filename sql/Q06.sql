/* QUERY 06
   Για κάποιο επισκέπτη, βρείτε τις παραστάσεις που έχει παρακολουθήσει και το μέσο όρο
   της αξιολόγησης του, ανά παράσταση.
*/

explain(
	select p.performance_id, p.name, 
	ROUND( (pr.artist_performance_rating + pr.sound_lighting_rating + pr.stage_presence_rating + pr.organization_rating + pr.overall_impression_rating) / 5.0 , 2)  
	from performance p 
	join performance_rating pr on pr.performance_id = p.performance_id 
	where pr.visitor_id = 2
)

--Second
explain(
WITH
  average_ratings AS (
    SELECT pr.performance_id,
      ROUND( (pr.artist_performance_rating + pr.sound_lighting_rating + pr.stage_presence_rating + pr.organization_rating + pr.overall_impression_rating) / 5.0 , 2) as average_rating
    FROM performance_rating pr
    WHERE pr.visitor_id = 2
    ORDER BY performance_id
  ),
  performance_sorted AS (
    select performance_id, name FROM performance
    ORDER BY performance_id
  )
select ps.name AS performance_name,
  ar.average_rating
FROM average_ratings ar
JOIN performance_sorted ps ON ar.performance_id = ps.performance_id
)