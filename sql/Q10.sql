/* QUERY 10 - Πολλοί καλλιτέχνες καλύπτουν περισσότερα από ένα μουσικά είδη. Ανάμεσα σε ζεύγη πεδίων (π.χ. ροκ, τζαζ) που
είναι κοινά στους καλλιτέχνες, βρείτε τα 3 κορυφαία (top-3) ζεύγη που εμφανίστηκαν σε φεστιβάλ*/
--needs correction

WITH pairs AS (
  SELECT
    p1.event_id,
    p1.artist_id AS a1,
    p2.artist_id AS a2
  FROM performance AS p1
  JOIN performance AS p2
    ON p1.event_id   = p2.event_id
   AND p1.artist_id  <  p2.artist_id     -- if you also want to include bands, you could COALESCE(artist_id, band_id)
)
SELECT
  ar1.stage_name  AS artist_a,
  ar2.stage_name  AS artist_b,
  COUNT(*)        AS events_played_together
FROM pairs AS p
JOIN artist AS ar1 ON p.a1 = ar1.artist_id
JOIN artist AS ar2 ON p.a2 = ar2.artist_id
GROUP BY ar1.stage_name, ar2.stage_name
ORDER BY events_played_together DESC
LIMIT 3;