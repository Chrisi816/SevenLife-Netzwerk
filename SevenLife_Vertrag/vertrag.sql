INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('custom_vertrag', 'Vertrag', '0', '1', '1'),
('vertrag_tasche', 'Akten koffer', '1', '1', '1');

CREATE TABLE IF NOT EXISTS`vertrag_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifer` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `beschreibung` varchar(800) DEFAULT NULL,
  `unterschrift` varchar(50) DEFAULT NULL,
  `unterschrift2` varchar(50) DEFAULT NULL;
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifer` (`identifer`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `vertrag_db` (`id`, `identifer`, `titel`, `beschreibung`, `unterschrift`, `unterschrift2`) VALUES
('1', '58fed2e48156829810005e837f7a51c2ed444ac9', 'Patrick hurensohn', 'Patrick muss mir 100$ mit Paypal bezahlen', 'Chrisi', 'Patrick Stalin');