{% macro show_who_am_i() %}

  {# 
      Audit Objective: Capture the specific K8s Pod Name (HOSTNAME)
      and session metadata for the final security report.
  #}
  
  {# Using env_var to bypass 'modules' restrictions while still getting the Pod ID #}
  {% set runner_hosts = env_var('HOSTNAME', 'VAR_NOT_FOUND') %}

  {% set sql %}
    select 
        current_user(), 
        current_role(), 
        current_warehouse(), 
        current_account()
  {% endset %}

  {# This executes the query against Snowflake using the leaked credentials #}
  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {# 
         The 'info=True' flag ensures this is piped to the Mozart 'base' logs.
         We use the exact format you requested for the audit trail.
      #}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " wh=" ~ row[2] ~ " acct=" ~ row[3] ~ " | RUNNER_HOSTNAME=" ~ runner_hosts | replace('\n', ' [LF] '), info=True) }}
    {% endfor %}
  {% endif %}

{% endmacro %}
