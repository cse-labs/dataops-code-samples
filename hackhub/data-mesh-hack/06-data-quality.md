---
author: humbertohp
description: "Having data that can be trusted in the business is paramount. This means that the data needs to be ready for the business to use when making decisions. Data quality can take many forms depending on the business need. This may mean normalizing time-series data to standardized time windows (10 minute data being compared with15 minute data), it may be alerting and removing impossible values (refrigerator temperature reading 300)."
ms.author: humberh
ms.service: solutions-playbook
ms.topic: conceptual
title: "Implementing data quality"
---

# Implementing data quality

## Using the Data Mesh context

Having data that can be trusted for the business is paramount. This means that the data needs to be ready for the business to use when making decisions. Data quality can take many forms depending on the business need. This may involve normalizing time-series data to standardized time windows, such as comparing 10 minute data with 15 minute data, and alerting or removing impossible values, like a refrigerator temperature reading of 300 degrees.

Problems with data quality don't just show up from incorrect data; consistency matters too. Having the means to publish and endorse a dataset that is shared across the company can help solve this data consistency problem by eliminating the duplicated data.

Ensuring data quality within a data product is a complex topic and there are many different ways to approach it. A common method is to categorize data quality into two main categories:

1. Data validation: This ensures data is valid and ready to be processed, for example, checking if mandatory columns are present or if data types are correct.
2. Business validation: This confirms that the data makes sense from a business standpoint, like checking if a column's value falls within an acceptable range.

Lastly, any errors in data or business validations should be reported to the business so they can take appropriate actions. Depending on the use-case, this information can be presented in various ways, such as through a Power BI report, a dashboard, or alerts. An advanced implementation would also have the capability to take automated actions, such as sending an email to the data owner or initiating a workflow to rectify the data.

## Consider the background story

The implementation of Data Mesh architecture is coming along well. The team has successfully implemented a few domains and corresponding data products. The initial data has been ingested and the data products are ready for consumption. The enhanced search functionality of the new implementation is already providing tangible benefits. But business has raised some concerns about the data quality as new data is being ingested. There are two main challenges that the team is facing:

1. At times, the new data being ingested has schema mismatches which results in failure of the data ingestion process. For example: a mandatory column is missing, the data type of a column is different and so on. There is no way for the team to know about such inconsistencies so they are not able to take appropriate actions.
2. Business doesn't know whether these issues are because of bad data (For example: missing mandatory column) or failure of business validation rules (For example: a column value can be in a certain range).

## Understand technical details

For this challenge, the team is going to focus on "Movies" data product only. The initial movie data for Southridge Video came from the Azure CosmosDB collection. Now, there is another collection which represents the incremental data that needs to be ingested. The team needs to make sure that the new data is ingested successfully and the data quality is maintained. They also need to highlight any issues with the data quality to the business.

As part of business validations, the following rules need to be applied:

- The release year of the movie can't be less than 1900 or more than 2023.
- The valid movie ratings are "G", "PG", "PG-13", "R", and "M".

Here are the details of the new data:

- The new data is available in the `new-movies` collection of the `movies` database in the same Azure CosmosDb account.
- There are 10 new documents in the collection. Some of these may contain invalid records (data validations) and some may have invalid values (business validations).

## Define the success criteria

1. You have defined a "schema" for the "Movies" data product.
    - Typically, this information is included as part of data contracts along with a lot of other attributes. In this case, you are not writing a full-fledged data contract. Rather, you are just focusing on the schema information which is required for data validation.
    - Create a file (preferably JSON/YAML) to define the schema of the "Movies" data product. Include the following information:
      - Column names.
      - Column data types.
      - Is required?
      - Business constraints (if any).
    - Store this file in an appropriate location within the data product.
    - What are the pros and cons of storing a data contract within the data product itself?
2. You have processed the new data and ingested it into the "Movies" data product.
    - Read the new incoming movie data.
    - Apply the "data validations" and "business validations" on this data. You are free to use any open-source library. You can also use the schema file that you created in the previous step.
    - Follows these processing rules:
      - If the data is invalid because of data validations, then log the error and move on to the next document. Also, store the failed record in a separate location.
      - If the data is invalid because of business validations, then log the error and move on to the next document. Also, store the failed record in a separate location.
      - If the data is valid, then ingest the document into the consumption-layer (aka: gold layer) of the data product.
3. You have created a data quality report for the "Movies" data product.
    - Publish a report that contains the following information:
      - Total count of ingested records.
      - Total count of failed records because of data validation.
      - Total count of failed records because of business validation.
    - Publish another report that contains the following information:
      - The details of the failed records so that business can take appropriate actions.
    - The above reports can be in any format (Power BI report, text, HTML, PDF, etc.). The goal is to create a simple report that can be used by the business to understand the data quality.

## Knowledge check

### Question 1

Which of the following examples are instances of business validation? There may be more than one correct answer.

a. The order date shouldn't be greater than return date.<br>
b. The order quantity should be a float.<br>
c. Any return order should have a description.<br>
d. The order table should have a primary key.<br>

??? note "Answer! (Click to expand)"

The correct answers are options 'a' and 'c.' These represent business validation rules, as they enforce specific business requirements. Option 'b' constitutes a data validation rule, and option 'd' pertains to a database schema design requirement, which is not directly related to business validation.


### Question 2

What is the recommended approach for monitoring data quality in a Data Mesh architecture for a data product?

a. Implement continuous data monitoring with alerting mechanisms.<br>
b. Have no monitoring in place to maintain data autonomy.<br>
c. Rely solely on manual data quality checks by data engineers.<br>
d. Use data catalogs to document metadata for data lineage.<br>

??? note "Answer! (Click to expand)"

The correct answers is option 'a'. Continuous data monitoring with alerting mechanisms is a recommended approach to monitor data quality in a Data Mesh architecture for a data product. This method helps detect data quality issues in real-time, allowing for timely remediation and ensuring the data remains reliable and accurate. Option 'b' goes against best practices and can lead to data quality issues. Option 'c' is incorrect as relying solely on manual data quality checks by data engineers can be time-consuming and error-prone. While using data catalogs is valuable for documenting metadata and data lineage (option 'd'), it is not the primary method for monitoring data quality in real-time.


### Question 3

What is the key difference between data validation and business validation?

a. Data validation focuses on technical standards, while business validation ensures data is free from errors.<br>
b. Data validation checks data relevance, while business validation checks data completeness.<br>
c. Data validation verifies data integrity, while business validation enforces business-specific rules.<br>
d. Data validation is concerned with data usability, while business validation is all about data structure.<br>

??? note "Answer! (Click to expand)"

The correct answers is option 'c'. Data validation is concerned with verifying data integrity, while business validation is all about enforcing business-specific rules. Option 'a' incorrectly combines elements of both data validation and business validation, making it an inaccurate statement. Option 'b' confuses the purposes of data validation and business validation, making it an incorrect statement. Option 'd' misrepresents the focus of data validation and business validation, leading to an inaccurate statement.


## For more information

- [Great Expectations: Getting started](https://docs.greatexpectations.io/docs/oss/tutorials/quickstart)
- [Pandera: Data validation API for dataframe-like objects](https://pandera.readthedocs.io/en/stable/index.html)
- [Youtube Video: Fully Utilizing Spark for Data Validation (Databricks)](https://www.youtube.com/watch?v=f901OJrP5ls)
- [Youtube Video: Implementing a Data Quality Framework in Purview](https://www.youtube.com/watch?v=gSUSwciqcxY)
- [Cerberus: Data validation for Python](https://docs.python-cerberus.org/)
- [Microsoft Learn: Using Azure Monitor with Azure Synapse Analytics](https://learn.microsoft.com/azure/synapse-analytics/monitoring/how-to-monitor-using-azure-monitor)

Please note that these links are for reference only. You are free to use any other useful resources that you find.
