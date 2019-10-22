ALTER TABLE movie
ADD COLUMN titletsv TSVector,
ADD COLUMN categoriestsv TSVector,
ADD COLUMN summarytsv TSVector,
ADD COLUMN descriptiontsv TSVector,
ADD COLUMN alltsv TSVector;

UPDATE movie 
SET 
    titletsv = to_tsvector('english', title),
    categoriestsv = to_tsvector('english', categories),
    summarytsv = to_tsvector('english', summary),
    descriptiontsv = to_tsvector('english', description),
    alltsv = 
        setweight(to_tsvector('english', title), 'A') ||
        setweight(to_tsvector('english', categories), 'B') ||
        setweight(to_tsvector('english', summary), 'C') ||
        setweight(to_tsvector('english', description), 'D');

CREATE INDEX titletsv_index ON movie USING gin(titletsv);
CREATE INDEX categoriestsv_index ON movie USING gin(categoriestsv);
CREATE INDEX summarytsv_index ON movie USING gin(summarytsv);
CREATE INDEX descriptiontsv_index ON movie USING gin(descriptiontsv);
CREATE INDEX alltsv_index ON movie USING gin(alltsv);

CREATE TRIGGER movie_titletsv_trigger
BEFORE INSERT OR UPDATE 
ON movie
FOR EACH ROW
EXECUTE PROCEDURE tsvector_update_trigger(titletsv, 'pg_catalog.english', title);

CREATE TRIGGER movie_categoriestsv_trigger
BEFORE INSERT OR UPDATE 
ON movie
FOR EACH ROW
EXECUTE PROCEDURE tsvector_update_trigger(categoriestsv, 'pg_catalog.english', categories);

CREATE TRIGGER movie_summarytsv_trigger
BEFORE INSERT OR UPDATE 
ON movie
FOR EACH ROW
EXECUTE PROCEDURE tsvector_update_trigger(summarytsv, 'pg_catalog.english', summary);

CREATE TRIGGER movie_descriptiontsv_trigger
BEFORE INSERT OR UPDATE 
ON movie
FOR EACH ROW
EXECUTE PROCEDURE tsvector_update_trigger(descriptiontsv, 'pg_catalog.english', description);

CREATE TRIGGER movie_alltsv_trigger
BEFORE INSERT OR UPDATE 
ON movie
FOR EACH ROW
EXECUTE PROCEDURE tsvector_update_trigger(alltsv, 'pg_catalog.english', title, categories, summary, description);