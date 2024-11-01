--Netflix Project

CREATE TABLE netflix(

	show_id VARCHAR(10),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(210),	
	casts	VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,	
	rating	VARCHAR(10),
	duration VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)

);



SELECT * FROM netflix;

SELECT 
	DISTINCT type
FROM
	netflix;




--Business Problems for Netflix Dataset

1.Determine the Most Popular Genres by Country
 Identify the most popular genres in each country based on the number of shows and movies listed under each genre.

SELECT * FROM netflix;


SELECT
	country, listed_in, COUNT(*) AS genre_count
FROM netflix
WHERE 
	country IS NOT NULL AND listed_in IS NOT NULL
GROUP BY country, listed_in
ORDER BY country, genre_count DESC
LIMIT 10;


2.Find the most common rating for Movies and TV Shows
 Identify which rating (like PG, PG-13, R, etc.) appears the most frequently across Netflix content.

SELECT type, rating, rating_count
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as rank
    FROM netflix
    WHERE rating IS NOT NULL
    GROUP BY type, rating
) AS ranked_ratings
WHERE rank = 1;


3.List all movies released in  2019
 Extract the movies that were released in the  year 2019, filtering by the release_year column.
 
 
 SELECT
 	title, release_year
 FROM netflix
 WHERE type = 'Movie' AND release_year = 2019;


4.Find the top 5 countries with the most content on Netflix
Determine which countries have contributed the most content to Netflixs catalog.


SELECT
	country, COUNT(*) as content_count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC
LIMIT 5

5.Identify the longest movie or TV show duration
 Find the movie the longest runtime or number of episodes.

 
 SELECT * FROM netflix
 WHERE 
 	type = 'Movie'
 AND
 	duration = (SELECT MAX(duration) FROM netflix)
 	
 

6.Find content added in the last 5 years
 List the content that has been added to Netflix within the last five years, using the date_added field.
 
SELECT 
    TO_DATE(date_added, 'Month DD, YYYY') AS converted_date
FROM netflix;

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

 

7.Find all the movies/Tv Shows by director 'Steven Spielberg'
Extract all movies or TV shows that were directed by the famous director Steven Spielberg.

SELECT * 
FROM netflix
WHERE director = 'Steven Spielberg'


8.List all TV shows with more than 5 seasons
 Identify TV shows that have more than 5 seasons (assuming the duration field contains season information).

 SELECT 
 	*,
 	CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS sessions
FROM netflix
WHERE
 	type = 'TV Show' 
 	AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;

	 

9.Count the number of content items in each genre
 Count how many content items belong to each genre (using the listed_in field for genres).

 SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ' ')) as genre,
	COUNT(show_id) as total_content
 FROM netflix
 GROUP BY 1


10.Find the average content per year produced  in a specific country
 Calculate the average content per year that was produced in 'Nigeria'.
 


 SELECT
    AVG(content_per_year) AS avg_content_per_year
FROM (
    SELECT 
        release_year, 
        COUNT(show_id) AS content_per_year
    FROM netflix
    WHERE country = 'Nigeria'
    GROUP BY release_year
) AS yearly_content;


11.List all movies that are documentaries
 Extract all the movies classified as documentaries, using the listed_in field for filtering.

SELECT 
	title, listed_in
FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';


	
12.Find all content without a director
 Find the entries where no director is listed (i.e., the director field is NULL or empty).

SELECT * FROM netflix
WHERE director IS null


13.Find how many movies have descriptions with keywords 'AI', 'Sci-Fi', or 'Space'
 Search the description field for keywords related to "AI", "Sci-Fi", or "Space" and count how many movies contain these keywords.

SELECT
	title, 
	description
FROM netflix
WHERE
	description LIKE '%AI%' OR description LIKE '%Sci-Fi%' OR description LIKE '%Space%';

14.Find the Most Common Cast Members
 Identify the most frequently occurring actors/actresses across the dataset

 SELECT 
    actor,
    COUNT(show_id) AS appearances
FROM (
    SELECT 
        show_id,
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor
    FROM netflix
) AS actor_list
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;


15.Identify Top 10 Countries Producing TV Shows
 Find out which countries have produced the most TV shows in the dataset


 SELECT 
    country,
    COUNT(show_id) AS tv_show_count
FROM netflix
WHERE country is not null AND type = 'TV Show'
GROUP BY country
ORDER BY tv_show_count DESC
LIMIT 10;

