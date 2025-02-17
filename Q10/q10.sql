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
SELECT 
    ms.mov_id, 
    ms.title,
    -- Determine if it's top in likes or hours watched
    CASE
        WHEN ms.mov_id IN (SELECT mov_id FROM TopLikes) THEN 'top in likes'
        WHEN ms.mov_id IN (SELECT mov_id FROM TopHours) THEN 'top in hours watched'
        ELSE NULL
    END AS top_type
FROM 
    movieStats ms
WHERE ms.mov_id IN (SELECT mov_id FROM TopLikes) 
   OR ms.mov_id IN (SELECT mov_id FROM TopHours)
ORDER BY top_type DESC, ms.mov_id;