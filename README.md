# 🏭 Maven Fuzzy Factory — End-to-End SQL Business Analysis

> **A structured 5-phase SQL business analysis on a real e-commerce dataset — covering data quality, revenue trends, traffic attribution, product profitability, and cohort retention — executed entirely in SQL Server T-SQL across 472K sessions and 3 years of data.**

---

## ⚡ Key Numbers Upfront

| Metric | Value |
|--------|-------|
| Sessions Analyzed | **472,871** |
| Orders Processed | **32,313** |
| Revenue Period | **March 2012 – March 2015** |
| Phases of Analysis | **5** |
| Tables in Schema | **6** |
| Mobile Revenue Gap Found | **$282,404** |
| Funnel Opportunity Identified | **~$322K** |
| Repeat Purchase Rate | **1.94%** (98% single-purchase) |
| Overall CVR | **6.83%** (industry avg: 2–4%) |

---

## 📌 Project Overview

Maven Fuzzy Factory is a toy and gift e-commerce business. This project simulates the role of a **data analyst reporting to executive stakeholders** — with each phase answering a real business question, producing a quantified finding, and recommending a specific action.

The analysis is not exploratory browsing. It follows a **deliberate 5-phase framework** designed to mirror how real analysts structure business reviews:

```
Phase 1 → Understand the data before trusting it
Phase 2 → Establish revenue baseline and growth trajectory
Phase 3 → Identify where traffic converts — and where it leaks
Phase 4 → Assess which products are actually profitable
Phase 5 → Measure customer loyalty and retention reality
```

Every finding in this project has a **dollar amount attached**. No vague "insights." Recommendations are specific and immediately actionable.

---

## 🗄️ Database Schema

Six tables. Each serves a distinct analytical purpose.

| Table | Rows | Role |
|-------|------|------|
| `web_sessions` | 472,871 | Central fact table — traffic source, device, UTM data |
| `website_pageviews` | 1,188,124 | Funnel and page-level behavioral analysis |
| `orders` | 32,313 | Primary revenue source — order-level data |
| `order_items` | 40,025 | Product-level transaction detail |
| `order_item_refunds` | 1,731 | Refund tracking and net margin impact |
| `products` | 4 | Small, focused product catalog |

---

## 📊 Phase 1 — Data Understanding & Quality

### Objective
Map the full schema, validate data integrity, and establish baseline KPIs before any analysis begins.

### Critical Data Quality Finding

> ⚠️ **83,328 sessions (17.6% of total traffic) had `utm_source` stored as the string `'NULL'` — not an actual SQL NULL.**

Standard `IS NULL` filtering returned zero rows for these sessions, silently excluding them from all traffic analysis.

```sql
-- WRONG — misses 83,328 sessions
WHERE utm_source IS NULL

-- CORRECT — captures all unattributed traffic
WHERE utm_source IS NULL OR utm_source = 'NULL'
```

This is not a cosmetic fix. It changes the entire organic traffic picture. Any analysis run before this correction would have been materially wrong.

### Baseline KPIs Established

| KPI | Value | Context |
|-----|-------|---------|
| Overall CVR | **6.83%** | Above industry avg of 2–4% |
| Avg Basket Size | **1.23 items/order** | Cross-sell opportunity exists |
| Refund Rate | **4.32%** | Below industry avg of 12–15% |
| Dark Traffic Sessions | **83,328 (17.6%)** | String NULL discovery |

---

## 📈 Phase 2 — Revenue & Trend Analysis

### Objective
Establish revenue trajectory, validate whether growth is real, and identify seasonal concentration risk.

### Revenue Growth

Monthly revenue grew **5x in under two years** — from $3K (March 2012) to $144.8K (December 2014).

```
Mar 2012:  $3,000    ████
Sep 2012:  ~$12K     ████████
Mar 2013:  ~$28K     ████████████████
Sep 2013:  ~$50K     ████████████████████████████
Mar 2014:  ~$75K     ████████████████████████████████████████
Sep 2014:  ~$100K    ████████████████████████████████████████████████████
Dec 2014:  $144.8K   ████████████████████████████████████████████████████████████████████████████
```

### YoY Acceleration Validates Real Momentum

MoM growth rates compress naturally as the revenue base grows (65% → 15%). This is **not a slowdown**. YoY acceleration is the correct metric:

| Period | YoY Growth |
|--------|-----------|
| Dec 2013 vs Dec 2012 | **+130%** |
| Dec 2014 vs Dec 2013 | **+148%** |

Growth is accelerating year-over-year. That is the signal that matters.

### Q4 Seasonal Dependency — Reducing (Healthy Signal)

| Year | Q4 Revenue Share |
|------|-----------------|
| 2012 | 57.8% |
| 2013 | 36.4% |
| 2014 | 35.0% |

The business is becoming less dependent on Q4 spikes — a sign of healthier, more diversified revenue distribution.

---

## 🚦 Phase 3 — Traffic & Funnel Analysis

### Objective
Identify the best-performing traffic channels by CVR (not session volume), and pinpoint the largest revenue leaks in the conversion funnel.

### Traffic Source Performance

| Source | Sessions | CVR | Revenue |
|--------|----------|-----|---------|
| gsearch nonbrand | 282,706 | 6.66% | $1,124,414 |
| gsearch brand | 33,329 | 7.53% | $151,730 |
| NULL / Organic | ~80K | **7.34%** | — |
| bsearch | ~55K | Higher than gsearch | — |
| socialbook | ~5K | Lowest | — |

**Key findings:**
- **Organic traffic converts at 7.34% with zero acquisition cost** — the highest CVR channel
- **bsearch outperforms gsearch on CVR** despite 5x fewer sessions — a strong case for bsearch budget reallocation
- High session volume ≠ best channel. gsearch nonbrand dominates volume but not efficiency

### 📱 Device Performance — The $282,404 Mobile Gap

Within gsearch nonbrand traffic:

| Device | Sessions | CVR | Revenue |
|--------|----------|-----|---------|
| Desktop | 195,155 | **8.22%** | $956,016 |
| Mobile | 87,551 | **3.18%** | $168,397 |
| **Gap** | — | **5.04 pts** | **$282,404** |

**If mobile converted at desktop rates, the business would generate an additional $282,404 in revenue from existing traffic — without spending a single additional dollar on ads.**

This is a mobile UX problem, not a demand problem. Traffic is arriving. It is not converting.

### Conversion Funnel — Where Revenue Leaks

**Overall conversion rate: 6.83%** across 7 funnel steps.

```
Total Sessions    → Landing Page      : Standard entry
Landing Page      → Products Listing  : ~70% pass-through
Products Listing  → Product Page      : Moderate drop
Product Page      → Cart              : ⚠️ 54.84% DROP-OFF ← BIGGEST LEAK
Cart              → Shipping          : ~57% pass-through
Shipping          → Billing           : ~83% pass-through
Billing           → Thank You (Order) : ~74% pass-through
```

**The Product Page → Cart transition is the single largest revenue leak in the entire funnel.**

### Per-Product Cart Conversion Rates

| Product | Sessions | Cart Rate | Priority |
|---------|----------|-----------|----------|
| Mr. Fuzzy | 162,525 | 43.04% | 🔴 PRIORITY FIX |
| Sugar Panda | 19,046 | 46.26% | 🟡 Monitor |
| Forever Love Bear | 26,033 | 55.64% | 🟢 Good |
| Hudson River | 2,610 | **65.13%** | ✅ Best |

**Mr. Fuzzy is the hero product by volume (162K sessions) but has the worst cart rate (43%).
A 5-point improvement in Mr. Fuzzy's cart rate = ~$322K additional revenue opportunity.**

---

## 💰 Phase 4 — Product Profitability Analysis

### Objective
Move beyond gross margin to net margin after refunds, and identify portfolio concentration risk.

### Gross margin is misleading. Net margin tells the real story.

| Product | Revenue | Refunds | Net Profit | Net Margin |
|---------|---------|---------|------------|------------|
| Mr. Fuzzy | $1,211,057 | $61,837 | $677,055 | 55.9% |
| Forever Love Bear | $347,702 | $7,738 | $209,611 | 60.3% |
| Sugar Panda | $229,260 | $13,842 | $143,184 | 62.45% |
| Hudson River | $150,489 | $1,919 | $100,949 | **67.1%** |

### Three Critical Product Signals

**🔴 Mr. Fuzzy — Hero Product Risk**
- 63% of total revenue. 62% of total net profit ($677,055).
- One supply chain disruption, one quality issue, one regulation change = business collapses.
- This is dangerous single-product dependency at scale.

**🟡 Sugar Panda — Margin Erosion**
- 6.04% refund rate destroys 6 percentage points of gross margin: 68.5% → 62.45%
- Root cause of high refunds is unknown. Immediate investigation needed.
- Without refund reduction, Sugar Panda's economics will continue deteriorating.

**✅ Hudson River — The Blueprint**
- 67.1% net margin. 1.28% refund rate. Lowest absolute refunds.
- This is what a healthy product looks like. Use it as the benchmark for new product launches.

---

## 👥 Phase 5 — Cohort Retention Analysis

### Objective
Measure what percentage of customers return after their first purchase, and whether retention is improving over time.

### The Retention Reality

```
98% of customers never return after their first purchase.
```

Only **617 of 32,313 orders were repeat purchases** — a 1.94% repeat rate. The business is **100% acquisition-dependent**. Every dollar of revenue requires acquiring a new customer. There is no compounding retention base.

### Cohort Retention Matrix (6 Cohorts × M0–M12)

| Cohort | Size | M0 | M1 | M2 | M3 | M6 | M12 |
|--------|------|----|----|----|----|-----|-----|
| 2012-03 | 60 | 100% | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% |
| 2012-09 | 286 | 100% | 0.3% | 1.0% | 0.0% | 0.0% | 0.0% |
| 2013-01 | 387 | 100% | 1.0% | 0.0% | 0.3% | 0.0% | 0.0% |
| 2013-09 | 616 | 100% | 1.3% | 0.8% | 0.2% | 0.0% | 0.0% |
| 2014-04 | 542 | 100% | **1.8%** | 0.4% | 0.2% | 0.0% | 0.0% |
| 2014-09 | 1,424 | 100% | 1.0% | 0.1% | 0.0% | 0.0% | 0.0% |

### The Positive Signal Inside Ugly Numbers

Month 1 retention grew **5x** from 0.3% (2012 cohorts) to 1.8% (2014 cohorts). Small percentage — large trajectory improvement. The retention infrastructure is improving even if absolute numbers are still low.

### What This Means in Dollar Terms

A post-purchase email sequence targeting Month 1 repurchase — targeting just the 2014-09 cohort of 1,424 customers at the current 1.8% M1 rate — suggests a pathway to **~1,500 additional annual orders at zero acquisition cost** if retention rates continue improving.

---

## 🎯 5 Key Business Findings — Dollar-Quantified

| # | Finding | Quantified Impact | Recommended Action |
|---|---------|------------------|-------------------|
| 1 | Mobile CVR gap: 3.18% vs desktop 8.22% | **$282,404 revenue gap** | Mobile UX audit on gsearch nonbrand — no new ad spend needed |
| 2 | Product Page → Cart: 54.84% drop-off | **~$322K opportunity** | 5-point cart rate fix on Mr. Fuzzy UX |
| 3 | Sugar Panda 6.04% refund rate | **6 pts margin erosion** | Immediate root cause investigation on refund drivers |
| 4 | Mr. Fuzzy = 63% revenue concentration | **Business collapse risk** | Prioritize product diversification investment |
| 5 | 98% single-purchase customers | **~1,500 free orders/year** | Post-purchase email sequence at Month 1 trigger |

---

## 🔧 SQL Techniques Used

| Technique | Applied In |
|-----------|-----------|
| `CTEs (WITH clause)` | Multi-step funnel analysis, cohort construction, revenue layering |
| `LAG() Window Function` | MoM revenue growth calculation, YoY acceleration comparison |
| `MAX(CASE WHEN)` | Cohort retention matrix — pivoting repeat purchase data |
| `DATEDIFF()` | Cohort month calculation (M0, M1, M2... M12) |
| `NULLIF()` | Division-by-zero protection in CVR and margin calculations |
| `COALESCE()` | NULL handling in traffic source attribution |
| `PIVOT` | Cross-tab revenue and session data by device and source |
| `Multi-Table JOINs` | Linking sessions → orders → order_items → refunds → products |
| `String NULL Detection` | `col IS NULL OR col = 'NULL'` — critical data quality fix |
| `Integer Division Fix` | Explicit DECIMAL casting to prevent truncated CVR calculations |
| `Funnel Analysis` | Step-by-step session drop-off using pageview sequence logic |
| `Cohort Analysis` | 36-cohort retention matrix with M0–M12 tracking |

---

## 📁 Project Structure

```
maven-fuzzy-factory-sql-analysis/
│
├── sql/
│   ├── phase1_data_understanding.sql      # Schema exploration, NULL audit, baseline KPIs
│   ├── phase2_revenue_trend_analysis.sql  # MoM revenue, YoY growth, Q4 dependency
│   ├── phase3_traffic_funnel.sql          # UTM source CVR, device performance, funnel steps
│   ├── phase4_product_profitability.sql   # Gross vs net margin, refund impact by product
│   └── phase5_cohort_retention.sql        # 36-cohort M0–M12 retention matrix
│
├── screenshots/
│   ├── phase1_schema_and_kpis.png
│   ├── phase2_revenue_growth_chart.png
│   ├── phase3_traffic_cvr_breakdown.png
│   ├── phase3_funnel_drooff.png
│   ├── phase4_product_margin_table.png
│   └── phase5_cohort_matrix.png
│
├── presentation/
│   └── Maven_Fuzzy_Factory_Analysis.pdf   # Gamma presentation (10 slides)
│
└── README.md
```

---

## ⚙️ Setup & Usage

### Prerequisites
- Microsoft SQL Server (Express or Developer Edition)
- SQL Server Management Studio (SSMS)
- Maven Fuzzy Factory database (available via Maven Analytics)

### Steps to Run

**1. Clone the repository**
```bash
git clone https://github.com/SandipMandal-52/maven-fuzzy-factory-sql-analysis.git
```

**2. Restore or connect the Maven Fuzzy Factory database in SSMS**

**3. Run phases in order**
```sql
-- Phase 1: Data understanding (run this first — validates data quality)
-- Open: sql/phase1_data_understanding.sql

-- Phase 2: Revenue trends
-- Open: sql/phase2_revenue_trend_analysis.sql

-- Phase 3: Traffic and funnel
-- Open: sql/phase3_traffic_funnel.sql

-- Phase 4: Product profitability
-- Open: sql/phase4_product_profitability.sql

-- Phase 5: Cohort retention
-- Open: sql/phase5_cohort_retention.sql
```

> ⚠️ **Critical:** Always apply the string NULL fix before running any traffic analysis.
> Use `WHERE utm_source IS NULL OR utm_source = 'NULL'` — not just `IS NULL`.

---

## 🛠️ Tools & Environment

![SQL Server](https://img.shields.io/badge/Microsoft_SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=databricks&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)

- **Database:** Microsoft SQL Server (Express 16.0)
- **IDE:** SQL Server Management Studio (SSMS)
- **Language:** T-SQL
- **Dataset:** Maven Fuzzy Factory (Maven Analytics)
- **Period:** March 2012 – March 2015 (3 years)

---

## 👤 Author

**Sandip Mandal** — EDP Analyst | Aspiring Data Analyst
📍 Nagpur, Maharashtra, India
🔗 [LinkedIn](https://linkedin.com/in/sandipmandal52) | [GitHub](https://github.com/SandipMandal-52) | 📧 sandipmandalcv@gmail.com

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

*If this project helped you, consider giving it a ⭐ on GitHub.*
