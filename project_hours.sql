SELECT
	SUM(EXTRACT(EPOCH FROM (te.end::timestamp - te.start::timestamp))) / 3600 duration,
	p.name
FROM
	time_entry te
	LEFT JOIN project p ON project_id = p.id
	LEFT JOIN (
		SELECT
			*
		FROM
			member [[ where {{members}} ]]) m ON member_id = m.id
	LEFT JOIN (
		SELECT
			*
		FROM
			client [[ where {{clients}} ]]) c ON client_id = c.id
WHERE
	te.start >= (start_date)
	AND te.end <= (end_date)
	AND m.acronym IS NOT NULL
	AND c.name IS NOT NULL
GROUP BY
	p.name
ORDER BY
	duration DESC
