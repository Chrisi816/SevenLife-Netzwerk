CREATE TABLE IF NOT EXISTS `waffenschrank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frak` varchar(255) DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `label` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `anzahl` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
 PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `fraktionen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frak` varchar(255) DEFAULT NULL,
  `anfuehrer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `level` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `xp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,  
  `reichtum` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `mitglieder` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `krimminellepunkte` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL, 
  `gebiete` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
 PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

INSERT INTO `fraktionen`(`frak`, `anfuehrer`, `level`, `xp`, `reichtum`, `mitglieder`, `krimminellepunkte`, `gebiete`) VALUES
("LCN", "Jack Line", "0", "0", "0" ,"1", "0", "0"),

INSERT INTO `fraktionen`(`frak`, `anfuehrer`, `level`, `xp`, `reichtum`, `mitglieder`, `krimminellepunkte`, `gebiete`) VALUES
("VVZ", "Patrick Stalin", "0", "0", "0" ,"1", "0", "1"),

INSERT INTO `fraktionen`(`frak`, `anfuehrer`, `level`, `xp`, `reichtum`, `mitglieder`, `krimminellepunkte`, `gebiete`) VALUES
("TRIADEN", "Christian Espasito", "0", "0", "0" ,"1", "0", "1"),

INSERT INTO `fraktionen`(`frak`, `anfuehrer`, `level`, `xp`, `reichtum`, `mitglieder`, `krimminellepunkte`, `gebiete`) VALUES
("HOH", "Nico", "0", "0", "0" ,"1", "0", "1"),

CREATE TABLE IF NOT EXISTS `fraktionenmitglieder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  
  `frak` varchar(255) DEFAULT NULL,
  `iduniqe` int(11) DEFAULT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `rang` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `datajoin` varchar(255)DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

INSERT INTO `fraktionenmitglieder`(`frak`, `iduniqe`, `identifier`, `name`, `rang`) VALUES
("LCN", "2", "58fed2e48156829810005e837f7a51c2ed444ac9", "Christian Esapsito", "Associates");


INSERT INTO `fraktionenmitglieder`(`frak`, `iduniqe`, `identifier`, `name`, `rang`) VALUES
("LCN", "2", "a65b27827ab1ac4bf3e6f475175a3dc2477eecab", "Jack Line", "DON");

INSERT INTO `items`(name, label, `weight`, `rare`, `can_remove`) VALUES
("schwarzerose", "Schwarze Rose", 1, 1 ,2),
("gebietskarte", "Gebiets Karte", 1, 1 ,2);