CREATE TABLE search_history (
	query TEXT,
	created_at TIMESTAMP
);

CREATE OR REPLACE FUNCTION set_created_at_in_search_history()
RETURNS TRIGGER
AS
$$
BEGIN
	NEW.created_at := now()::TIMESTAMP;
	RETURN NEW;
END
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER search_history_trigger
BEFORE INSERT ON search_history
FOR EACH ROW
EXECUTE PROCEDURE set_created_at_in_search_history();