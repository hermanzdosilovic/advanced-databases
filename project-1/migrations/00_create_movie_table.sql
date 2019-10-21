CREATE TABLE movie (
    movieid SERIAL PRIMARY KEY,
    title CHARACTER VARYING(255),
    categories CHARACTER VARYING(255),
    summary TEXT,
    description TEXT
);