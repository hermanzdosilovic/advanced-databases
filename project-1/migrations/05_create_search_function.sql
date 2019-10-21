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
    WHERE titletsv @@ to_tsquery('english', $1) OR 
		  categoriestsv @@ to_tsquery('english', $1) OR
		  summary @@ to_tsquery('english', $1) OR
	      descriptiontsv @@ to_tsquery('english', $1)
$$ 
LANGUAGE 'sql';