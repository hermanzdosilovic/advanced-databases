WITH RECURSIVE employees(staff_id, last_name, first_name, employee_id) AS
(
	SELECT staff_id, last_name, first_name, staff_id FROM staff

	UNION

	SELECT employees.staff_id, employees.last_name, employees.first_name, staff.staff_id
	FROM employees, staff
	WHERE employees.employee_id = staff.sup_staff_id
)
SELECT employees.staff_id, last_name, first_name, COUNT(*)
FROM employees, rental
WHERE rental.staff_id = employees.employee_id
GROUP BY employees.staff_id, last_name, first_name;