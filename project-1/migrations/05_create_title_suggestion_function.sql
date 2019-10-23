CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE OR REPLACE FUNCTION title_suggestion(pattern VARCHAR) 
RETURNS TABLE(
	title TEXT,
	categories TEXT
) 
AS 
$$
SELECT title, summary FROM
(
    SELECT word_similarity(title, pattern) AS ts,
           word_similarity(summary, pattern) AS ss,
           title,
           summary
    FROM movie
    WHERE word_similarity(title, pattern) > 0.2 OR 
          word_similarity(summary, pattern) > 0.2
    ORDER BY ts, ss
) AS t; 
$$ 
LANGUAGE 'sql';