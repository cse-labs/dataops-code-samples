---
author: humbertohp
description: "This hack is specifically crafted to facilitate learning the concepts of Data Mesh through practical, hands-on experience (Hack) via challenges rooted in a fictional customer scenario."
ms.author: humberh
ms.service: solutions-playbook
ms.topic: conceptual
title: "Introduction"
---

# Introduction

This hack is specifically crafted to facilitate learning the concepts of Data Mesh through practical, hands-on experience (Hack) via challenges rooted in a fictional customer scenario. Within this hack, participants engage in a progressive process of solving a series of challenges, ultimately constructing a Data Mesh. The order in which these challenges are tackled has significance, since each challenge builds upon the results of the preceding one(s).

It's worth noting that these challenges are not accompanied by explicit step-by-step instructions for solving them. However, each challenge is furnished with comprehensive technical explanations and reference materials to empower teams to resolve the challenges and gain valuable learning experience.

Presently, there are two available [delivery models](#delivery-models) for conducting the hack. If you require any assistance in organizing the hack, [reach out to](mailto:lace.lofranco@microsoft.com).

[Feedback](#data-mesh-hack-feedback) plays a pivotal role in enhancing both the products and the hack experience. Request: Thanks for allocating some time to gather and share your valuable feedback.

## Infrastructure setup

In order to complete the challenges, there are some resources that are required to be setup and include the data that you will be using in the challenges. The infrastructure of the fictitious customer is represented by a set of Azure resources. The Infrastructure as Code (IaC) scripts for setting up the customer's Azure infrastructure can be found in the [dataops-code-samples](https://github.com/cse-labs/dataops-code-samples/blob/main/hackhub/data-mesh-hack/deployment.md) repository.

The participants will also require [Microsoft Fabric license](/fabric/enterprise/licenses). A few success criteria from the challenges require [administrative privileges](/fabric/admin/roles). But if such elevated roles can't be granted, the hack can still be executed.

The following is a list of common Azure resources that are deployed during the hack.

| Azure resource        | Resource Providers      |
|-----------------------|-------------------------|
| Azure Cosmos DB       | Microsoft.DocumentDB    |
| Azure SQL Database    | Microsoft.SQL           |
| Azure Storage         | Microsoft.Storage       |
| Azure Data Lake Store | Microsoft.DataLakeStore |
| Azure Key Vault       | Microsoft.KeyVault      |
| Microsoft Purview     | Microsoft.Purview       |

Ensure that these services are not blocked by Azure Policy. The services that attendees can utilize are not limited to this list. Subscriptions with a tightly controlled service catalog may run into issues, if the service an attendee wishes to use is disabled via policy.

## Challenges

There are six challenges that gradually construct the Data Mesh and ultimately address a specific business need. Here is a concise overview of these challenges.

| Challenge                                                         | Purpose                                                      |
|-------------------------------------------------------------------|--------------------------------------------------------------|
| [Background Story](./00-background.md)                            | Covers the customer story behind the challenges              |
| [Challenge 1: A Tale of Two Domains](./01-tale-of-two-domains.md) | Design domains and data products                             |
| [Challenge 2: Brave New World](./02-brave-new-world.md)           | Implement the first data product                             |
| [Challenge 3: The Bucket List](./03-bucket-list.md)               | Deep dive into data products                                 |
| [Challenge 4: The Rise of Governance](./04-governance.md)         | Implement governance from Data Mesh perspective              |
| [Challenge 5: Search Party](./05-search-party.md)                 | Consume data product to address a business challenge         |
| [Challenge 6: The Quality Awakens](./06-data-quality.md)          | Implement data/business validations to maintain data quality |

## Introduction and walkthrough

If you would like more background on Data Mesh and how the challenges reflect the Data Mesh approach, check out the video [here](https://microsoft.sharepoint.com/:v:/t/CSETechnologyDomains/EeggOk2H3mJOril9OQD5QRsBaAO0KQKrJu_U0eti-cqBwg?e=wIqWOZ).

For a introductory walkthrough of using [Microsoft Fabric](https://microsoft.sharepoint.com/:v:/t/CSETechnologyDomains/EeggOk2H3mJOril9OQD5QRsBaAO0KQKrJu_U0eti-cqBwg?e=wIqWOZ). There are also [resources for this video ](https://microsoft.sharepoint.com/:v:/t/CSETechnologyDomains/Eb-IZXa6xJtAh9V6nNgeA6AB3oJ-WeqOJflDd-mzK-qDeg?e=Gh3jt5).

> _Note: This video was created during the public preview and some elements may have changed as we near GA._

## Delivery models

Currently the hack can be offered in two models.

### Coach-guided hack

In this model, the event organizers handle infrastructure provisioning and appoint a coach for each team. There can be multiple teams, each consisting of an ideal number of participants, ranging from four to six. The coach assists the team in comprehending the challenges and providing guidance when they encounter obstacles. This setup promotes collaboration and learning within a mentored environment. Additionally, participants should be prepared to commit two days, consecutively to this endeavor.

### Self-serve hack

In this model, individuals or small teams have the opportunity to undertake the hack independently. The participants are responsible for both provisioning the infrastructure (as outlined in the [infrastructure Setup](#infrastructure-setup) section) and executing the challenges.

While individuals or teams have the freedom to determine their approach for conducting the hack, the [Data Channel](https://teams.microsoft.com/l/channel/19%3A2d0af010aefb4de89517accaef813d0b%40thread.skype/Data?groupId=df6d233f-a61d-4d69-a68f-8053dffb2427&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47) in SolutionOps team can be a resource when looking for help from others who have completed or coached this hack in the past.

## Prerequisites

Below are the prerequisites for the hack:

- Fundamental Azure Administration know-how.
- Understanding of core Data Mesh concepts.
- Basic familiarity with Microsoft Fabric.
- A good grasp of SQL and Python.

It's ok if you don't have all of these skills. You can still participate in the hack and learn as you go. The hack is designed to be a learning experience and provide enough guidance and references to help you along the way.

## Data Mesh Hack feedback

Your feedback is crucial for our ongoing improvement of content, tools, and the overall experience for future participants. Please use the following links to provide feedback:

- [Hack Content Feedback](https://aka.ms/ISEUpskillingFeedback)
- [Product Feedback](https://aka.ms/ISEUpskillingProductFeedback)
  - Open a new Product Feedback work item as a child link
- Improve the hack content directly in the Microsoft Solutions Playbook by opening a PR. See the [Contributing Guide](https://review.learn.microsoft.com/industry/playbook/cross-industry/contributing/) for more details.

## FAQs

- Is completing `MDW OpenHack` a prerequisite for this hack?

  <!-- lychee >
  While prior experience with the [Modern Data Warehouse OpenHack](https://openhack.microsoft.com/), also known as Cloud-based Data Warehousing, is not mandatory to take on these challenges, it can certainly assist participants in grasping the customer story more effectively.
