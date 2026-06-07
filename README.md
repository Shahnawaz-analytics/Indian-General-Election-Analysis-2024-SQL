# 🗳️ India General Election Analysis 2024 — SQL

A structured SQL-based analysis of the **India General Election Results 2024**, exploring constituency-wise, state-wise, and party-wise performance using relational database techniques.

---

## 📌 Project Overview

This project applies SQL to analyze real-world electoral data from the 2024 Indian General Elections. The analysis covers voting trends, winning margins, seat distribution, and party dominance — demonstrating how SQL can be used for end-to-end data exploration and decision-support insights.

---

## 🗂️ Database Schema

The project uses **5 relational tables**:

| Table | Description |
|---|---|
| `constituencywise_details` | Constituency name, winning candidate, total votes, margin, and party ID |
| `constituencywise_results` | Final results at constituency level — candidate, votes, constituency name |
| `partywise_results` | Party name, party ID, and total seats won |
| `states` | Master reference table with state IDs and state names |
| `statewise_results` | State-level data with leading/trailing candidates, margin, and state ID |

---

## 🔍 Analysis Performed

### 1. Foundational Data Exploration
- Retrieved constituency-wise election outcomes (winning candidate + total votes)
- Listed all unique political parties that contested the election
- Identified closely contested constituencies with a winning margin under 50,000
- Ranked all candidates by total votes received

### 2. Performance Measurement
- Calculated total seats won by each party
- Computed the national average votes per constituency
- Identified the top 10 parties by total vote count
- Counted the number of constituencies per state

### 3. Comparative & Conditional Analysis
- Filtered constituencies with above-average voter turnout
- Classified constituencies by competition level using `CASE` statements:
  - Very High Competition (margin < 10,000)
  - High Competition (margin < 50,000)
  - Moderate Competition (margin < 1,00,000)
  - Low Competition (margin ≥ 1,00,000)
- Identified high-vote-share candidates who narrowly lost

### 4. Multi-Dimensional Election Insights
- Computed state-wise seat distribution for each party
- Determined the leading party per state using `RANK()` window function
- Ranked constituencies within each state by voter turnout using `PARTITION BY`

---

## 🛠️ SQL Concepts Used

| Concept | Applied In |
|---|---|
| `SELECT`, `WHERE`, `ORDER BY` | Foundational data retrieval |
| `GROUP BY`, `HAVING` | Party and state-level aggregations |
| `JOIN` (INNER JOIN) | Linking all 5 tables across queries |
| Subqueries | Above-average constituency filter |
| `CASE` statements | Competition level classification |
| Window Functions (`RANK`, `PARTITION BY`) | Intra-state constituency ranking |
| Aggregate Functions (`SUM`, `AVG`, `COUNT`) | Performance measurement queries |
| CTEs (`WITH`) | Leading party per state query |

---

## 📁 Repository Structure

```
india-election-sql-analysis/
│
├── india_election_queries.sql    # All 14 SQL queries organised by section
├── README.md                     # Project documentation
└── data/                         # (Optional) Source CSV datasets
    ├── constituencywise_details.csv
    ├── constituencywise_results.csv
    ├── partywise_results.csv
    ├── states.csv
    └── statewise_results.csv
```

---

## 💡 Key Insights

- Party-wise and state-wise aggregations reveal regional political dominance patterns.
- Margin-based analysis uncovers the most and least competitive constituencies in the election.
- Subquery filtering effectively isolates high-engagement vs. low-engagement constituencies.
- Window functions enable granular intra-state comparisons without collapsing the dataset.
- Identifying high-vote-share losing candidates highlights strong opposition presence in key regions.

---

## 🚀 How to Run

1. Set up a relational database (MySQL / PostgreSQL / SQLite).
2. Import the source CSV files into the corresponding tables.
3. Execute the queries from `india_election_queries.sql` in sequence or by section.

---

## 📊 Dataset Source

Election results data sourced from publicly available **Election Commission of India** records for the 2024 Lok Sabha General Elections.

---

## 🙋 About

This project was built as part of a hands-on SQL learning initiative to apply database querying techniques on a meaningful real-world dataset. It demonstrates practical proficiency in data exploration, aggregation, conditional logic, and window functions.

---
