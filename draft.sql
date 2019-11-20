WITH semester_dates (
s_begin,
s_end
) AS (
values(timestamp '08-05-2019',
timestamp '12-11-2019')
),
member_ha AS (
values(((20) * (EXTRACT(days FROM ((now() - interval '1 week') - (
SELECT
s_begin FROM semester_dates))) / 7)::int))
),
semester_week_start AS (
SELECT
generate_series(to_date('2019' || EXTRACT(week FROM (
SELECT
s_begin FROM semester_dates)),
'iyyyiw'),
to_date('2019' || EXTRACT(week FROM (
SELECT
s_end FROM semester_dates)),
'iyyyiw'),
'1 week'::interval)::date::varchar weeks
)
SELECT
*
FROM
semester_week_start

SELECT
*
FROM
members_week_hours (TO_DATE('2019-08-05', 'YYYY-MM-DD'));

CREATE FUNCTION members_week_hours (week_start varchar)
RETURNS SETOF RECORD
AS $$
BEGIN
RETURN QUERY EXECUTE format('SELECT
  m.acronym, hours_to_ha (SUM(EXTRACT(EPOCH FROM (te.end - te.start))) / 3600) hours FROM time_entry te
  JOIN member m ON te.member_id = m.id
  JOIN "client" c ON te.client_id = c.id
  WHERE
  date_trunc(''week'', te. "start") = date_trunc(''week'', TO_DATE(%L, ''YYYY-MM-DD''))
  GROUP BY
  m.acronym', week_start);
END;
$$
LANGUAGE 'plpgsql';

