WITH TopLikes AS (
    -- Find the movies with the most total likes (movie likes + watchlist likes)
    SELECT mov_id, title, (like_count + wa_like_count) AS total_likes
    FROM movieStats
    WHERE (like_count + wa_like_count) = (
        SELECT MAX(like_count + wa_like_count)
        FROM movieStats
    )
),
TopHours AS (
    -- Find the movies with the most hours watched
    SELECT mov_id, title, hrs_watched
    FROM movieStats
    WHERE hrs_watched = (
        SELECT MAX(hrs_watched)
        FROM movieStats
    )
)
-- Combine the TopLikes and TopHours, allowing each movie to be listed twice if necessary
SELECT 
    ms.mov_id, 
    ms.title,
    'top in likes' AS top_type
FROM 
    movieStats ms
WHERE ms.mov_id IN (SELECT mov_id FROM TopLikes)

UNION ALL

SELECT 
    ms.mov_id, 
    ms.title,
    'top in hours watched' AS top_type
FROM 
    movieStats ms
WHERE ms.mov_id IN (SELECT mov_id FROM TopHours)

ORDER BY mov_id, top_type DESC;