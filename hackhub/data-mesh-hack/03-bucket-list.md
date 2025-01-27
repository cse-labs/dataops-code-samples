---
author: humbertohp
description: "Once the first data product has been built, the learnings can be applied to other data products. One of the great things about Data Mesh is that all data products can be built and maintained independently. This means that the team can work on multiple data products simultaneously. It's an excellent opportunity to divide the work among yourselves and gain hands-on experience."
ms.author: humberh
ms.service: solutions-playbook
ms.topic: conceptual
title: "Fulfilling the bucket list"
---

# Fulfilling the bucket list

The information contained here helps to improve domain experts ability to quickly iterate contributions due to improved turnaround times for the movie catalog data product.

## Using the Data Mesh context

Once the first data product has been built, the learnings can be applied to other data products. One of the beneficial things about Data Mesh is that all data products can be built and maintained independently. This means that the team can work on multiple data products simultaneously. It's an excellent opportunity to divide the work among yourselves and gain hands-on experience.

However, dependencies do exist. Data products can, and should, rely on other data products to prevent data duplication. At the same time, consuming data from certified data products means you can trust the data. This is where the concept of a consumption interface comes into play. It enables data products to be consumed by other data products without the need to delve into the internal details of the data product.

When consuming data from a different data product, it's ideal to avoid data duplication, meaning it's better to consume data directly from a data product rather than copying it. This approach ensures that if the source data product is updated, the consuming data product will always have the latest information. It's also a great way to maintain data consistency across the organization. There is more to explore on this topic in the next challenge.

Once the team has built a few data products, the importance and need for a self-serve data platform becomes more evident. For example, there should be a consistent logging and monitoring mechanism for all data products. Additionally, security and compliance guardrails should be applied to all data products. It's the responsibility of the Data Platform team to enable these capabilities in a self-serve manner, allowing the data product teams to focus on building their data products.

For the sake of simplicity, these capabilities are not addressed in the challenges. However, it's highly recommended that you explore these Data Mesh capabilities to build a robust data platform.

## Consider the background story

Leadership is highly satisfied with the turnaround time for the movie catalog data product. It's now evident that domain experts can significantly contribute to quickly iterating on an idea.

This timing aligns well with the sales team's plans to develop a Customer 360 dashboard to capture their customer base and the corresponding sales transactions from rentals and streaming services across Southridge Video and FourthCoffee. Inspired by the success of the Movie Production team, they are eager to adopt the same decentralized paradigm for customer and sales data in their projects.

To prevent data duplication, the sales team aims to consume data from the recently published movie catalog data product, ensuring that all movie data originates from this officially endorsed source. Thanks to the consumption interface provided by the movie production team, the sales team can now self-serve data and work independently.

Imagine you are the sales Team. In this challenge, you need to build the data products related to the sales domain while consuming from a different domain’s data product.

## Understand technical details

The data required to fulfill the business request encompasses the following categories:

- Customers (with Address).
- Movie rentals.
- Movie streaming.

In challenge 1, you'll find a comprehensive summary of all available datasets from the two business units, Southridge and 'FourthCoffee'. Feel free to revisit it if you have any questions about locating specific data.

In challenge 2, you'll find all the technical details related to Southridge and 'FourthCoffee' infrastructure resources.

## Define the success criteria

1. You have completed the design of the data products in the sales domain.
   - Connect to the different source systems and explore the source datasets.
   - Understand the relationship between the different datasets related to 'Customers' and 'Sales' data products.
   - Define and create a logical container for each data product.
2. You have ingested 'Customers', 'Streaming Transaction' and 'Rental Transaction' related data.
   - For Southridge, pull related data from Azure SQL Database.
   - For FourthCoffee, pull related data from the storage account.
   - While storing the data from different sources in the target storage, make sure data is grouped according to their source systems.
3. You have transformed and integrated data from source systems to build the consumption interfaces for 'Customers' and 'Sales' data products.
   - Make sure the source system's datasets have been transformed to use consistent data types and formats. For example, if source systems use different data types or formats for a date, the final dataset stores all dates in a single, consistent data type and format.
   - For each customer record in the above step, create a unique identifier.
   - Add the source system identifiers as additional columns.
   - Make sure the original extracted data is preserved, and the transformation jobs don't change it.
4. You have developed a 'Customer 360' dashboard that highlights the following insights:
   - Top performing movies by year and month.
   - Most valuable customers by year and month.
   - Geography (state) wise sales breakdown.

## Knowledge check

### Question 1

How do data products in a Data Mesh architecture typically consume data from other data products?

a. They don't consume data from other data products.<br>
b. Through a complex web of dependencies.<br>
c. Via well-defined consumption interfaces<br>
d. By bypassing other data products entirely.<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'c'. Data products in a Data Mesh architecture consume data from other data products via well-defined consumption interfaces. This approach ensures that data products can be consumed without the need to delve into the internal details of the data product. It also helps to prevent data duplication and maintain data consistency across the organization.

### Question 2

Which functionality of Microsoft Fabric makes it quick and easy to consume data from other data products without any data duplication?

a. Storing data in Delta Parquet format<br>
b. Copy activity<br>
c. Fabric capacity<br>
d. OneLake shortcuts<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'd'. OneLake shortcuts make it quick and easy to consume data from other data products without any data duplication. Shortcuts are objects in OneLake that point to other storage locations. The location can be internal or external to OneLake. The location that a shortcut points to is known as the target path of the shortcut. The location where the shortcut appears is known as the shortcut path.

### Question 3

Who is responsible for providing the self-serve capabilities for the teams to build data products?

a. Data platform owners<br>
b. Data product owners<br>
c. Data product consumers<br>
d. Data engineers and architects<br>

??? note "Answer! (Click to expand)"

The correct answer is option 'a'. The data platform owners are responsible for providing the self-serve capabilities for the teams to build data products. The data platform owners are also responsible for providing the guardrails for security, compliance, and monitoring.


## For more information

- [Microsoft Fabric: OneLake shortcuts](https://learn.microsoft.com/fabric/onelake/onelake-shortcuts)
- [Microsoft Fabric: ADF Copy activity](https://learn.microsoft.com//fabric/data-factory/copy-data-activity)
- [Microsoft Fabric: Moving and transforming data with dataflows and data pipelines](https://learn.microsoft.com/fabric/data-factory/transform-data)
- [Lakehouse Tutorial: Prepare and transform data in the lakehouse](https://learn.microsoft.com/fabric/data-engineering/tutorial-lakehouse-data-preparation)
- [Lakehouse Tutorial: Building reports in Microsoft Fabric](https://learn.microsoft.com/fabric/data-engineering/tutorial-lakehouse-build-report)
