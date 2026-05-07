{% macro show_who_am_i() %}
  {% set sql %}
    select current_user(), current_role(), current_warehouse(), current_account()
  {% endset %}
  {% set results = run_query(sql) %}
  {% if execute %}
    {% for row in results %}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " wh=" ~ row[2] ~ " acct=" ~ row[3], info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}

