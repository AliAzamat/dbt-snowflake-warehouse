-- A MACRO is a reusable SQL snippet — a function for your SQL, expanded
-- at COMPILE time by Jinja. Define a rule once, call it everywhere.
{% macro cents_to_dollars(column_name, precision=2) %}
    ROUND({{ column_name }} / 100.0, {{ precision }})
{% endmacro %}
