CREATE TABLE IF NOT EXISTS `notizenspieler` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` int(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL;,
  `notiz` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `markierung` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `markierungnachricht` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `einstellungenadmins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` int(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chataktiv` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,

  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;