---
author: humbertohp
description: "One of the design principles for Data Mesh is to reuse the existing data products. Every new data product needs one or more data sources. These data sources can be other data products or external data sources."
ms.author: humberh
ms.service: solutions-playbook
ms.topic: conceptual
title: "The Rise of Governance"
---

# The rise of Governance

Reusing similar data product can increase productivity by extending an existing one and ensuring that data is not misused or abused using Data Access Control.

## Using the Data Mesh context

One of the design principles for Data Mesh is to reuse the existing data products. Every new data product needs one or more data sources. These data sources can be other data products or external data sources. Before a new data product is created, the following questions should be asked:

- Is there a similar data product already that exists? The last thing the team wants is to have multiple data products with the same data. If the answer is yes, what are the gaps, and can these gaps be addressed by extending the existing data product? For instance, an existing data product might contain most of the required data, but additional columns are needed for your use case. Alternatively, you may prefer to present the data in JSON format rather than a tabular one. In such cases, it's better to extend the existing data product rather than creating a new one. This decision is a matter for business conversation among the product owners.
- Is there an existing data product that can be used as a data source? If yes, how do you ensure that it's trustworthy and well-maintained?
- How can you ensure that changes to the data product you plan to reuse doesn't break your data product?

This is where the concept of `Data Product Catalog` comes in. A data product catalog is a registry of all the data products in the organization. It contains the information about the data product, such as the data product's consumption interface, the data product's SLA, and the data product's owner. In short, the data product catalog makes a data product discoverable, trustworthy, and reusable.

Part of the governance story also includes `Data Lineage`. Within a data product, there should be end-to-end visibility into how data is ingested, transformed, and published. Data lineage represents the journey of data from source to destination, aiding in issue resolution, impact analysis, and enabling business leaders to understand PII data flow.

Also, having a `Data Access Control` mechanism in place is important. It helps to ensure that only the right people have access to the right data at the right time. It also helps to ensure that the data is not misused or abused.

## Consider the background story

Southridge is progressing very well on their journey towards decentralized data architecture with two domains and several data products already in place. But this new architecture is also opening up new challenges.

The two domains have been built independently with a collection of data products with independent lifecycle by two different teams. In that process, they have learned a few important lessons such as:

- The 'sales' product is using 'movies' product as an input dataset. To avoid any impact, the 'sales' product owner(s) must ensure that the schema of the 'movies' dataset doesn't change without their knowledge.
- Teams can build multiple data products but it's hard for other people to know if these products are properly managed and have the right governance controls in place, that is, knowing the legitimacy of the data products that they want to consume.

Southridge leadership team believes there should be a set of rules applied to all data products and their interfaces to ensure a healthy and interoperable ecosystem. They are thinking of creating a centralized governance team to make sure the different domains develop data products consistently.

Imagine you are the central governance team, who sets controls that help enable data product teams within the business to comply with metadata documentation, data cataloging, data classification, and data quality monitoring.

## Understand technical details

Centralized governance in a decentralized data architecture is a broad topic which encompasses multiple components. In this challenge, the focus is limited to only a few components, though there are other crucial aspects of governance.

First, consumers of data products need an easy way to search and find available datasets. It's important to make sure that consumers can tell the difference between the different types of datasets according to their accuracy and maturity level. Owners of the data products should endorse/certify the datasets meant for external-to-domain consumption. In a decentralized data architecture, the data catalog is the map for the consumers to explore and find the required datasets.

Another important feature for consumers is the lineage of the data. Lineage captures the journey of the source datasets through multiple transformation steps which eventually creates the curated dataset for consumption. Lineage helps consumers to understand data and troubleshoot various issues with data. Another reason for the leadership team to be interested is that they want to know how different PII data (customer name, address, phone number, etc.) is moving through the data pipelines.

The owners of the data domains need to be able to control access to the data at a granular level. The developers of the data product should be able to create/update the datasets, whereas others may only need read access to the data. Defining and assigning the different roles is a key aspect of governance.

## Define the success criteria

1. You have selected and implemented a cataloging solution that captures:
   - Dataset schemas.
   - Related metadata (for example, data owner, last refresh, etc.).
   - Dataset maturity levels (for example, certified, endorsed, raw, etc.).
1. You have certified the relevant datasets for each data product to build trust among consumers.
1. You have selected and implemented a data lineage solution that:
   - Automatically captures lineage since datasets change over time.
   - Captures column-level lineage.
   - Captures related metadata.
1. You have implemented a data access control mechanism that:
   - Allows data product developers to create/update datasets.
   - Allows data product consumers to read datasets.
   - Allows data product owners to manage access to datasets.

## Knowledge check

### Question 1

What is the primary goal of data cataloging in a Data Mesh architecture?

a. To complicate data accessibility.<br>
b. To make data products completely independent.<br>
c. To centralize all data into a single repository.<br>
d. To enhance discoverability and usability of data assets across the organization.<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'd'. The primary goal of data cataloging in a Data Mesh architecture is to enhance discoverability and usability of data assets across the organization. Data cataloging is the process of creating, managing, and maintaining metadata about data assets. It helps data consumers to find the right data assets for their use cases. It also helps data producers to understand the data assets that they are producing and how they are being used.


### Question 2

In a Data Mesh context, what does data lineage help with regarding PII (Personally Identifiable Information) data?

a. It encourages the exposure of PII data.<br>
b. It hides the movement of PII data.<br>
c. It ensures transparency and traceability of PII data flows.<br>
d. It increases the complexity of PII data handling.<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'c'. In a Data Mesh context, data lineage helps ensure transparency and traceability of the flow of Personally Identifiable Information (PII) data, enhancing data governance and compliance.


### Question 3

What are the key attributes of a data product that caters to the needs of data consumers in a Data Mesh architecture?

a. Scalable, Interoperable, Customizable<br>
b. Discoverable, Trustable, Consumable<br>
c. Secure, Responsive, Personalized<br>
d. Hidden, Limited, Inaccessible<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'b'. In a Data Mesh architecture, data products must be discoverable, trustable, and consumable. This means data consumers can easily find the data they need with the assurance that it's trustworthy and well-maintained, and accessible through well-defined interfaces.


## For more information

- [Microsoft Fabric: Endorsements](/fabric/governance/endorsement-overview)
- [Microsoft Fabric: Promote or certify items](/fabric/get-started/endorsement-promote-certify)
- [Microsoft Fabric: Scanning Power BI from Microsoft Purview](/azure/purview/register-scan-power-bi-tenant)
- [Microsoft Purview: Metamodel](/azure/purview/concept-metamodel)
- [Microsoft Purview: Manage assets with metamodel](/azure/purview/how-to-metamodel)
- [Microsoft Solutions Playbook: Data governance](../../capabilities/data-governance/index.md)
