---
title: Contact
nav:
  order: 9
---

# Contact

{% capture contacts_col1 %}

**General Enquiries (Director)**<br>
Prof Panagiotis Angeloudis<br>
Email: <a href="mailto:p.angeloudis@imperial.ac.uk">p.angeloudis@imperial.ac.uk</a>

**Lab Facilities**<br>
Dr Felix Feng<br>
Email: <a href="mailto:y.feng19@imperial.ac.uk">y.feng19@imperial.ac.uk</a><br>

{% endcapture %}

{% capture contacts_col2 %}

**Scholarship Enquiries**<br>
Departmental Research Office<br>
Email: <a href="mailto:civilphdadmin@imperial.ac.uk">civilphdadmin@imperial.ac.uk</a>

**MSc & Education Enquiries**<br>
Ms Maya Mistry<br>
Email: <a href="mailto:m.mistry@imperial.ac.uk">m.mistry@imperial.ac.uk</a><br>

{% endcapture %}

{% include cols.html col1=contacts_col1 col2=contacts_col2 %}

For information on joining our research group, please visit our [recruitment page](/apply/).

{% include section.html %}

## Getting Here

{% capture address_col %}

### Our address

Our facilities are located at the Skempton Building, in the South Kensington campus of Imperial College London.

<a href="https://maps.app.goo.gl/ntx3Jk8TLoVGfpAi8" target="_blank" rel="noopener noreferrer">
Skempton Building <br>
Imperial College London <br>
SW7 2AZ, London
</a>

{% endcapture %}

{% capture map_col %}

{%
  include figure.html
  image="images/map.png"
  link="https://maps.app.goo.gl/ntx3Jk8TLoVGfpAi8"
  new_tab=true
%}

{% endcapture %}

{% include cols.html col1=address_col col2=map_col %}

### By Underground (Tube)
The nearest station is **South Kensington** (Piccadilly, Circle, and District lines). From the station, the campus is a 5-minute walk. Follow the subway signposted to the museums or walk north up Exhibition Road. The Skempton Building is adjacent to the Science Museum.

### From Major Transport Hubs

**Heathrow Airport:** Take the Piccadilly Line directly to South Kensington (approximately 50 minutes).

**Gatwick Airport:** Take a train to Victoria station (40 minutes), then the Circle or District Line (westbound) to South Kensington.

**St Pancras International / King's Cross:** Take the Piccadilly Line to South Kensington.

### By Car
Parking at South Kensington campus is severely restricted. Street parking is limited to pay-and-display meters for short periods. We recommend using public transport.

{% include section.html %}

{% capture col1 %}

{%
  include figure.html
  image="images/photos/skempton.jpg"
  caption="Skempton Building"
%}

{% endcapture %}

{% capture col2 %}

{%
  include figure.html
  image="images/photos/imperial.jpg"
  caption="South Kensington Campus"
%}

{% endcapture %}

{% include cols.html col1=col1 col2=col2 %}

