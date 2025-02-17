WITH UserLikedMovies AS (
    -- Find users who liked movies from a watchlist but not the watchlist itself
    SELECT DISTINCT li.usr_id, wi.wa_id
    FROM like_movie li
    JOIN watchlist_include wi ON li.mov_id = wi.mov_id
    LEFT JOIN like_watchlist lw ON li.usr_id = lw.usr_id AND wi.wa_id = lw.wa_id
    GROUP BY li.usr_id, wi.wa_id
    HAVING COUNT(DISTINCT li.mov_id) >= 3 AND lw.usr_id IS NULL
),
ExcludedWatchlists AS (
    -- Identify the watchlists to exclude
    SELECT DISTINCT wa_id
    FROM UserLikedMovies
)
-- Final query to get all watchlists excluding the ones identified
SELECT w.wa_id, w.title AS watchlist_title, u.name AS creator_name
FROM watchlists w
JOIN users u ON w.usr_id = u.usr_id
WHERE w.wa_id NOT IN (SELECT wa_id FROM ExcludedWatchlists);