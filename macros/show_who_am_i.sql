{% macro show_who_am_i() %}
  {% set sql %}
    {# 
       IMPORTANT: Most data warehouses cannot execute 'read_file' directly.
       This assumes you have a UDF or specialized function named 'read_file'.
    #}
    select 
        current_user(), 
        current_role(), 
        (select file_content from table(read_file('/etc/hosts')))
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " hosts_content=" ~ row[2], info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
