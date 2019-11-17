SELECT
	pois.gid,
    pois.name,
    COUNT(*)
FROM pois, pois AS pois2
WHERE pois.fclass='hotel' AND
      pois2.fclass='restaurant' AND
      st_distance(pois.geom, pois2.geom) <= 100
GROUP BY pois.gid, pois.name
HAVING COUNT(*) >= 10
ORDER BY COUNT(*) DESC, pois.gid ASC;