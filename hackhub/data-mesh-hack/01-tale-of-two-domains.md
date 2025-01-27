---
author: humbertohp
description: "Creating a Data Mesh begins with the business examining its data estate and identifying the business domains. These business domains are then mapped to the data domains. Within each domain, there can be one or more data products."
ms.author: humberh
ms.service: solutions-playbook
ms.topic: conceptual
title: "A Tale of two domains"
---

# A Tale of two domains

The following example relates the story of two domains; examining the data estate and identification of business domains as used in this exercise.

## Understanding Data Mesh context

Creating a Data Mesh begins with the business examining its data estate and identifying the business domains. These business domains are then mapped to the data domains. Within each domain, there can be one or more data products.

Typically, there is a one-to-one correspondence between business and data domains. However, in some cases, a business domain can be divided into multiple data domains, such as when data ownership dictates the split, although this is relatively uncommon.

After identifying the data domains and data products, ownership of these domains and products should also be considered by the business. If data is to be treated as a product, a "Product Owner" needs to be assigned. Similarly, domain ownership should be defined, and other roles may need to be specified as part of the Data Mesh implementation.

Keep in mind that this is a business exercise, not a technical one. At this stage, there's no need to worry about the technology platform or its implementation. The primary focus should be on understanding the business domains, data domains, and data products, as well as their relationships from a business perspective.

## Reviewing the background story

Southridge Video has two major business domains:

- `Movie Production:` This division is responsible for managing the film production operations of the company, as well as curating and preserving the extensive library of movies that they have acquired over time.
- `Sales:`:This division is responsible for managing all rental and streaming records (watched movies history), as well as managing customer data and information.

Over time the centralized data warehouse approach proved to be inefficient in responding quickly to the needs of these two major business functions. A few key limitations that are hampering the business today are:

- `Lack of domain expertise:` The centralized data team doesn't have the expertise and context of domain experts who have deep knowledge about the data and its meaning within their respective domains. For example, the centralized data team does not deeply understand nuances of how different revenue streams of rentals and streaming sales should be handled in different customers geographies resulting in long lead time to build relevant and accurate sales reports.
- `Dependency on centralized teams:` There is an increasing heavy reliance on the central data team for data integration, modeling, and analytics. This dependency can slow down decision-making and hinder the autonomy and agility of domain experts. For example, the Filmmaking team is experiencing long lead times in onboarding new Movies to the Movie Catalog.

Due to these challenges, Southridge Video is looking to adopt a decentralized data architecture to empower the domain teams to rapidly adapt to business requirements. However, as a consequence of decentralization, the number of places and teams who provide data increases. This results in data silos. To address this problem, Southridge decided to adopt the concept of data product.

Southridge also planned to establish a centralized governance solution to make sure data products from different domains are developed and shared consistently. This centralized governance solution also plays a crucial role in maintaining the security of sensitive information. As the databases contain customer data including phone numbers and physical addresses, Southridge Video is particularly concerned about safeguarding their customers' information. Their priority is to ensure that such data is always protected and accessible only to authorized personnel with legitimate business justifications.

To reduce disruption, Southridge Video leadership has decided to start a greenfield data project. The new data platform will pull data directly from the source systems, avoiding the legacy data warehouse.

## Understand the technical details

- As already mentioned, there are two major business domains: Movie Production and Sales. This information is critical while defining the domains ownership of data while designing the decentralized architecture.

   The goal of decentralizing the data architecture is to delegate responsibility to individuals who are closest to the data, promoting ongoing adaptability and scalability. It's a common pattern to follow organizational units to define data domains. This article covers the details of domain ownership with example - [Data Mesh Principles and Logical Architecture > Domain Ownership](https://martinfowler.com/articles/data-mesh-principles.html#DomainOwnership).

   For Southridge the major business domains and their data ownership is clearly mentioned. **Try to define the data domains from it.**

- Each data domain will have one or more data products. A data product is designed to provide a readily accessible and curated collection of data that can be effortlessly utilized by teams or individuals throughout an organization. A data product generally provides a 360-degree view of a specific entity, like Customers or Movies. The data products for each data domain can be derived from the data assets mentioned above.

  Data product encapsulates three structural components required for its function, providing access to the domain's analytical data as a product. The three components are:

  - Data & Metadata
  - Code
  - Infrastructure

   This article covers the details of data product with this example - [Data Mesh Principles and Logical Architecture > Data as a product](https://martinfowler.com/articles/data-mesh-principles.html#DataAsAProduct).

   There are two major data sources: Southridge Video and FourthCoffee. Here is a quick summary of different types of datasets in each of these data sources.

|   Company    | Movies | Actors/Actresses | Customers | Streaming Transactions | Rental Transactions |
|:------------|
|  Southridge  |   X    |        X         |     X     |           X            |                     |
| FourthCoffee |   X    |        X         |     X     |                        |          X          |

- In real life, datasets like these (sales, customer data, etc.) can be quite large. However, for this hackathon, the dataset is significantly smaller and contains only a few thousand records.

- It's highly recommended that you read the first two articles from the  [For more information](#for-more-information) section below to complete this challenge.

## Know the success criteria

- You understand and can discuss the high-level challenges of a centralized data architecture.
- You understand and can discuss the concept of business domains, data domains, and data products and their relationship.
- You understand and can discuss various ownership roles in a Data Mesh architecture.
- You have defined the data domains and data products based on the datasets mentioned above. Please remember this is a business task and there is no need to worry about the technology platform or low-level details at this stage.

## Knowledge check

### Question 1

Which of the following options is an example of a decentralized domain-driven data architecture?

a. Data Hub<br>
b. Data Mesh<br>
c. Data Fabric<br>
d. Medallion<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'b'. Data Mesh is a data architecture and organizational approach that treats data as a product and emphasizes decentralized data ownership and infrastructure, enabling scalability and agility in managing and using data.

### Question 2

Which of the following options are correct?

a. A data domain can have one or more data products.<br>
b. A data product can belong to multiple data domains.<br>
c. A data product can reference data from a data product from another domain.<br>
d. A data product can be owned by multiple domain teams.<br>

??? note "Answer! (Click to expand)"

The correct answers are option 'a' and option 'c'. A data domain can have one or more data products. Also, a data product can reference data from a data product from another domain. But a data product cannot belong to multiple data domains or be owned by multiple domain teams.

### Question 3

Which of the following options is NOT a component of a data product?

a. Data & Metadata<br>
b. Code<br>
c. Data Governance<br>
d. Infrastructure<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'c'. Data Governance is a set of practices and processes that ensure the proper management of an organization's data assets. But it is not a component of a data product.


## For more information

- [External Blog: Moving Beyond a Monolithic Data Lake](https://martinfowler.com/articles/data-monolith-to-mesh.html)
- [External Blog: Data Mesh Principles](https://martinfowler.com/articles/data-mesh-principles.html)
- [Microsoft Solutions Playbook: Data Mesh Architecture](../../solutions/data-mesh/index.md)
- [Microsoft Solutions Playbook: Storage on Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview#onelake-and-lakehouse---the-unification-of-lakehouses)
- [Cloud Adoption Framework - What is Data Mesh?](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/what-is-data-mesh)
- [Microsoft Learn: Fabric Domains](/fabric/governance/domains)
