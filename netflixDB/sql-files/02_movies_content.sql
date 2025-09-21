-- Find top 5 highest-rated movies.
SELECT 
    title,
    rating
FROM netflix.movies
ORDER BY rating DESC
FETCH FIRST 5 ROWS ONLY;

-- Show the most popular genre watched.
SELECT 
    m.genre,
    SUM(w.watch_duration) AS watch_duration
FROM netflix.movies m
INNER JOIN netflix.watch_history w ON w.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY watch_duration DESC;

-- List movies released after 2020 that have never been watched.
SELECT
    m.title,
    m.release_year
FROM netflix.movies m
LEFT JOIN netflix.watch_history w ON w.movie_id = m.movie_id
WHERE m.release_year > 2020 AND 
    w.movie_id IS NULL;