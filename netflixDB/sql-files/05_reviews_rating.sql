-- Find average rating for each movie.
SELECT 
    m.title,
    ROUND(AVG(r.rating),2) as average_rating
FROM netflix.movies m
LEFT JOIN netflix.reviews r ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY average_rating NULLS LAST;

-- List movies with more than 50 reviews.
SELECT
    m.title,
    SUM(r.review_id) AS review_count
FROM netflix.movies m 
INNER JOIN netflix.reviews r ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING SUM(r.review_id) > 50
ORDER BY review_count DESC NULLS LAST;

-- Show users who rated more than 1 movie.
SELECT 
    u.name,
    COUNT(r.review_id) AS reviews_given
FROM netflix.reviews r
INNER JOIN netflix.movies m ON m.movie_id = r.movie_id
INNER JOIN netflix.users u ON u.user_id = r.user_id
GROUP BY u.name
HAVING COUNT(r.review_id) > 1;

SELECT 
    u.name, 
    COUNT(DISTINCT r.movie_id) AS distinct_movie_reviews
FROM netflix.users u
JOIN netflix.reviews r ON u.user_id = r.user_id
GROUP BY u.name
HAVING COUNT(DISTINCT r.movie_id) > 1
ORDER BY u.name;