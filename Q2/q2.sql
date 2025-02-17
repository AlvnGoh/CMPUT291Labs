SELECT DISTINCT f.flwer  -- Follower user ID
FROM follows f
JOIN watchlists w1 ON f.flwer = w1.usr_id  -- Join followers' watchlists
JOIN watchlist_include wi1 ON w1.wa_id = wi1.wa_id  -- Join to include movies in the followers' watchlists
JOIN watchlists w2 ON f.flwee = w2.usr_id  -- Join the followed user's watchlists
JOIN watchlist_include wi2 ON w2.wa_id = wi2.wa_id  -- Join to include movies in the followed user's watchlists
WHERE wi1.mov_id = wi2.mov_id;  -- Find common movies in both users' watchlists