include:
{% if pillar.get('git', {}).get('install_from_source') %}  
  - git.source
{% elif pillar.get('git', {}).get('install_from_gitrepo') %}
  - git.gitrepo
{% else %}
  - git.package
{% endif %}
