SELECT railways.gid,
       ROUND(st_length(st_intersection(railways.geom, landuse.geom)))
FROM railways, landuse
WHERE landuse.fclass='forest' AND
	  st_intersects(railways.geom, landuse.geom);