SELECT *
FROM
(
    SELECT pois.gid,
           pois.name,
           nature.gid,
           nature.name,
           ROUND(st_distance(pois.geom, nature.geom)) AS dist,
           RANK() OVER(PARTITION BY pois.gid, pois.name ORDER BY st_distance(pois.geom, nature.geom)) AS rank
    FROM pois, nature
    WHERE pois.fclass = 'hotel' AND
          nature.fclass = 'peak' AND
          pois.name IS NOT null
	ORDER BY pois.name, rank
) t
WHERE t.rank <= 3