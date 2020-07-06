LOAD CSV WITH HEADERS FROM 'file:///relation.csv' AS line
WITH line.S AS Subject, line.V AS p, line.O AS Object
MATCH (s{title:Subject}), (o{title:Object})
CALL apoc.create.relationship(s, p, {}, o) YIELD rel
RETURN *;