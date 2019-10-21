SELECT 
	* 
FROM
    crosstab
    (
        $$
        SELECT
            staff.last_name::text AS employee,
            category.name::text AS category,
            COUNT(*)::int AS numOfRentals
        FROM film_category
            JOIN category
                ON film_category.category_id = category.category_id
            JOIN film
                ON film_category.film_id = film.film_id
            JOIN inventory
                ON film.film_id = inventory.film_id
            JOIN rental
                ON rental.inventory_id = inventory.inventory_id
            JOIN staff
                ON staff.staff_id = rental.staff_id
            WHERE category.name::TSVector @@ 'Comedy | Horror | Sports'::TSQuery AND
                  (
                      EXISTS (SELECT ts_debug.lexemes FROM ts_debug('english', film.description) WHERE ARRAY['empir', 'shark'] && ts_debug.lexemes) OR
                      EXISTS (SELECT ts_debug.lexemes FROM ts_debug('english', film.title) WHERE ARRAY['empir', 'shark'] && ts_debug.lexemes)
                  )
        GROUP BY employee, category
        ORDER BY employee, category
        $$,
        $$SELECT * FROM UNNEST(ARRAY['Comedy', 'Horror', 'Sports'])$$
    )
AS pivotTable (employee TEXT, Comedy TEXT, Horror TEXT, Sports TEXT)
ORDER BY employee