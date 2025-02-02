
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE movieStats (
    mov_id          int,
    title           int,
    like_count      int,
    wa_like_count   int,
    hrs_watched     float,
    total_crew      int
);

INSERT INTO movieStats (mov_id, title, like_count, wa_like_count, hrs_watched, total_crew) VALUES
(1, 'The Shawshank Redemption', 1, 2, 1.0, 3),
(2, 'The Godfather', 1, 2, 5.7, 3),
(3, 'The Dark Knight', 0, 2, 4.0, 3),
(4, 'Pulp Fiction', 1, 1, 0.5, 3),
(5, 'Forrest Gump', 1, 5, 0.83, 2),
(6, 'Inception', 1, 3, 1.0, 1),
(7, 'The Matrix', 1, 2, 2.0, 2),
(8, 'Fight Club', 2, 1, 1.5, 2),
(9, 'The Lord of the Rings: The Fellowship of the Ring', 1, 3, 7.5, 2),
(10, 'The Social Network', 1, 2, 0.0, 1);
COMMIT;