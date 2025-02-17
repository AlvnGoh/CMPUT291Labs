SELECT DISTINCT l1.usr_id
FROM like_movie l1
JOIN have_dir d1 ON d1.mov_id = l1.mov_id
JOIN directors dir1 ON dir1.dir_id = d1.dir_id
JOIN like_movie l2 ON l1.usr_id = l2.usr_id  -- Self-join to the same table (l1 and l2 refer to the same user)
JOIN have_dir d2 ON d2.mov_id = l2.mov_id
JOIN directors dir2 ON dir2.dir_id = d2.dir_id
WHERE dir1.dir_name != 'Frank Darabont'  -- Exclude movies directed by Frank Darabont for movie 1
AND dir2.dir_name != 'Frank Darabont'  -- Exclude movies directed by Frank Darabont for movie 2
AND l1.mov_id != l2.mov_id;  -- Ensure the two movies are different