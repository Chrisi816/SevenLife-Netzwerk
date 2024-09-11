CREATE TABLE IF NOT EXISTS `anfangsmissionen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `missionid` varchar(250) DEFAULT NULL,
  `progress` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
