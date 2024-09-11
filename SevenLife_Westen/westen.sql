INSERT INTO `items`(name, label, `weight`, `rare`, `can_remove`) VALUES
("aramidfasern", "Aramidfasern", 2, 0 ,1),
("aramidgewebe", "Aramidgewebe", 2, 0, 1),
("eisen", "Eisen", 2,0,1),
("leichteweste", "Leichte Weste", 5 , 1 , 1),
("mitllereweste", "Mittlere Weste", 6 , 1 ,1),
("schwereweste", "Schwere Weste", 8, 1,1 ),
;

ALTER TABLE users 
ADD health VARCHAR(255) NULL DEFAULT NULL;