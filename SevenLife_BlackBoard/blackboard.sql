CREATE TABLE IF NOT EXISTS `blackboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `description` varchar(900) DEFAULT NULL,
  `imgfrage` varchar(50) DEFAULT NULL,
  `src` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;