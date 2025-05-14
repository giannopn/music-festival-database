/* QUERY 04 */

/* Hash Join */
select a.artist_id, a.stage_name, round(avg(pr.artist_performance_rating),2) as avg_artist_performance_rating, round(avg(pr.overall_impression_rating),2) as avg_overall_impression_rating from artist a 
join performance p ON p.artist_id = a.artist_id 
join performance_rating pr on pr.performance_id = p.performance_id 
group by a.artist_id, a.stage_name 
order by artist_id asc

/*Sort & Hash Join*/
/*
with avg_performance_rating as (
	select pr.performance_id,  pr.artist_performance_rating , pr.overall_impression_rating 
	from performance_rating pr 
),
artist_performances as (
	select p.performance_id, p.artist_id, a.stage_name from performance p 
	join artist a ON a.artist_id = p.artist_id
)
select a.artist_id, a.stage_name, round(avg(apr.artist_performance_rating),2) as avg_artist_performance_rating, round(avg(apr.overall_impression_rating),2) as avg_overall_impression_rating from artist a 
join artist_performances ap on ap.artist_id = a.artist_id 
join avg_performance_rating apr on apr.performance_id = ap.performance_id
group by a.artist_id, a.stage_name
order by artist_id 
*/