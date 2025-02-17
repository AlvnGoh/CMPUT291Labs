SELECT DISTINCT w.usr_id
FROM watchlists w
JOIN watchlist_include wi ON w.wa_id = wi.wa_id
JOIN movies m ON wi.mov_id = m.mov_id
WHERE m.title = 'The Dark Knight'

UNION

-- Find users who have liked "Inception"
SELECT DISTINCT lm.usr_id
FROM like_movie lm
JOIN movies m ON lm.mov_id = m.mov_id
WHERE m.title = 'Inception';