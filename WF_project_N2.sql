-- LAG AND LEAD
SELECT 
	s.artist
	,s.week
	,s.streams_millions
	,LAG(s.streams_millions, 1, s.streams_millions) OVER(PARTITION BY s.artist ORDER BY s.week ASC) - s.streams_millions AS streams_millions_change
	,s.chart_position
	,LAG(s.chart_position, 1, s.chart_position) OVER(PARTITION BY s.artist ORDER BY s.week ASC) - s.chart_position AS chart_position_change
FROM 
	windows_functions.streams AS s;

--ROW_NUMBER
SELECT 
	s.artist
	,s.week
	,s.streams_millions
	,ROW_NUMBER() OVER(ORDER BY s.streams_millions ASC) AS row_num
FROM 
	windows_functions.streams AS s;

WITH our_rows AS
	(SELECT 
		s.artist
		,s.week
		,s.streams_millions
		,ROW_NUMBER() OVER(ORDER BY s.streams_millions ASC) AS row_num
	FROM 
		windows_functions.streams AS s)
SELECT *
FROM
	our_rows
WHERE 
	row_num = 30
	
--RANK AND DENSE_RANK
SELECT 
	s.artist,
	s.week
	,s.streams_millions
	,RANK() OVER(PARTITION BY s.week ORDER BY s.streams_millions ASC) AS rank_result
	,DENSE_RANK() OVER(PARTITION BY s.week ORDER BY s.streams_millions ASC) AS dense_rank_result
FROM
	windows_functions.streams AS s
	
	
--NTILE
SELECT 
	s.artist
	,s.week
	,s.streams_millions
	,NTILE(4) OVER(PARTITION BY s.week ORDER BY s.streams_millions)
FROM
	windows_functions.streams AS s
	
	
-- STATE_CLIMATE
