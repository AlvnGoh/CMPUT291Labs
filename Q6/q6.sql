WITH UserFollowers AS (
    -- Find users with no more than 3 followers
    SELECT flwee AS usr_id
    FROM follows
    GROUP BY flwee
    HAVING COUNT(DISTINCT flwer) <= 3
),
MovieWatchHours AS (
    -- Calculate total watch hours per movie for each user
    SELECT s.usr_id, 
           m.mov_id, 
           m.title AS movie_title, 
           SUM(julianday(s.ses_end) - julianday(s.ses_start)) * 24 AS total_hours  -- Calculate hours from ses_start to ses_end
    FROM ses_watched sw
    JOIN sessions s ON s.ses_id = sw.ses_id
    JOIN movies m ON m.mov_id = sw.mov_id
    GROUP BY s.usr_id, m.mov_id, m.title
),
MaxWatchHours AS (
    -- For each user, find the maximum number of hours spent watching a movie
    SELECT usr_id, MAX(total_hours) AS max_hours
    FROM MovieWatchHours
    GROUP BY usr_id
)
-- Final query to select the required fields
SELECT u.usr_id, 
       u2.name AS user_name, 
       mw.mov_id, 
       mw.movie_title, 
       mw.total_hours
FROM UserFollowers u
LEFT JOIN MovieWatchHours mw ON u.usr_id = mw.usr_id
LEFT JOIN MaxWatchHours mh ON mw.usr_id = mh.usr_id AND mw.total_hours = mh.max_hours
LEFT JOIN users u2 ON u2.usr_id = u.usr_id
ORDER BY u.usr_id;