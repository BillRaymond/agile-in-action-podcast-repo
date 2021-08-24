---
layout: shell
---

{% comment %} 
TEMPLATE
1 guest:
  python3 share-card-creator.py --title "A day in the life of a Product Manager" --photo "guest/albert.jpg" --guests "Albert Chen" --card_file "card1.png" 
2 guests:
  python3 share-card-creator.py --title "The power of an agile operating model in the manufacturing supply chain" --photo "guest/spady.jpeg,guest/joshua-hinkel.jpg" --guests "Richard Spady and Joshua Hinkel" --card_file "card2.png" 
3 guests:
  python3 share-card-creator.py --title "Adapting agile to human resources" --photo "guest/natal-head-shot.jpg,guest/farlik.png,guest/maarten.jpeg" --guests "Natal Dank, Dr. John Farlick, and Maarten Dalmjin" --card_file "card3.png"
4 guests
  python3 share-card-creator.py --title "Transform Your Conversations, Transform Your Culture" --photo "guest/d-squirrel.jpg,guest/j-Fredrick.jpg,guest/william-morgan-headshot.jpg,guest/loretta.jpg" --guests "Douglas Squirrel, Jeffrey Fredrick, Jesse Fewell, Loretta Harland, and Manuel Pais" --card_file "card4.png"
MISC
  python3 share-card-creator.py --title "Labore nulla tempor culpa non aliquip occaecat incididunt Velit reprehenderit Incididunt dolor sit sint laboris id. nostrud deserunt quis esse esse quis duis qui ad." --photo "guest/d-squirrel.jpg,guest/j-Fredrick.jpg,guest/william-morgan-headshot.jpg,guest/loretta.jpg" --guests "Douglas Squirrel, Jeffrey Fredrick, Jesse Fewell, Loretta Harland, and Manuel Pais" --card_file "card5.png"
{% endcomment %}

{% comment %}
Structure:
python3 share-card-creator.py 
  --title "Transform Your Conversations, Transform Your Culture"
  --photo "guest/d-squirrel.jpg,guest/j-Fredrick.jpg,guest/william-morgan-headshot.jpg,guest/loretta.jpg"
  --guests "Douglas Squirrel, Jeffrey Fredrick, Jesse Fewell, Loretta Harland, and Manuel Pais"
  --card_file "card4.png"
{% endcomment %}

{% comment %} Start the shell command {% endcomment %}
{% comment %} Only get posts with a guest/photo structure {% endcomment %}
{%- assign posts = site.posts | where_exp: 'post', 'post.guest-details != nil' -%}
{%- assign switch = '&#45;&#45;' -%}
{%- for post in posts -%}
  {% comment %} create the python script element {% endcomment %}
  {%- assign shell = 'python3 script.py ' -%}
  {% comment %} Add the title to the shell command {% endcomment %}
  {%- assign title = post.title -%}
  {%- assign shell = shell | append: switch | append: 'title=&apos;' | append: title | append: '&apos; ' -%}

  {% comment %} Add the photo files and guest photos to the shell command {% endcomment %}
  {%- assign shell = shell | append: photo -%}
  {%- assign photo-text = ' ' | append: switch | append: 'photo=&apos;' -%}
  {%- assign guest-text = ' ' | append: switch | append: 'guests=&apos;' -%}

  {% comment %} Create the rest of the shell script {% endcomment %}
  {%- assign guest-details = post.guest-details -%}
  {%- assign total-guests = guest-details.size -%}
  {%- for guest-detail in guest-details -%}
<<<<<<< HEAD:share-card-creator/shell.sh
    {%- assign guest-name = guest-detail.name_of_person -%}
    {%- assign guest-photo = guest-detail.guest_photo -%}
=======
    {%- assign guest-name = guest-detail.guest-name -%}
    {%- assign guest-photo = guest-detail.guest-photo | relative_url -%}
>>>>>>> 49cc710... rename front matter for new posts:social-sharing-card-creator/shell.zshrc

    {% comment %} You can only put 4 guests on the social sharing card {% endcomment %}
    {%- assign index-id = forloop.index -%}
    {%- if index-id == 5 -%}
      {% break %}
    {%- endif -%}

    {% comment %} If there is only one guest, just add the guest details {% endcomment %}
    {%- if total-guests == 1  -%}
      {%- assign photo-text = photo-text | append: '..' | append: guest-photo -%}
      {%- assign guest-text = guest-text | append: guest-name -%}
    {%- endif -%}

    {% comment %} If there are two guests, add a comma or the word "and" for the guests {% endcomment %}
    {%- if total-guests == 2 -%}
      {%- if index-id == 2 -%}
        {%- assign photo-text = photo-text | append: ',' -%}
        {%- assign guest-text = guest-text | append: ' and ' -%}
      {%- endif -%}
      {%- assign photo-text = photo-text | append: '..' | append: guest-photo -%}
      {%- assign guest-text = guest-text | append: guest-name -%}
    {%- endif -%}

    {% comment %} If there are three guests, add a comma or the word ", and" for the guests {% endcomment %}
    {%- if total-guests == 3 -%}
      {%- if index-id == 2 -%}
        {%- assign photo-text = photo-text | append: ','-%}
        {%- assign guest-text = guest-text | append: ', ' -%}
      {%- endif -%}
      {%- if index-id == 3 -%}
        {%- assign photo-text = photo-text | append: ','-%}
        {%- assign guest-text = guest-text | append: ', and ' -%}
      {%- endif -%}
      {%- assign photo-text = photo-text | append: '..' | append: guest-photo -%}
      {%- assign guest-text = guest-text | append: guest-name -%}
    {%- endif -%}

    {% comment %} If there are four guests, add a comma or the word ", and" for the guests {% endcomment %}
    {%- if total-guests == 4 -%}
      {%- if index-id == 2 -%}
        {%- assign photo-text = photo-text | append: ',' -%}
        {%- assign guest-text = guest-text | append: ', ' -%}
      {%- endif -%}
      {%- if index-id == 3 -%}
        {%- assign photo-text = photo-text | append: ',' -%}
        {%- assign guest-text = guest-text | append: ', ' -%}
      {%- endif -%}
      {%- if index-id == 4 -%}
        {%- assign photo-text = photo-text | append: ',' -%}
        {%- assign guest-text = guest-text | append: ', and ' -%}
      {%- endif -%}
      {%- assign photo-text = photo-text | append: '..' | append: guest-photo -%}
      {%- assign guest-text = guest-text | append: guest-name -%}
    {%- endif -%}

    {% comment %} Finalize the shell command {% endcomment %}
    {%- if index-id == total-guests -%}
      {%- assign shell = shell | append: photo-text | append: '&apos;' -%}
      {%- assign shell = shell | append: guest-text | append: '&apos;' -%}
      {%- assign card-filename = post.path | split: '/' | last | split: '.' | first | append: '.png' -%}
      {%- assign card-filename = card-filename | prepend: '../uploads/' -%}
      {%- assign shell = shell | append: ' ' | append: switch | append: 'card_file=&apos;' | append: card-filename | append: '&apos;' -%}
{% capture final-shell %}
{{ shell }}
{% endcapture %}
{{ final-shell }}
    {%- endif -%}        
  {%- endfor -%}
{%- endfor -%}