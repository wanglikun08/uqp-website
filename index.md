---
redirect_from:
  - home/
  - cive60008_21/
  - cive60008_21/week01/seminar1/
  - cive60008_22/
  - cive60008_22/assignments/1/
  - cive60008_22/assignments/2/
  - cive60008_22/week01/notebooks/
  - cive60008_22/week02/notebooks/
  - cive60008_22/week03/notebooks/
  - cive60008_22/week04/notebooks/
  - cive60008_22/week05/notebooks/
  - cive60008_22/week06/notebooks/
  - cive60008_22/week07/notebooks/
  - cive60008_22/week08/notebooks/
  - cive60008_22/week09/notebooks/
  - cive97129_23/assignments/1/
  - cive97129_23/assignments/2/
  - demo-pathfinding/
  - project/shift-project/
  - research/autonomy/
  - research/logistics/
  - tags/
  - tag/autonomy
  - teaching/
  - tf/
  - tf/60008_21/
  - wsds/
---


The Ultrafast Quantum Probe Lab at Zhejiang University undertakes research in surface and low dimensional quantum material systems, with focus on advanced scanning probe techniques to reach unprecedented spatial, temporal, and momentum resolutions.

Our group is led by [**Prof Likun Wang**](/members/angeloudis-p), and is affiliated with the **Institute of Condensed Matter Physics** of the **School of Physics** at **Zhejiang University**.

{% include section.html %}

#### Our work
{% include project-carousel.html %}

{% include section.html %}

#### Our news

{% include news-list.html style="simple" limit=5 prefix="home-" hide_hidden=true %}

{%
  include button.html
  link="news"
  text="View all news"
  icon="fa-solid fa-arrow-right"
  flip=true
  style="bare"
%}

{% include section.html %}

#### Our Themes

{% include list.html component="card" data="themes" filters="group: theme" style="small" %}

{% include section.html %}


#### Our publications

{% include list.html data="citations"  filters="group: featured" hideyear="true" component="citation"  %}

{%
  include button.html
  link="papers"
  text="All publications"
  icon="fa-solid fa-arrow-right"
  flip=true
  style="bare"
%}


{% capture text_team %}

Our team benefits from strong links with other labs within Zhejiang University, external collaborators, and industry partners. 

**Join us:** We welcome applications from talented researchers. Scholarships are available for qualified applicants.

{%
  include button.html
  link="team"
  text="Meet our team"
  icon="fa-solid fa-arrow-right"
  flip=true
  style="bare"
%}

{%
  include button.html
  link="apply"
  text="Join us"
  icon="fa-solid fa-arrow-right"
  flip=true
  style="bare"
%}

{% endcapture %}

{% include section.html %}

{%
  include feature.html
  image="images/img_team.jpg"
  link="team"
  title="Our team"
  style="bare"
  text=text_team
%}




{% include section.html %}

#### Our funders


{% capture col1 %}
<img src="images/funders/ukri.svg">
{% endcapture %}


{% include cols.html col1=col1 col2=col2 col3=col3 col4=col4%}