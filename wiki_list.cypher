//CREATE Categories
LOAD CSV WITH HEADERS FROM 'file:///wiki_list.csv' AS list
WITH trim(list.Type) AS type, trim(list.Categories) AS categories, trim(list.url) AS url, trim(list.Title) AS title, trim(list.Gender) AS gender WHERE type='Category'
CREATE (n:Category{title:trim(title),parents:categories,url:url,gender:gender}) RETURN *;

//CREATE category relations
MATCH (n:Category) WHERE NOT n.parents='***' 
UNWIND [p IN split(n.parents, ",")|trim(p)] AS parent
MATCH (m:Category{title:parent})
CREATE (n)-[:subClassOf]->(m) RETURN *;

//create individuals and individual-category relations
LOAD CSV WITH HEADERS FROM 'file:///wiki_list.csv' AS list
WITH trim(list.Type) AS type, trim(list.Categories) AS categories, list.Title AS title, trim(list.url) AS url, trim(list.Gender) AS gender WHERE type='Individual'
CALL apoc.create.node([c IN split(categories, ",")|trim(c)], {title:title, categories:categories, url:url, gender:gender}) YIELD node
WITH categories, node AS n UNWIND [c IN split(categories, ",")|trim(c)] AS category
MATCH (m:Category{title:category})
CREATE (n)-[:ObjectOneOf]->(m) RETURN *;