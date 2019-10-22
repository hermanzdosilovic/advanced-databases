CREATE FUNCTION movie_search(pattern VARCHAR) 
RETURNS TABLE(
	movieid INTEGER, 
	title TEXT,
	categories TEXT,
	summary TEXT,
	description TEXT
) 
AS 
$$
    SELECT movieID,
           title,
		   categories,
		   summary,
           description
    FROM movie
	WHERE alltsv @@ plainto_tsquery('english', $1)
$$ 
LANGUAGE 'sql';