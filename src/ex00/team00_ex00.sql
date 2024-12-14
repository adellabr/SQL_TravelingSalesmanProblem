CREATE TABLE nodes(
  ID serial PRIMARY KEY,
  point1 varchar not null,
 point2 varchar not null,
 cost bigint not null default 0
);

INSERT INTO nodes (point1, point2, cost)
VALUES ('A', 'B', 10),
       ('A', 'C', 15),
       ('A', 'D', 20),
       ('B', 'A', 10),
       ('B', 'C', 35),
       ('B', 'D', 25),
       ('C', 'A', 15),
       ('C', 'B', 35),
       ('C', 'D', 30),
       ('D', 'A', 20),
       ('D', 'B', 25),
       ('D', 'C', 30);

SELECT *
  FROM nodes;

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
WHERE total_cost = (SELECT MIN(total_cost)
       FROM tour_cost)
ORDER BY 1, 2;