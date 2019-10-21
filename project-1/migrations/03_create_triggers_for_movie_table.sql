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