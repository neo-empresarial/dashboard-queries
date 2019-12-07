CREATE OR REPLACE FUNCTION first_of_week(date) returns date AS $$
  SELECT ($1::date-(extract('dow' FROM $1::date)*interval '1 day'))::date;
$$ LANGUAGE SQL STABLE STRICT;

CREATE OR REPLACE FUNCTION weeks_in_range(date,date) returns int AS $$
  SELECT ((first_of_week($2)-first_of_week($1))/7)+1
$$ LANGUAGE SQL STABLE STRICT;
