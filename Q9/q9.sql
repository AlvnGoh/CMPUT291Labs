DROP VIEW IF EXISTS movieStats;

CREATE VIEW movieStats AS
SELECT 
    m.mov_id, 
    m.title,
    -- Calculate the total number of likes for the movie
    COALESCE(COUNT(DISTINCT lm.usr_id), 0) AS like_count,
    -- Calculate the total number of likes for the watchlists that include the movie
    COALESCE(COUNT(DISTINCT lw.usr_id), 0) AS wa_like_count,
    -- Calculate the total hours the movie was watched
    COALESCE(SUM(DISTINCT s.fr_cnt), 0) AS hrs_watched,
    -- Calculate the total number of distinct cast and directors
    COALESCE(COUNT(DISTINCT hc.cast_id), 0) + COALESCE(COUNT(DISTINCT hd.dir_id), 0) AS total_crew
FROM 
    movies m
-- Join the like_movie table to get the like count for the movie
LEFT JOIN like_movie lm ON m.mov_id = lm.mov_id
-- Join the watchlist_include table to determine which watchlists include the movie
LEFT JOIN watchlist_include wi ON m.mov_id = wi.mov_id
-- Join the like_watchlist table to get the likes for watchlists including the movie
LEFT JOIN like_watchlist lw ON wi.wa_id = lw.wa_id
-- Join the ses_watched table to calculate the total hours the movie was watched
LEFT JOIN ses_watched s ON m.mov_id = s.mov_id
-- Join the have_cast table to get cast members for the movie
LEFT JOIN have_cast hc ON m.mov_id = hc.mov_id
-- Join the have_dir table to get directors for the movie
LEFT JOIN have_dir hd ON m.mov_id = hd.mov_id
GROUP BY 
    m.mov_id, 
    m.title;

SELECT * FROM movieStats;