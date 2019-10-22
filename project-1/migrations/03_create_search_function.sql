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
           ts_headline(title, websearch_to_tsquery('english', $1)),
		   ts_headline(categories, websearch_to_tsquery('english', $1)),
		   ts_headline(summary, websearch_to_tsquery('english', $1)),
           ts_headline(description, websearch_to_tsquery('english', $1))
    FROM movie
	WHERE alltsv @@ websearch_to_tsquery('english', $1)
$$ 
LANGUAGE 'sql';