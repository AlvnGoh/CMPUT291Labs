WITH AvgCastMembers AS (
    -- Calculate the average number of cast members per movie
    SELECT AVG(cast_count) AS avg_cast_count
    FROM (
        SELECT COUNT(hc.cast_id) AS cast_count
        FROM movies m
        LEFT JOIN have_cast hc ON m.mov_id = hc.mov_id
        GROUP BY m.mov_id
    ) AS movie_casts
),
LikedMovies AS (
    -- Find the movies liked by users and their cast count
    SELECT lm.usr_id, lm.mov_id
    FROM like_movie lm
    JOIN have_cast hc ON lm.mov_id = hc.mov_id
    GROUP BY lm.usr_id, lm.mov_id
    HAVING COUNT(hc.cast_id) >= (SELECT avg_cast_count FROM AvgCastMembers)
)
-- Final query to get the user information
SELECT DISTINCT u.usr_id, u.name
FROM users u
JOIN LikedMovies lm ON u.usr_id = lm.usr_id;