WITH RECURSIVE way AS (

 (SELECT nodes.point1, nodes.point2, array[point1] AS tour, cost
 from nodes
 WHERE nodes.point1 = 'A')

 UNION

 (SELECT nodes.point1, nodes.point2, (way.tour || nodes.point1)
   AS tour, way.cost + nodes.cost
 FROM way
 JOIN nodes
 ON nodes.point1 = way.point2
 WHERE nodes.point1 NOT IN (SELECT UNNEST(way.tour)))
),

 tour_cost AS
 (SELECT cost AS total_cost, (tour || point2) AS tour
 FROM way
 WHERE (SELECT array_length(way.tour, 1)) = 4
   AND point2 = 'A'
 ORDER BY cost, tour)

SELECT * FROM tour_cost
ORDER BY 1, 2;