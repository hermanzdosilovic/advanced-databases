CREATE OR REPLACE FUNCTION movie_search(pattern VARCHAR) 
RETURNS TABLE(
	movieid INTEGER, 
	title TEXT,
	categories TEXT,
	summary TEXT,
	description TEXT,
	rank FLOAT4
) 
AS 
$$
	INSERT INTO search_history (query) VALUES ($1);

    SELECT movieID,
           ts_headline(title, websearch_to_tsquery('english', $1)),
		   ts_headline(categories, websearch_to_tsquery('english', $1)),
		   ts_headline(summary, websearch_to_tsquery('english', $1)),
           ts_headline(description, websearch_to_tsquery('english', $1)),
		   ts_rank(ARRAY[0.1, 0.2, 0.4, 1.0], alltsv, websearch_to_tsquery('english', $1)) AS rank
    FROM movie
	WHERE alltsv @@ websearch_to_tsquery('english', $1)
	ORDER BY rank DESC
$$ 
LANGUAGE 'sql';