SELECT
	country.country AS country, COUNT(*) AS count
FROM country, (SELECT *, UNNEST(string_to_array(customer_list.address, ' ')) AS word FROM customer_list) AS address
WHERE country.country = address.country AND
      levenshtein(lower(address.word), 'avenija') <= 3
GROUP BY country.country
HAVING COUNT(*) >= 2;