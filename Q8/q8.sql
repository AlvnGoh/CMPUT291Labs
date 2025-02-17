WITH UserWatchTime AS (
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
    -- Calculate the total number of movies liked by each user
    SELECT usr_id, COUNT(DISTINCT mov_id) AS liked_movies_count
    FROM like_movie
    GROUP BY usr_id
),
UserLikedWatchlists AS (
    -- Calculate the total number of movies in watchlists liked by each user
    SELECT l.usr_id, COUNT(DISTINCT wi.mov_id) AS liked_watchlist_movies_count
    FROM like_watchlist l
    JOIN watchlist_include wi ON l.wa_id = wi.wa_id
    GROUP BY l.usr_id
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
       COALESCE(ulm.liked_movies_count, 0) + COALESCE(ulw.liked_watchlist_movies_count, 0) AS total_movies_liked,
       tumpw.wa_id AS most_popular_watchlist_id,
       tumpw.title AS most_popular_watchlist_title,
       COALESCE(tumpw.like_count, 0) AS most_popular_watchlist_likes
FROM TopUsers tu
LEFT JOIN UserLikedMovies ulm ON tu.usr_id = ulm.usr_id
LEFT JOIN UserLikedWatchlists ulw ON tu.usr_id = ulw.usr_id
LEFT JOIN TopUserMostPopularWatchlist tumpw ON tu.usr_id = tumpw.usr_id;