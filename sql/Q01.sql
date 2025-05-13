/* QUERY 01
   Βρείτε τα έσοδα του φεστιβάλ, ανά έτος από την πώληση εισιτηρίων, λαμβάνοντας υπόψη όλες τις
   κατηγορίες εισιτηρίων και παρέχοντας ανάλυση ανά είδος πληρωμής.
*/

select f.name as festival_name, pm.name as payment_method, f.year,  SUM(tic.cost) as total_revenue from ticket tic
join event eve on (eve.event_id = tic.event_id)
join payment_method pm on (pm.payment_method_id = tic.payment_method_id)
join festival f on (f.festival_id=eve.festival_id)
group by  f.name, pm.name, f.year 
order by f.year 