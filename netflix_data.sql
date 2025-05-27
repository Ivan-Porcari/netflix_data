-- TASK1 HANDLING FOREING CHARACTERS

--CREATE TABLE [dbo].[netflix_raw](
--	[show_id] [varchar](10) NULL,
--	[type] [varchar](10) NULL,
--	[title] [nvarchar](200) NULL,
--	[director] [varchar](250) NULL,
--	[cast] [varchar](1000) NULL,
--	[country] [varchar](150) NULL,
--	[date_added] [varchar](20) NULL,
--	[release_year] [int] NULL,
--	[rating] [varchar](10) NULL,
--	[duration] [varchar](10) NULL,
--	[listed_in] [varchar](100) NULL,
--	[description] [varchar](500) NULL
--) 


-- TASK2 REMOVE DUPLICATES

SELECT show_id, COUNT(*) 
FROM netflix_raw
GROUP BY show_id
HAVING COUNT(*) >1

-- THERE ISN'T DUPLICATES SO WE CAN ESTABLISHED AS PRIMARY KEY show_id CREATING AGAIN THE TABLE
-- 

SELECT * FROM netflix_raw

-- CHECK THE SAME BUT INSTEAD OF show_id WITH title

SELECT title, COUNT(*) 
FROM netflix_raw
GROUP BY title
HAVING COUNT(*) >1

SELECT * FROM netflix_raw
WHERE UPPER(title) IN (
SELECT UPPER(title), type
FROM netflix_raw
GROUP BY UPPER(title), type
HAVING COUNT(*) >1
)
ORDER BY title


SELECT * FROM netflix_raw
WHERE CONCAT(UPPER(title), type) IN (
SELECT CONCAT(UPPER(title), type)
FROM netflix_raw
GROUP BY UPPER(title), type
HAVING COUNT(*) >1
)
ORDER BY title

WITH cte AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY title, type ORDER BY show_id) AS rn
FROM netflix_raw
)
SELECT * 
FROM cte 
WHERE rn=1


-- TASK 3 NEW TABLE FOR listed_in, director, country, cast
	SELECT show_id, VALUE AS genre
	FROM netflix_raw
	CROSS APPLY string_split(director,',')