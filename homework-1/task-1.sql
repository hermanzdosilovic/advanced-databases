SELECT
	film.title AS filmTitle,
    EXTRACT(MONTH FROM rental.rental_date) AS month,
    COUNT(*) AS cntMonth,
    SUM(COUNT(*)) OVER (PARTITION BY film.title ORDER BY EXTRACT(MONTH FROM rental.rental_date)) AS cntThisAndPrevMonth
FROM rental
	JOIN inventory
    	ON rental.inventory_id = inventory.inventory_id
    JOIN (SELECT *, UNNEST(string_to_array(title, ' ')) AS word FROM film) AS film
        ON inventory.film_id = film.film_id
WHERE levenshtein(lower(film.word), 'flintstons') <= 2
GROUP BY filmTitle, month
ORDER BY filmTitle, month
