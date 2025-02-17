WITH AronFollowers AS (
    -- Find users who follow "Aron Gu"
    SELECT f.flwer AS usr_id
    FROM follows f
    JOIN users u ON u.usr_id = f.flwee 
    WHERE u.name = 'Aron Gu'
),
WatchlistMovies AS (
    -- Count the number of movies in each watchlist
    SELECT wa_id, COUNT(mov_id) AS movie_count
    FROM watchlist_include
    GROUP BY wa_id
),
UsersLikedWatchlist AS (
    -- Count the number of users who liked each watchlist
    SELECT wa_id, COUNT(DISTINCT usr_id) AS users_liked_count
    FROM like_watchlist
    GROUP BY wa_id
),
UsersFollowingAron AS (
    -- Count how many users who liked each watchlist follow "Aron Gu"
    SELECT l.wa_id, COUNT(DISTINCT l.usr_id) AS users_following_aron
    FROM like_watchlist l
    JOIN AronFollowers a ON l.usr_id = a.usr_id
    GROUP BY l.wa_id
)
-- Final query to select the required watchlist information
SELECT wm.wa_id, 
       wm.movie_count, 
       ulw.users_liked_count
FROM WatchlistMovies wm
JOIN UsersLikedWatchlist ulw ON wm.wa_id = ulw.wa_id
LEFT JOIN UsersFollowingAron ufa ON wm.wa_id = ufa.wa_id
WHERE wm.movie_count >= 7
  AND ulw.users_liked_count <= 10
  AND (ufa.users_following_aron * 1.0 / ulw.users_liked_count) >= 0.40;