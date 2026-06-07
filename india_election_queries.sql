-- ============================================================
-- INDIA GENERAL ELECTION ANALYSIS 2024
-- SQL Queries File
-- ============================================================
-- Tables Used:
--   1. constituencywise_details
--   2. constituencywise_results
--   3. partywise_results
--   4. states
--   5. statewise_results
-- ============================================================


-- ============================================================
-- SECTION 1: FOUNDATIONAL DATA EXPLORATION
-- ============================================================

-- Query 1: Retrieve constituency name, winning candidate, and total votes
-- for all constituencies
SELECT
    constituency_name,
    winning_candidate,
    total_votes
FROM constituencywise_results
ORDER BY constituency_name;


-- Query 2: List all unique political parties that contested the election
SELECT DISTINCT party_name
FROM partywise_results
ORDER BY party_name;


-- Query 3: Constituencies with a winning margin less than 50,000
-- (closely contested constituencies)
SELECT
    cr.constituency_name,
    cr.winning_candidate,
    cr.total_votes,
    cd.margin,
    cd.party_id
FROM constituencywise_results cr
JOIN constituencywise_details cd
    ON cr.constituency_name = cd.constituency_name
WHERE cd.margin < 50000
ORDER BY cd.margin ASC;


-- Query 4: Candidates ranked by total votes in descending order
SELECT
    winning_candidate,
    constituency_name,
    total_votes
FROM constituencywise_results
ORDER BY total_votes DESC;


-- ============================================================
-- SECTION 2: PERFORMANCE MEASUREMENT
-- ============================================================

-- Query 5: Total seats won by each party
SELECT
    party_name,
    SUM(seats_won) AS total_seats_won
FROM partywise_results
GROUP BY party_name
ORDER BY total_seats_won DESC;


-- Query 6: Average votes per constituency
SELECT
    ROUND(AVG(total_votes), 2) AS avg_votes_per_constituency
FROM constituencywise_results;


-- Query 7: Top 10 parties by total votes across all constituencies
SELECT
    pr.party_name,
    SUM(cr.total_votes) AS total_votes
FROM constituencywise_results cr
JOIN constituencywise_details cd
    ON cr.constituency_name = cd.constituency_name
JOIN partywise_results pr
    ON cd.party_id = pr.party_id
GROUP BY pr.party_name
ORDER BY total_votes DESC
LIMIT 10;


-- Query 8: Number of constituencies per state
SELECT
    s.state_name,
    COUNT(sr.constituency_id) AS constituency_count
FROM statewise_results sr
JOIN states s
    ON sr.state_id = s.state_id
GROUP BY s.state_name
ORDER BY constituency_count DESC;


-- ============================================================
-- SECTION 3: COMPARATIVE & CONDITIONAL ANALYSIS
-- ============================================================

-- Query 9: Constituencies with total votes above the national average
SELECT
    constituency_name,
    winning_candidate,
    total_votes
FROM constituencywise_results
WHERE total_votes > (
    SELECT AVG(total_votes)
    FROM constituencywise_results
)
ORDER BY total_votes DESC;


-- Query 10: Constituency competition classification based on winning margin
SELECT
    cr.constituency_name,
    cr.winning_candidate,
    cd.margin,
    CASE
        WHEN cd.margin < 10000  THEN 'Very High Competition'
        WHEN cd.margin < 50000  THEN 'High Competition'
        WHEN cd.margin < 100000 THEN 'Moderate Competition'
        ELSE 'Low Competition'
    END AS competition_level
FROM constituencywise_results cr
JOIN constituencywise_details cd
    ON cr.constituency_name = cd.constituency_name
ORDER BY cd.margin ASC;


-- Query 11: High vote-share candidates who lost (trailing candidates
-- with significant vote counts)
SELECT
    sr.trailing_candidate,
    sr.constituency,
    sr.margin,
    s.state_name
FROM statewise_results sr
JOIN states s
    ON sr.state_id = s.state_id
WHERE sr.margin < 50000
ORDER BY sr.margin ASC;


-- ============================================================
-- SECTION 4: MULTI-DIMENSIONAL ELECTION INSIGHTS
-- ============================================================

-- Query 12: State-wise seats won by each party
SELECT
    s.state_name,
    pr.party_name,
    COUNT(sr.constituency_id) AS seats_won
FROM statewise_results sr
JOIN states s
    ON sr.state_id = s.state_id
JOIN constituencywise_details cd
    ON sr.constituency_id = cd.constituency_id
JOIN partywise_results pr
    ON cd.party_id = pr.party_id
GROUP BY s.state_name, pr.party_name
ORDER BY s.state_name, seats_won DESC;


-- Query 13: Leading party per state (party with most seats in each state)
WITH state_party_seats AS (
    SELECT
        s.state_name,
        pr.party_name,
        COUNT(sr.constituency_id) AS seats_won,
        RANK() OVER (
            PARTITION BY s.state_name
            ORDER BY COUNT(sr.constituency_id) DESC
        ) AS rnk
    FROM statewise_results sr
    JOIN states s
        ON sr.state_id = s.state_id
    JOIN constituencywise_details cd
        ON sr.constituency_id = cd.constituency_id
    JOIN partywise_results pr
        ON cd.party_id = pr.party_id
    GROUP BY s.state_name, pr.party_name
)
SELECT
    state_name,
    party_name AS leading_party,
    seats_won
FROM state_party_seats
WHERE rnk = 1
ORDER BY state_name;


-- Query 14: Ranking constituencies by total votes within each state
-- (using window functions)
SELECT
    s.state_name,
    cr.constituency_name,
    cr.total_votes,
    RANK() OVER (
        PARTITION BY s.state_name
        ORDER BY cr.total_votes DESC
    ) AS rank_within_state
FROM constituencywise_results cr
JOIN statewise_results sr
    ON cr.constituency_name = sr.constituency
JOIN states s
    ON sr.state_id = s.state_id
ORDER BY s.state_name, rank_within_state;


-- ============================================================
-- END OF QUERIES
-- ============================================================
