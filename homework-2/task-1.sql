WITH RECURSIVE employees(staff_id, last_name, first_name, address_id, store_id, employee_id) AS
(
	SELECT staff_id, last_name, first_name, address_id, store_id, staff_id FROM staff

	UNION

	SELECT employees.staff_id, employees.last_name, employees.first_name, employees.address_id, employees.store_id, staff.staff_id
	FROM employees, staff
	WHERE employees.employee_id = staff.sup_staff_id
)
SELECT
	rank() OVER(ORDER BY SUM(amount) DESC) AS rankCompany,
	rank() OVER(PARTITION BY country.country_id ORDER BY SUM(amount) DESC) AS rankCountry,
    country.country,
	employees.staff_id,
	employees.last_name,
	employees.first_name,
	SUM(amount)
FROM employees, rental, payment, address, city, country
WHERE employees.employee_id = rental.staff_id AND
      rental.rental_id = payment.rental_id AND
      employees.address_id = address.address_id AND
      address.city_id = city.city_id AND
      city.country_id = country.country_id
GROUP BY country.country_id, country, employees.staff_id, employees.last_name, employees.first_name
ORDER BY rankCompany, rankCountry;