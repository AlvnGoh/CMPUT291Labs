WITH UserFollowers AS (
    -- Find users with no more than 3 followers
    SELECT u.usr_id AS usr_id
    FROM users u
    LEFT JOIN follows f ON f.flwee = u.usr_id
    GROUP BY u.usr_id
    HAVING COUNT(DISTINCT f.flwer) <= 3 OR COUNT(DISTINCT f.flwer) IS NULL
),
MovieWatchHours AS (
    -- Calculate total watch hours per movie for each user
    SELECT sw.usr_id as usr_id, 
           m.mov_id, 
           m.title AS movie_title,
           SUM(sw.fr_cnt) AS total_hours  -- Calculate hours from ses_start to ses_end
    FROM ses_watched sw
    JOIN movies m ON m.mov_id = sw.mov_id
    GROUP BY sw.usr_id, m.mov_id, m.title
),
MaxWatchHours AS (
    -- For each user, find the maximum number of hours spent watching a movie
    SELECT usr_id, mov_id, movie_title, MAX(total_hours) AS max_hours
    FROM MovieWatchHours
    GROUP BY usr_id
)
-- Final query to select the required fields
SELECT u.usr_id, 
       u2.name AS user_name, 
       mh.mov_id, 
       mh.movie_title, 
       mh.max_hours
FROM UserFollowers u
LEFT JOIN MaxWatchHours mh ON u.usr_id = mh.usr_id
LEFT JOIN users u2 ON u2.usr_id = u.usr_id
ORDER BY u.usr_id;