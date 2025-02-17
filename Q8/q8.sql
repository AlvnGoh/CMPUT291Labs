WITH UserMovies AS (
    -- Movies directly liked by the user and movies in watchlists liked by the user
    SELECT usr_id, mov_id
    FROM like_movie
    UNION
    SELECT lw.usr_id, wi.mov_id
    FROM like_watchlist lw
    JOIN watchlist_include wi ON lw.wa_id = wi.wa_id
),
UserWatchTime AS ( 
    -- Calculate the total time each user has spent watching movies
    SELECT usr_id, SUM(julianday(ses_end) - julianday(ses_start)) * 24 AS total_watch_time
    FROM sessions
    GROUP BY usr_id
),
TopUsers AS (
    -- Find the top 5 users based on the total time spent watching movies
    SELECT usr_id, total_watch_time
    FROM UserWatchTime
    ORDER BY total_watch_time DESC
    LIMIT 5
),
UserLikedMovies AS (
    -- Calculate the total number of distinct movies liked by each user (including those in liked watchlists)
    SELECT usr_id, COUNT(DISTINCT mov_id) AS liked_movies_count
    FROM UserMovies
    GROUP BY usr_id
),
UserMostPopularWatchlist AS (
    -- Find the most popular watchlist for each user (the watchlist they created with the most likes)
    SELECT w.usr_id, w.wa_id, w.title, COUNT(lw.usr_id) AS like_count
    FROM watchlists w
    LEFT JOIN like_watchlist lw ON w.wa_id = lw.wa_id
    GROUP BY w.usr_id, w.wa_id, w.title
),
TopUserMostPopularWatchlist AS (
    -- Find the most popular watchlist for each top user
    SELECT upw.usr_id, upw.wa_id, upw.title, upw.like_count
    FROM UserMostPopularWatchlist upw
    JOIN TopUsers tu ON upw.usr_id = tu.usr_id
    WHERE (upw.usr_id, upw.like_count) IN (
        -- Get the maximum like count for each user to account for ties
        SELECT usr_id, MAX(like_count)
        FROM UserMostPopularWatchlist
        GROUP BY usr_id
    )
)
-- Final query to join everything and return the required data
SELECT tu.usr_id, 
       COALESCE(ulm.liked_movies_count, 0) AS total_movies_liked,
       tumpw.wa_id AS most_popular_watchlist_id,
       tumpw.title AS most_popular_watchlist_title,
       tumpw.like_count AS most_popular_watchlist_likes
FROM TopUsers tu
LEFT JOIN UserLikedMovies ulm ON tu.usr_id = ulm.usr_id
LEFT JOIN TopUserMostPopularWatchlist tumpw ON tu.usr_id = tumpw.usr_id
ORDER BY tu.usr_id;