---
layout: shell
---
{% comment %} 
  Creates a shell script to create social sharing cards.
  One card will include a play icon (script.py) and the other will not (script-no-play.py)
  See jekyll-script/create-cards.html for more details.
{% endcomment %}

{% comment %} Process all cards or just latest and future? {% endcomment %}
{% comment %} Setting located in _data/configs.yml {% endcomment %}
{%- assign use-latest-cards = site.data.configs.latest-share-cards-only -%}

{% comment %} Only create cards for future posts and the most current {% endcomment %}
{%- if use-latest-cards == true -%}
  {% comment %} Get future posts {% endcomment %}
  {%- assign posts = site.posts | where_exp: 'post', 'post.guest-details != nil' | where_exp: 'post', 'post.date >= site.time' -%}
  {%- for post in posts -%}
    {%- assign append = '' -%}
    {%- assign shell = 'python3 script.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}
  {%- for post in posts -%}
    {%- assign append = '-no-play-icon' -%}
    {%- assign shell = 'python3 script-no-play.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}

  {% comment %} Get latest active post {% endcomment %}
  {%- assign posts = site.posts | where_exp: 'post', 'post.guest-details != nil' | where_exp: 'post', 'post.date <= site.time' -%}
  {%- for post in posts limit: 1 offset: 0-%}
    {%- assign append = '' -%}
    {%- assign shell = 'python3 script.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}
  {%- for post in posts limit: 1 offset: 0-%}
    {%- assign append = '-no-play-icon' -%}
    {%- assign shell = 'python3 script-no-play.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}
{%- endif -%}

{% comment %} # Generate cards for all past, current, and future posts {% endcomment %}
{%- if use-latest-cards == false -%}
  {% comment %} Get future posts {% endcomment %}
  {%- assign posts = site.posts | where_exp: 'post', 'post.guest-details != nil' -%}
  {%- for post in posts -%}
    {%- assign append = '' -%}
    {%- assign shell = 'python3 script.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}
  {%- for post in posts -%}
    {%- assign append = '-no-play-icon' -%}
    {%- assign shell = 'python3 script-no-play.py ' -%}
    {%- include_relative jekyll-script/create-cards.html -%}
  {%- endfor -%}
{%- endif -%}
