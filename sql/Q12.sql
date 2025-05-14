/* QUERY 12
   Βρείτε το προσωπικό που απαιτείται για κάθε ημέρα του φεστιβάλ, παρέχοντας ανάλυση
   ανά κατηγορία (τεχνικό προσωπικό ασφαλείας, βοηθητικό προσωπικό);
*/


with festival_per_day as( --festival per day
	select e.festival_id, date(start_timestamp) as running_date, e.event_id from event e 
	where festival_id = 1
	union
	select e.festival_id, date(end_timestamp) as running_date, e.event_id from event e 
	where festival_id = 1
)
select fpd.festival_id, fpd.running_date as festival_day, sc.name as staff_category
, count(sc.staff_category_id) as number_of_staff_employeed
from festival_per_day fpd
join event_staff es on es.event_id = fpd.event_id
join staff s on s.staff_id = es.staff_id 
join staff_category sc on sc.staff_category_id = s.staff_category_id 
group by fpd.festival_id, fpd.running_date, sc.name
order by fpd.running_date asc