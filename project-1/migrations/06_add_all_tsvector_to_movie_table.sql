ALTER TABLE movie
ADD COLUMN alltsv TSVector;

UPDATE movie 
SET 
    alltsv = 
        setweight(to_tsvector('english', title), 'A') ||
        setweight(to_tsvector('english', categories), 'B') ||
        setweight(to_tsvector('english', summary), 'C') ||
        setweight(to_tsvector('english', description), 'D');

CREATE INDEX alltsv_index ON movie USING gin(alltsv);