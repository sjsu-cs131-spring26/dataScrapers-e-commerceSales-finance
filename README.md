# dataScrapers-e-commerceSales-finance
**Team Members: 👥** 
* Bashir Hurani
* Dzhamal Chapanov
* Aetius Gular
* Kean Flanagan
* Nathan Luu



# Dataset Documentation 🗒️: 

**Dataset link:** https://amazon-reviews-2023.github.io/  
**Overview:** The dataset is large scale aggregation of 2023 Amazon reviews, descriptions, prices, and etc that showcase real-world online retail activity. The records contain information about products, pricing, interactions with Amazon between 1996 to 2023, user ratings, as well as helpfulness votes. For the immense amount of data, our team will be focusing on the health and personal care sector.

**Size / Scope:** 
* 494,100 rows and 10 columns
* Around 221 MB

**Justificaton:**
* This dataset is directly relevant to the team’s chosen domain of finance, more specifically, eCommerce sales. Going over several consumer atttributes such as user rating, asin information, user I.D., pricing, nearly exact timestamp, and verified purchased reviews that will showcase the large-scale data analysis retail sellers would utilize. Understanding customer-cenetered needs is a major focus for large corporations to make the most sales, so by creating scalable data pipelines over the entire semester, it will potentially highlight significant factors that may be overlooked initially.

# Data Card 🗂️

**File Formating:**
* CSV (Comma seperated Values)

**Compression:**
* .zip (68.199 MB)
* .csv (221.671 MB)

**Row Count:**
* 494,100

**Column Count:**
* 10

**Delimiter(s):**
* Comma (,)

**Header row presence**
* yes ✅

**Encoding:**
* charset=us-ascii

# Obvious Quality Notes ✏️

* City and State categories align; however, country is not relevant
* Due to the synthetic nature of the dataset, some correlations are too linear
  * All customer names have South Asian origins
  * No typos when searching for items
* Sales are heavily skewed with the United States leading with 62.3M sales and the second being India with only 13.5M
* The Timeline of the dataset ranges from the end of 2019 to the end of 2024
* 43233 unique customers in the dataset
* Moreover the Category and Brands categories are not realistic, so we are not using them due to the inaccurate synthetic nature of them.
