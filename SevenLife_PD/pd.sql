
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('gps', 'GPS', '3', '1', '1'),
('handschenllen', 'Handschenllen', '4', '1', '1'),
('pdwmunition', 'PDW Munition', '4', '1', '1'),
('tablet', 'tablet', '4', '1', '1'),

CREATE TABLE IF NOT EXISTS `pd_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vorname` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nachname` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL, 
  `url` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


CREATE TABLE IF NOT EXISTS `pd_akten` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `titel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL, 
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL, 
  `strafe` int(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL, 
  `haftstrafe` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT "false", 
  `datum` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `officer` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

ALTER TABLE `users` ADD COLUMN `illegalorlegal` INT(10) DEFAULT "1";

CREATE TABLE IF NOT EXISTS `pd_fahndungen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `titel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,  
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `pd_eingestellte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dienstnumer` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nummer` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,   
  `datum` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL, 
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
