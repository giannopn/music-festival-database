/* QUERY 11 - Βρείτε όλους τους καλλιτέχνες που συμμετείχαν τουλάχιστον 5 λιγότερες φορές από τον καλλιτέχνη με τις
περισσότερες συμμετοχές σε φεστιβάλ.*/
with all_artist_participations as (
	select a.artist_id, a.stage_name, count(e.festival_id) as count_participations 
	from performance p 
	join artist a on a.artist_id = p.artist_id 
	join event e on e.event_id = p.event_id
	group by a.artist_id 
	order by 2 desc 
)
select a.artist_id, a.stage_name, arp.count_participations from all_artist_participations arp
join artist a on a.artist_id = arp.artist_id
where arp.count_participations <= (select max(arp2.count_participations) from all_artist_participations arp2) - 4
order by 3 desc 