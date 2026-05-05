# dataScrapers-e-commerceSales-finance
**Team Members: 👥** 
* Bashir Hurani
* Dzhamal Chapanov
* Aetius Gular
* Kean Flanagan
* Nathan Luu



# Dataset Documentation 🗒️: 

**Dataset link:** https://amazon-reviews-2023.github.io/  
**Overview:** This dataset is a large-scale aggregation of Amazon reviews collected in 2023 by McAuley Lab at UC San Diego. It contains real-world consumer review activity spanning May 1996 through September 2023, including user ratings, review text, helpfulness votes, verified purchase flags, and product identifiers. Our team focuses specifically on the Health and Personal Care category, which represents one of the most active and consistently reviewed segments on the platform.

**Size / Scope:** 
* 494,100 rows and 10 columns
* Around 221 MB

**Justificaton:**
* This dataset is directly relevant to the team’s chosen domain of finance, more specifically, eCommerce sales. Going over several consumer atttributes such as user rating, asin information, user I.D., pricing, nearly exact timestamp, and verified purchased reviews that will showcase the large-scale data analysis retail sellers would utilize. Understanding customer-cenetered needs is a major focus for large corporations to make the most sales, so by creating scalable data pipelines over the entire semester, it will potentially highlight significant factors that may be overlooked initially.

# Data Card 🗂️

**File Formating:**
* JSONL

**Compression:**
* .gz

**Row Count:**
* 494,100

**Column Count:**
* 10

**Delimiter(s):**
* Newline-delimited (JSON)

**Header row presence**
* No 

**Encoding:**
* UTF-8

# Key Fields
**Fields:**
* rating (float) - Star rating from 1.0 to 5.0
* title (string) - Review headline
* text (string) - Full review body
* timestamp (int) - Unix timestamp
* verified_purchase (boolean) - Whether the purchase was verified
* helpful_vote (int) - Number of helpful votes on the review
* asin (string) - Unique product identifier
* parent_asin (string) - Product family identifier
* user_id (string) - Unique reviewer identifier

# Obvious Quality Notes ✏️

* A portion of reviews contain null or empty text fields, requiring filtering before text-based analysis
* Some records exhibit inconsistencies in timestamp precision and required normalization during cleaning
* The parent_asin and asin relationship requires careful handling, as product variants such as different sizes or colors share a parent ID, which can inflate product counts if not accounted for
* No geographic data is present in the review records, which limits analysis to national-level demand patterns
