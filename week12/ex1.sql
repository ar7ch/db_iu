-- schema

create (p:Fighter {name:'Khabib Nurmagomedov', weight:'155'});
create (p:Fighter {name:'Dos Anjos', weight:'155'});
create (p:Fighter {name:'Neil Magny', weight:'170'});
create (p:Fighter {name:'Jon Jones', weight:'205'});
create (p:Fighter {name:'Daniel Cormier', weight:'205'});
create (p:Fighter {name:'Michael Bisping', weight:'185'});
create (p:Fighter {name:'Matt Hamill', weight:'185'});
create (p:Fighter {name:'Brandon Vera', weight:'205'});
create (p:Fighter {name:'Frank Mir', weight:'230'});
create (p:Fighter {name:'Brock Lesnar', weight:'230'});
create (p:Fighter {name:'Kelvin Gastelum', weight:'185'});

MATCH (p:Fighter{name:'Khabib Nurmagomedov'}), (pp:Fighter{name:'Dos Anjos'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Dos Anjos'}), (pp:Fighter{name:'Neil Magny'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Jon Jones'}), (pp:Fighter{name:'Daniel Cormier'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Michael Bisping'}), (pp:Fighter{name:'Matt Hamill'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Jon Jones'}), (pp:Fighter{name:'Brandon Vera'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Brandon Vera'}), (pp:Fighter{name:'Frank Mir'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Frank Mir'}), (pp:Fighter{name:'Brock Lesnar'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Neil Magny'}), (pp:Fighter{name:'Kelvin Gastelum'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Kelvin Gastelum'}), (pp:Fighter{name:'Michael Bisping'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Michael Bisping'}), (pp:Fighter{name:'Matt Hamill'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Michael Bisping'}), (pp:Fighter{name:'Kelvin Gastelum'}) MERGE (p)-[:beats]->(pp)
MATCH (p:Fighter{name:'Matt Hamill'}), (pp:Fighter{name:'Jon Jones'}) MERGE (p)-[:beats]->(pp)







--  Return all middle/Walter/light weight fighters (155,170,185) who at least have one win.
MATCH (p:Fighter) WHERE EXISTS { MATCH (p)-[:beats]->(:Fighter) } and p.weight = '155' or p.weight='170' or p.weight='185' RETURN p.name

-- Return fighters who had 1-1 record with each other. Use Count from the aggregation functions.
MATCH (p)-[:beats]->(pp)-[:beats]->(p) 
with *, count((p)-[:beats]->(pp)) as ca, count((pp)-[:beats]->(p)) as cb
where ca = cb
return p.name, pp.name

-- Return all fighter that can “Khabib Nurmagomedov” beat them and he didn’t have a fight with them yet.
MATCH (p:Fighter {name: 'Khabib Nurmagomedov'})-[:beats *2..]->(pp:Fighter)
RETURN pp.name

-- Return undefeated Fighters(0 loss), defeated fighter (0 wins).
MATCH (p:Fighter) WHERE EXISTS { MATCH (p)-[:beats]->(:Fighter) } and NOT EXISTS { MATCH (:Fighter)-[:beats]->(p) } RETURN p.name
MATCH (p:Fighter) WHERE NOT EXISTS { MATCH (p)-[:beats]->(:Fighter) } and EXISTS { MATCH (:Fighter)-[:beats]->(p) } RETURN p.name

-- Return all fighters MMA records and create query to enter the record as a property for a fighter {name, weight, record}.
