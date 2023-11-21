WITH map_table AS 
(
	SELECT DISTINCT * FROM "MAP"
),

mapped_table_a AS 
(
	SELECT
		tab_a.dimension_1,
		mt.correct_dimension_2 AS dimension_2,
		tab_a.measure_1
	FROM "Table A" AS tab_a
	LEFT JOIN map_table AS mt
		ON tab_a.dimension_1 = mt.dimension_1	
),

mapped_table_b AS 
(
	SELECT
		tab_b.dimension_1,
		mt.correct_dimension_2 AS dimension_2,
		tab_b.measure_2
	FROM "Table B" AS tab_b
	LEFT JOIN map_table AS mt
		ON tab_b.dimension_1 = mt.dimension_1	
),

table_union AS 
(
	SELECT 
		dimension_1,
		dimension_2,
		measure_1,
		0 AS measure_2
	FROM mapped_table_a
	UNION ALL
	SELECT
		dimension_1,
		dimension_2,
		0 AS measure_1,
		measure_2
	FROM mapped_table_b
), 

aggregation AS (
	SELECT 	
		dimension_1,
		dimension_2,
		SUM(measure_1) AS measure_1,
		SUM(measure_2) AS measure_2
	FROM table_union
	GROUP BY 1,2 
)

SELECT 
	COALESCE(dimension_1, 'Unknown') AS dimension_1,
	COALESCE(dimension_2, 'Unknown') AS dimension_1,
	COALESCE(measure_1, 0) AS measure_1,
	COALESCE(measure_2, 0) AS measure_2
FROM aggregation