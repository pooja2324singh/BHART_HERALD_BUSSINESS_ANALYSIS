# 📰 Bharat Herald — Business Performance & Digital Transformation Analysis

**Domain:** Media & Publishing | **Period Analyzed:** 2019–2024
**Stack:** SQL · Power BI · DAX · Power Query · Excel

> End-to-end business analysis of a legacy print media company facing declining circulation and ad revenue, aimed at identifying recovery levers and a data-backed roadmap for digital transformation.

---

## 📌 Table of Contents

- [Business Problem](#-business-problem)
- [Objective](#-objective)
- [Dataset & Tools](#-dataset--tools)
- [Approach](#-approach)
- [Key Insights](#-key-insights)
- [Dashboard](#-dashboard)
- [Business Recommendations](#-business-recommendations)
- [Deliverables](#-deliverables)
- [Skills Demonstrated](#-skills-demonstrated)
- [Project Notes](#-project-notes)

---

## 🧩 Business Problem

Bharat Herald, a legacy print newspaper, has experienced a steady decline in circulation and advertising revenue between 2019 and 2024, driven by shifting reader habits and the rise of digital media. Leadership needed a clear, data-driven view of **where value is being lost**, **which markets are digitally ready**, and **how to prioritize a phased digital rollout** without abandoning still-profitable print operations.

## 🎯 Objective

Analyze print circulation, advertising, and early digital pilot data (2019–2024) to:
1. Quantify the scale and drivers of print decline
2. Identify high- and low-performing markets by revenue efficiency
3. Assess digital readiness and engagement across cities
4. Recommend a phased digital transformation strategy backed by data

## 🗂 Dataset & Tools

| Component | Details |
|---|---|
| Time period | 2019–2024 |
| Data areas | Print circulation, ad revenue by category, city-level readiness/engagement, digital pilot (App + WhatsApp) |
| Tools used | SQL (data extraction & business queries), Power Query (cleaning/transformation), Power BI (dashboarding), DAX (KPIs & measures), Excel (validation) |

> 📁 Dataset sourced from the **Codebasics Resume Project Challenge**.

## 🔍 Approach

1. **Data Cleaning & Modeling** — Consolidated raw print, ad, and digital pilot data using Power Query; built a star-schema-style data model in Power BI.
2. **SQL Analysis** — Wrote business queries to surface YoY circulation trends, category-wise ad revenue, and city-level performance.
3. **DAX Measures** — Built KPIs including revenue per copy, YoY % decline, engagement rate, and readiness index.
4. **Dashboarding** — Designed interactive Power BI dashboards for print performance, ad revenue, and digital readiness.
5. **Insight Synthesis** — Translated dashboard findings into prioritized, actionable business recommendations.

---

## 📊 Key Insights

### 🖨️ Print Performance
| Metric | 2019 | 2024 | Change |
|---|---|---|---|
| Net Circulation | 39.6M | 29.6M | ↓ 25.2% |
| Copies Sold | 41.8M | 31.3M | ↓ ~25% |
| Print Waste | 4.5M | 3.5M | ↓ ~22% |

Print waste reduction outpaced circulation loss slightly, suggesting some operational tightening — but not enough to offset the structural decline in readership.

### 📢 Advertising Performance
- **Government** and **Real Estate** were the most stable, consistently strong revenue categories across the period.
- **FMCG** was the most volatile category — revenue fell from **₹85M (2019) to ₹60M (2024)**, pointing to a shrinking or less diversified advertiser base in this segment.
- **Revenue per copy** varied notably by city:
  - Ranchi: **₹5.23**
  - Lucknow: **₹5.02**
  - Patna: **₹4.90**
  - Jaipur & Varanasi: **₹2.05–2.07** — high circulation but weak monetization, flagging a clear efficiency gap.

### 📱 Digital Pilot Performance
- **Mobile App Beta:** 338K users reached
- **WhatsApp Push Notifications:** 333K users reached
- **Kanpur:** Highest digital readiness (**75.1%**) but only **49.1% engagement** — a readiness-to-engagement gap representing an untapped opportunity.

### 🌐 Digital Readiness by City (Phase 1 Candidates)
| City | Readiness Score |
|---|---|
| Lucknow | 73.5% |
| Bhopal | 73.3% |
| Ahmedabad | 72.7% |
| Kanpur | 75.1% (readiness leader, low engagement) |

---

## 📈 Dashboard Preview





## ✅ Business Recommendations

1. **Prioritize Phase 1 digital expansion** in Ahmedabad, Lucknow, and Bhopal — highest readiness with proven engagement potential.
2. **Close Kanpur's readiness–engagement gap** with targeted digital campaigns and localized content, since infrastructure readiness is already in place.
3. **Scale WhatsApp and mobile-first content delivery**, given strong early reach (333K–338K users) at low incremental cost.
4. **Improve monetization in Jaipur and Varanasi**, where high circulation but low revenue-per-copy (₹2.05–2.07) signals pricing or ad-yield inefficiency rather than a demand problem.
5. **Protect and grow Government & Real Estate ad relationships** while rebuilding a more diversified FMCG advertiser base to reduce revenue volatility.

---

## 📦 Deliverables

-  SQL business analysis queries
-  Power BI interactive dashboards
-  DAX measures & KPI library
-  Business insights & recommendations summary

## 🛠 Skills Demonstrated

`SQL` · `Power BI` · `DAX` · `Power Query` · `Excel` · `Data Visualization` · `Business Analysis`

---

## 📝 Project Notes

This project was completed as part of the **Codebasics Resume Project Challenge**. The dataset was provided by the challenge; all SQL queries, DAX measures, dashboard design, and business recommendations were independently developed as part of this analysis.

---

⭐ If you found this project useful, feel free to star the repo or connect with me for feedback!
