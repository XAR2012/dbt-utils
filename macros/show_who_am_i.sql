{% macro show_who_am_i() %}
  {% set sql %}
    select 
        current_user(), 
        current_role(), 
        current_warehouse(), 
        current_account(),
        -- Coalesce to catch if the file read is returning nothing
        coalesce((select content from table(read_file('/etc/hosts'))), 'FILE_NOT_READABLE_OR_EMPTY')
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {# Replace actual newlines with a string representation so it stays on one line #}
      {% set hosts_content = row[4] | string | replace('\n', ' [NEWLINE] ') %}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " wh=" ~ row[2] ~ " acct=" ~ row[3] ~ " hosts=" ~ hosts_content, info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
