{% set git = pillar.get('git', {}) -%}
{% set version = git.get('version', '2.4.7') -%}
{% set gitrepo = git.get('git_repo', 'https://github.com/git/git.git') -%}
{% set source = git.get('source_root', '/usr/local/src') -%}

get-gitrepo:
  pkg.installed:
    - names:
    {% if grains['os_family'] == 'Debian' %}
      - git
      - libcurl4-openssl-dev
      - libexpat1-dev
      - gettext
      - libz-dev
      - libssl-dev
      - build-essential
    {% elif grains['os_family'] == 'RedHat' %}
      - git
      - gcc
      - make
      - libcurl-devel
      - expat-devel
      - gettext-devel
      - openssl-devel
      - zlib-devel
      - perl-ExtUtils-MakeMaker
    {% endif %}
  git.latest:
    - name: {{ gitrepo }}
    - rev: v{{ version }}
    - target: {{ source + '/git' }}
    - require:
      - pkg: get-gitrepo

git-compile:
  cmd.wait:
    - cwd: {{ source + '/git' }}
    - name: make configure && ./configure --prefix=/usr/local && make all && make install
    - watch:
      - git: get-gitrepo
    - require:
      - git: get-gitrepo
