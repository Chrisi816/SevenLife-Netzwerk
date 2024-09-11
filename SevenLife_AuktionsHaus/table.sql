CREATE TABLE IF NOT EXISTS `auktionen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `inhalt` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `count` varchar(50) DEFAULT NULL,
  `startpreis` varchar(50) DEFAULT NULL,
  `endpreis` varchar(50) DEFAULT NULL,
  `startzeit` varchar(50) DEFAULT NULL,
  `endezeit` varchar(250) DEFAULT NULL,
  `kategorie` varchar(50) DEFAULT NULL,
  `bieter`varchar(50) DEFAULT NULL,
  `hoesterbieter` varchar(250) DEFAULT NULL,
  `sofort`varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;