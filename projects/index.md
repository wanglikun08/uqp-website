---
title: Projects
nav:
  order: 2
---

# Research Projects

We develop computational models for transportation and infrastructure systems. Our research uses machine learning and optimisation methods, with applications in autonomous vehicles, freight logistics, maritime transport, and infrastructure management.

Our projects range from fundamental research to applications through industry collaborations.

{% include project-tags.html %}

{% for project in site.data.projects %}
    {% include project-card.html project=project %}
{% endfor %}


{% capture content %}
For a list of recent research outputs, visit our [publications page](/papers/).
{% endcapture %}

{% include more-info.html 
  content=content 
  icon="fa-solid fa-file-lines" 
  color="#0A66C2" 
%}