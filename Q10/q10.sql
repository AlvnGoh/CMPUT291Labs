WITH TopLikes AS (
    -- Find the movies with the most total likes (movie likes + watchlist likes)
    SELECT mov_id, title, (like_count + wa_like_count) AS total_likes
    FROM movieStats
    ORDER BY total_likes DESC
    LIMIT 1  -- Get only the top movie (or movies in case of ties)
),
TopHours AS (
    -- Find the movies with the most hours watched
    SELECT mov_id, title, hrs_watched
    FROM movieStats
    ORDER BY hrs_watched DESC
    LIMIT 1  -- Get only the top movie (or movies in case of ties)
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
    movieStats ms;