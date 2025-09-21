-- Find top 10 users by total watch duration.
SELECT
    u.name,
    SUM(w.watch_duration) AS watch_duration
FROM netflix.users u
INNER JOIN netflix.watch_history w ON w.user_id = u.user_id
GROUP BY u.name
ORDER BY watch_duration DESC
FETCH FIRST 10 ROWS ONLY;

-- List movies watched more than 7 times.
SELECT
    m.title,
    COUNT(w.movie_id) AS watch_count
FROM netflix.movies m
INNER JOIN netflix.watch_history w ON w.movie_id = m.movie_id
GROUP BY m.title
HAVING COUNT(w.movie_id) > 7;