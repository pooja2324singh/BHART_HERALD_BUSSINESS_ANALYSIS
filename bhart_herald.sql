/* businness request 1*/
WITH circulation_drop AS (
    SELECT
        dc.city AS city_name,
        fps.Month,
        fps.Net_Circulation,
        LAG(fps.Net_Circulation) OVER (
            PARTITION BY fps.City_ID
            ORDER BY fps.Month
        ) AS prev_month_circulation
    FROM fact_print_sales fps
    JOIN dim_city dc
        ON fps.City_ID = dc.city_id
)
SELECT
    city_name,
    Month,
    Net_Circulation,
    Net_Circulation - prev_month_circulation AS mom_decline
FROM circulation_drop
WHERE prev_month_circulation IS NOT NULL
  AND Net_Circulation < prev_month_circulation
ORDER BY mom_decline
LIMIT 3; 
/*request 2 */

WITH revenue_inr AS (
    SELECT
        LEFT(quarter,4) AS year,
        ad_category,
        CASE
            WHEN currency = 'USD' THEN ad_revenue * 83
            WHEN currency = 'EUR' THEN ad_revenue * 90
            ELSE ad_revenue
        END AS revenue_inr
    FROM fact_ad_revenue
),

category_revenue AS (
    SELECT
        year,
        ad_category AS category_name,
        SUM(revenue_inr) AS category_revenue
    FROM revenue_inr
    GROUP BY year, ad_category
),

yearly_revenue AS (
    SELECT
        year,
        SUM(revenue_inr) AS total_revenue_year
    FROM revenue_inr
    GROUP BY year
)

SELECT
    cr.year,
    cr.category_name,
    ROUND(cr.category_revenue,2) AS category_revenue,
    ROUND(yr.total_revenue_year,2) AS total_revenue_year,
    ROUND(
        (cr.category_revenue / yr.total_revenue_year) * 100,
        2
    ) AS pct_of_year_total
FROM category_revenue cr
JOIN yearly_revenue yr
    ON cr.year = yr.year
WHERE (cr.category_revenue / yr.total_revenue_year) > 0.50
ORDER BY cr.year, pct_of_year_total DESC;
/*
Business Request 3:
2024 Print Efficiency Leaderboard
Copies Printed = Copies Sold + Copies Returned
*/

WITH city_efficiency AS (
    SELECT
        dc.city AS city_name,

        SUM(fps.`Copies Sold` + fps.copies_returned) AS copies_printed_2024,

        SUM(fps.Net_Circulation) AS net_circulation_2024,

        ROUND(
            SUM(fps.Net_Circulation) /
            SUM(fps.`Copies Sold` + fps.copies_returned),
            4
        ) AS efficiency_ratio

    FROM fact_print_sales fps
    JOIN dim_city dc
        ON fps.City_ID = dc.city_id

    WHERE Month LIKE '%24'
       OR Month LIKE '2024/%'

    GROUP BY dc.city
)

SELECT
    city_name,
    copies_printed_2024,
    net_circulation_2024,
    efficiency_ratio,

    RANK() OVER (
        ORDER BY efficiency_ratio DESC
    ) AS efficiency_rank_2024

FROM city_efficiency
ORDER BY efficiency_ratio DESC
LIMIT 5;
/*
Business Request 4:
Internet Readiness Growth (2021)
Find change in internet penetration from Q1-2021 to Q4-2021
and identify the city with highest improvement.
*/
WITH internet_growth AS (
    SELECT
        dc.city AS city_name,

        MAX(
            CASE
                WHEN fcr.quarter = '2021-Q1'
                THEN fcr.internet_penetration
            END
        ) AS internet_rate_q1_2021,

        MAX(
            CASE
                WHEN fcr.quarter = '2021-Q4'
                THEN fcr.internet_penetration
            END
        ) AS internet_rate_q4_2021

    FROM fact_city_readiness fcr
    JOIN dim_city dc
        ON fcr.city_id = dc.city_id

    GROUP BY dc.city
)

SELECT
    city_name,
    internet_rate_q1_2021,
    internet_rate_q4_2021,
    ROUND(
        internet_rate_q4_2021 -
        internet_rate_q1_2021,
        2
    ) AS delta_internet_rate
FROM internet_growth
ORDER BY delta_internet_rate DESC;
/* Business Request 5*/
WITH yearly_data AS (
    SELECT
        dc.city AS city_name,

        CASE
            WHEN fps.Month LIKE '%20'
                THEN CONCAT('20', RIGHT(fps.Month,2))
            ELSE LEFT(fps.Month,4)
        END AS year,

        SUM(fps.Net_Circulation) AS yearly_net_circulation,

        SUM(
            CASE
                WHEN far.currency = 'USD' THEN far.ad_revenue * 83
                WHEN far.currency = 'EUR' THEN far.ad_revenue * 90
                ELSE far.ad_revenue
            END
        ) AS yearly_ad_revenue

    FROM fact_print_sales fps

    JOIN dim_city dc
        ON fps.City_ID = dc.city_id

    LEFT JOIN fact_ad_revenue far
        ON fps.edition_ID = far.edition_id

    GROUP BY
        dc.city,
        CASE
            WHEN fps.Month LIKE '%20'
                THEN CONCAT('20', RIGHT(fps.Month,2))
            ELSE LEFT(fps.Month,4)
        END
),

yearly_check AS (
    SELECT
        city_name,
        year,
        yearly_net_circulation,
        yearly_ad_revenue,

        LAG(yearly_net_circulation) OVER (
            PARTITION BY city_name
            ORDER BY year
        ) AS prev_net_circulation,

        LAG(yearly_ad_revenue) OVER (
            PARTITION BY city_name
            ORDER BY year
        ) AS prev_ad_revenue

    FROM yearly_data
),

city_flags AS (
    SELECT
        city_name,

        CASE
            WHEN SUM(
                CASE
                    WHEN prev_net_circulation IS NOT NULL
                     AND yearly_net_circulation >= prev_net_circulation
                    THEN 1
                    ELSE 0
                END
            ) = 0
            THEN 'Yes'
            ELSE 'No'
        END AS is_declining_print,

        CASE
            WHEN SUM(
                CASE
                    WHEN prev_ad_revenue IS NOT NULL
                     AND yearly_ad_revenue >= prev_ad_revenue
                    THEN 1
                    ELSE 0
                END
            ) = 0
            THEN 'Yes'
            ELSE 'No'
        END AS is_declining_ad_revenue

    FROM yearly_check
    GROUP BY city_name
)

SELECT
    yc.city_name,
    yc.year,
    yc.yearly_net_circulation,
    yc.yearly_ad_revenue,
    cf.is_declining_print,
    cf.is_declining_ad_revenue,
    'Yes' AS is_declining_both

FROM yearly_check yc
JOIN city_flags cf
    ON yc.city_name = cf.city_name

WHERE cf.is_declining_print = 'Yes'
  AND cf.is_declining_ad_revenue = 'Yes'

ORDER BY yc.city_name, yc.year;


/*
Business Request 6:
2021 Readiness vs Pilot Engagement Outlier

*/
WITH readiness_2021 AS (
    SELECT
        dc.city AS city_name,

        ROUND(
            AVG(
                (
                    fcr.literacy_rate +
                    fcr.smartphone_penetration +
                    fcr.internet_penetration
                ) / 3
            ),
            2
        ) AS readiness_score_2021

    FROM fact_city_readiness fcr
    JOIN dim_city dc
        ON fcr.city_id = dc.city_id

    WHERE fcr.quarter LIKE '%2021%'

    GROUP BY dc.city
),

engagement_2021 AS (
    SELECT
        dc.city AS city_name,

        ROUND(
            SUM(fdp.downloads_or_accesses) /
            NULLIF(SUM(fdp.users_reached),0),
            4
        ) AS engagement_metric_2021

    FROM fact_digital_pilot fdp
    JOIN dim_city dc
        ON fdp.city_id = dc.city_id

    WHERE fdp.launch_month LIKE '%2021%'

    GROUP BY dc.city
),

combined AS (
    SELECT
        r.city_name,
        r.readiness_score_2021,
        e.engagement_metric_2021
    FROM readiness_2021 r
    JOIN engagement_2021 e
        ON r.city_name = e.city_name
),

ranked AS (
    SELECT
        city_name,
        readiness_score_2021,
        engagement_metric_2021,

        RANK() OVER (
            ORDER BY readiness_score_2021 DESC
        ) AS readiness_rank_desc,

        RANK() OVER (
            ORDER BY engagement_metric_2021 ASC
        ) AS engagement_rank_asc

    FROM combined
)

SELECT
    city_name,
    readiness_score_2021,
    engagement_metric_2021,
    readiness_rank_desc,
    engagement_rank_asc,

    CASE
        WHEN readiness_rank_desc = 1
         AND engagement_rank_asc <= 3
        THEN 'Yes'
        ELSE 'No'
    END AS is_outlier

FROM ranked
ORDER BY readiness_rank_desc;  