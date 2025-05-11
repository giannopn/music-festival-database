/* QUERY 05 - Βρείτε τους νέους καλλιτέχνες (ηλικία < 30 ετών) που έχουν τις περισσότερες συμμετοχές σε φεστιβάλ;*/
with under_30 as (
	select a.artist_id, a.stage_name, count(distinct e.festival_id) as number_of_appearences from artist a 
	join performance p on (p.artist_id = a.artist_id)
	join event e on (e.event_id = p.event_id)
	where a.date_of_birth >= now() - '30 years'::interval 
	group by a.artist_id, a.stage_name
	order by 3 desc 
	),
max_cnt as (
    /* Μέγιστος αριθμός συμμετοχών */
    select MAX(number_of_appearences) AS top_cnt
    from   under_30
    )
select u30.stage_name, mx.top_cnt from under_30 u30
join max_cnt mx on mx.top_cnt = u30.number_of_appearences