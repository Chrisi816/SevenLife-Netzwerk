CREATE TABLE IF NOT EXISTS `owned_lager` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `lagerNumber` int(11) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `lagerValue` int(11) DEFAULT NULL,`btc` int(20) DEFAULT "0",
  `eth` int(20) DEFAULT "0",
  `lagerused` int(20) DEFAULT "0",
  `platz` varchar(20) DEFAULT "false",
  `mining` varchar(20) DEFAULT "false",
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

ALTER TABLE `owned_lager` 
ADD `btc` int(20) DEFAULT "0",
ADD `eth` int(20) DEFAULT "0",
ADD `lagerused` int(20) DEFAULT "0",
ADD `platz` varchar(20) DEFAULT "false",
ADD `mining` varchar(20) DEFAULT "false",


CREATE TABLE IF NOT EXISTS `shipments` (
  `id` int(11) DEFAULT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `count` varchar(50) DEFAULT NULL,
  `time` int(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `lager` (  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lagerNumber` int(11) DEFAULT NULL,
  `src` varchar(100) DEFAULT NULL,
  `count` varchar(50) DEFAULT NULL,
  `item` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `miningrigs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lagerNumber` int(11) DEFAULT NULL,
  `src` varchar(100) DEFAULT NULL,
  `item` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL, 
  `types` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;




INSERT INTO `owned_lager` (`identifier`, `lagerNumber`, `label`, `item`,`lagerValue`) VALUES
  ('0', 1, "", "", 280000),
  ('0', 2, "", "",220000),
  ('0', 3, "", "",235000),
  ('0', 4, "", "",285000),
  ('0', 5, "", "",135000),
  ('0', 6, "","", 235000),
  ('0', 7, "", "",160000),
  ('0', 8, "", "",275000),
  ('0', 9, "", "",265000),
  ('0', 10, "","", 300000),
  ('0', 12, "","", 145000),
  ('0', 13, "", "",145000),
  ('0', 14, "","", 280000),
  ('0', 15, "","", 300000),
  ('0', 16, "","", 435000),
  ('0', 18, "","", 235000),
  ('0', 11, "","", 225000),
  ('0', 19, "", "",150000),
  ('0', 20, "", "",165000),
  ('0', 17, "", "",150000),
  ('0', 21, "","", 300000),
  ('0', 22, "","", 145000),
  ('0', 23, "", "",145000),
  ('0', 24, "","", 280000),
  ('0', 25, "","", 300000),
  ('0', 26, "","", 435000),
  ('0', 27, "","", 235000),
  ('0', 28, "","", 225000),
  ('0', 29, "", "",150000),
  ('0', 30, "", "",165000),
  ('0', 31, "","", 300000),
  ('0', 32, "","", 145000),
  ('0', 33, "", "",145000),
  ('0', 34, "","", 280000),
  ('0', 35, "","", 300000),
  ('0', 36, "","", 435000),
  ('0', 37, "","", 235000),
  ('0', 38, "","", 225000),
  ('0', 39, "", "",150000),
  ('0', 40, "", "",165000);

  
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('sGPU',"SEVENGPU 1000Mhz", 2, 1, 1),
  ('lGPU',"SEVENGPU 2000Mhz", 2, 1, 1),
  ('seGPU',"SEVENGPU 3000Mhz", 2, 1, 1),
  ('sCPU',"SEVENCPU 1Ghz", 2, 1, 1),
  ('lCPU',"SEVENCPU 2Ghz", 2, 1, 1),
  ('seCPU',"SEVENCPU 3Ghz", 2, 1, 1),
  ('sRAM',"SEVENRAM 1GB", 2, 1, 1),
  ('lRAM',"SEVENRAM 4GB", 2, 1, 1),
  ('seRAM',"SEVENRAM 8GB", 2, 1, 1),

